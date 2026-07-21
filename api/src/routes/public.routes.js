import { Router } from "express";

import { pool } from "../db.js";
import { ensureLogoDesignsTable } from "../logoDesignsTable.js";
import { asyncHandler } from "../utils/asyncHandler.js";

export const publicRoutes = Router();

function normalizeClientKey(name = "", logoUrl = "") {
  const value = `${name} ${logoUrl}`
    .toLowerCase()
    .replace(/bank\s*of\s*india|\bboi\b/g, "bankofindia")
    .replace(/indian\s*oil/g, "indianoil")
    .replace(/hp\s*petrol/g, "hppetrol")
    .replace(/dexgreen\s*india/g, "dexgreen")
    .replace(/sunteck\s*high[-\s]*tech/g, "sunteck")
    .replace(/sahuwala\s*cereals/g, "sahuwala")
    .replace(/mahalaxmi\s*group\b/g, "mahalaxmigroups")
    .replace(/shreyash\s*banquets/g, "shreyash")
    .replace(/lexicon\s*ihm/g, "lexicon")
    .replace(/rainbow\s*child.*center/g, "rainbow")
    .replace(/apollo\s*gauging.*ltd/g, "apollo")
    .replace(/serum\s*institute.*india/g, "serum")
    .replace(/alyss|axiss/g, "axiss");

  return value.replace(/[^a-z0-9]/g, "");
}

function clientPriority(client) {
  const logoUrl = client.logo_url || "";
  if (logoUrl.startsWith("/images/clients/")) return 4;
  if (logoUrl && !logoUrl.includes("/uploads/")) return 3;
  if (logoUrl) return 2;
  return 1;
}

function dedupeClients(rows) {
  const clients = new Map();

  for (const client of rows) {
    const key = normalizeClientKey(client.name, client.logo_url);
    const existing = clients.get(key);

    if (!existing || clientPriority(client) > clientPriority(existing)) {
      clients.set(key, client);
    }
  }

  return Array.from(clients.values()).sort((a, b) => (a.sort_order ?? 0) - (b.sort_order ?? 0) || (a.id ?? 0) - (b.id ?? 0));
}

publicRoutes.get(
  "/services",
  asyncHandler(async (_req, res) => {
    const [rows] = await pool.query("SELECT * FROM services WHERE is_active = 1 ORDER BY sort_order ASC, id DESC");
    const [products] = await pool.query(
      `SELECT products.id, products.service_id, products.name, products.slug, products.item_count, products.short_description, products.main_image_url
       FROM products
       LEFT JOIN services ON services.id = products.service_id
       WHERE products.is_active = 1
       ORDER BY products.sort_order ASC, products.id DESC`,
    );
    const [subproducts] = await pool.query(
      `SELECT product_subproducts.id, product_subproducts.product_id, product_subproducts.name, product_subproducts.slug,
        product_subproducts.item_count, product_subproducts.short_description, product_subproducts.image_url
       FROM product_subproducts
       INNER JOIN products ON products.id = product_subproducts.product_id
       INNER JOIN services ON services.id = products.service_id
       WHERE product_subproducts.is_active = 1
       ORDER BY product_subproducts.sort_order ASC, product_subproducts.id DESC`,
    );
    const productsWithSubproducts = products.map((product) => ({
      ...product,
      sub_products: subproducts.filter((subproduct) => subproduct.product_id === product.id),
    }));

    res.json(
      rows.map((service) => ({
        ...service,
        blurb: service.short_description,
        subs: productsWithSubproducts.filter((product) => product.service_id === service.id).map((product) => product.name),
        products: productsWithSubproducts.filter((product) => product.service_id === service.id),
      })),
    );
  }),
);

publicRoutes.get(
  "/categories",
  asyncHandler(async (_req, res) => {
    const [rows] = await pool.query(
      "SELECT * FROM product_categories WHERE is_active = 1 ORDER BY sort_order ASC, id DESC",
    );
    res.json(rows);
  }),
);

publicRoutes.get(
  "/gallery",
  asyncHandler(async (_req, res) => {
    const [rows] = await pool.query("SELECT * FROM gallery_images WHERE is_active = 1 ORDER BY sort_order ASC, id DESC");
    res.json(rows);
  }),
);

publicRoutes.get(
  "/logo-designs",
  asyncHandler(async (_req, res) => {
    await ensureLogoDesignsTable();
    const [rows] = await pool.query("SELECT * FROM logo_designs WHERE is_active = 1 ORDER BY sort_order ASC, id DESC");
    res.json(rows);
  }),
);

publicRoutes.get(
  "/product-gallery/:serviceSlug/:productSlug",
  asyncHandler(async (req, res) => {
    await ensureLogoDesignsTable();

    const productSlug = req.params.productSlug === "logo" ? "logo-design" : req.params.productSlug;
    const [products] = await pool.execute(
      `SELECT products.id, products.name, products.slug, services.id AS service_id, services.name AS service_name, services.slug AS service_slug
       FROM products
       INNER JOIN services ON services.id = products.service_id
       WHERE services.slug = ? AND (products.slug = ? OR products.slug = ? OR products.name = ?)
       LIMIT 1`,
      [req.params.serviceSlug, productSlug, req.params.productSlug, req.params.productSlug.replace(/-/g, " ")],
    );
    const product = products[0];

    if (product) {
      const [rows] = await pool.execute(
        `SELECT * FROM logo_designs
         WHERE is_active = 1 AND gallery_type = 'product' AND service_id = ? AND product_id = ?
         ORDER BY sort_order ASC, id DESC`,
        [product.service_id, product.id],
      );

      res.json({ product, items: rows });
      return;
    }

    const [subProducts] = await pool.execute(
      `SELECT product_subproducts.id,
        product_subproducts.name,
        product_subproducts.slug,
        products.id AS product_id,
        products.name AS product_name,
        products.slug AS product_slug,
        services.id AS service_id,
        services.name AS service_name,
        services.slug AS service_slug
       FROM product_subproducts
       INNER JOIN products ON products.id = product_subproducts.product_id
       INNER JOIN services ON services.id = products.service_id
       WHERE services.slug = ? AND (product_subproducts.slug = ? OR product_subproducts.name = ?)
       LIMIT 1`,
      [req.params.serviceSlug, req.params.productSlug, req.params.productSlug.replace(/-/g, " ")],
    );
    const subProduct = subProducts[0];

    if (!subProduct) return res.status(404).json({ message: "Product not found" });

    const [rows] = await pool.execute(
      `SELECT * FROM logo_designs
       WHERE is_active = 1 AND gallery_type = 'sub-product' AND service_id = ? AND sub_product_id = ?
       ORDER BY sort_order ASC, id DESC`,
      [subProduct.service_id, subProduct.id],
    );

    res.json({
      product: {
        id: subProduct.id,
        name: subProduct.name,
        slug: subProduct.slug,
        service_id: subProduct.service_id,
        service_name: subProduct.service_name,
        service_slug: subProduct.service_slug,
        parent_product_id: subProduct.product_id,
        parent_product_name: subProduct.product_name,
        parent_product_slug: subProduct.product_slug,
      },
      items: rows,
    });
  }),
);

publicRoutes.get(
  "/industries",
  asyncHandler(async (_req, res) => {
    const [rows] = await pool.query("SELECT * FROM industries WHERE is_active = 1 ORDER BY sort_order ASC, id DESC");
    res.json(rows);
  }),
);

publicRoutes.get(
  "/clients",
  asyncHandler(async (_req, res) => {
    const [rows] = await pool.query("SELECT * FROM clients WHERE is_active = 1 ORDER BY sort_order ASC, id DESC");
    res.json(dedupeClients(rows));
  }),
);

publicRoutes.get(
  "/testimonials",
  asyncHandler(async (_req, res) => {
    const [rows] = await pool.query("SELECT * FROM testimonials WHERE is_active = 1 ORDER BY sort_order ASC, id DESC");
    res.json(rows);
  }),
);

publicRoutes.get(
  "/settings",
  asyncHandler(async (_req, res) => {
    const [rows] = await pool.query("SELECT setting_key, setting_value FROM site_settings");
    res.json(
      rows.reduce((settings, row) => {
        try {
          settings[row.setting_key] = JSON.parse(row.setting_value);
        } catch {
          settings[row.setting_key] = row.setting_value;
        }

        return settings;
      }, {}),
    );
  }),
);

publicRoutes.get(
  "/contact",
  asyncHandler(async (_req, res) => {
    const [rows] = await pool.execute("SELECT setting_value FROM site_settings WHERE setting_key = ?", ["contact"]);
    if (!rows[0]) return res.json({});

    try {
      res.json(JSON.parse(rows[0].setting_value));
    } catch {
      res.json({});
    }
  }),
);

publicRoutes.post(
  "/inquiries",
  asyncHandler(async (req, res) => {
    const { name, mobile, email, business, service, message, source = "website" } = req.body;

    if (!name || !mobile) {
      return res.status(400).json({ message: "Name and mobile number are required" });
    }

    const [result] = await pool.execute(
      `INSERT INTO contact_inquiries (name, mobile, email, business, service, message, source)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [name, mobile, email || null, business || null, service || null, message || null, source],
    );

    res.status(201).json({ id: result.insertId, message: "Inquiry saved" });
  }),
);

publicRoutes.get(
  "/products/:slug",
  asyncHandler(async (req, res) => {
    const [products] = await pool.execute(
      `SELECT products.*, services.name AS serviceName, services.slug AS serviceSlug
       FROM products
       LEFT JOIN services ON services.id = products.service_id
       WHERE products.slug = ? AND products.is_active = 1`,
      [req.params.slug],
    );
    const product = products[0];

    if (!product) return res.status(404).json({ message: "Product not found" });

    const [images] = await pool.execute("SELECT * FROM product_images WHERE product_id = ? ORDER BY sort_order ASC", [
      product.id,
    ]);
    const [variantRows] = await pool.execute(
      "SELECT * FROM product_variants WHERE product_id = ? AND is_active = 1 ORDER BY sort_order ASC, id DESC",
      [product.id],
    );
    const variants = variantRows.length
      ? variantRows
      : [
          {
            id: `product-${product.id}`,
            product_id: product.id,
            label: product.name,
            detail: product.short_description || product.description || "",
            image_url: product.main_image_url || images[0]?.image_url || "",
            colors: "from-white via-[#f7f7f7] to-[#ffe9e9]",
            sort_order: 0,
            is_active: 1,
          },
        ];

    res.json({ ...product, images, variants });
  }),
);

publicRoutes.get(
  "/homepage",
  asyncHandler(async (_req, res) => {
    const [services] = await pool.query("SELECT * FROM services WHERE is_active = 1 ORDER BY sort_order ASC LIMIT 12");
    const [categories] = await pool.query(
      "SELECT * FROM product_categories WHERE is_active = 1 ORDER BY sort_order ASC",
    );
    const [gallery] = await pool.query(
      "SELECT * FROM gallery_images WHERE is_active = 1 ORDER BY sort_order ASC LIMIT 12",
    );
    const [clients] = await pool.query("SELECT * FROM clients WHERE is_active = 1 ORDER BY sort_order ASC, id DESC");
    const [testimonials] = await pool.query(
      "SELECT * FROM testimonials WHERE is_active = 1 ORDER BY sort_order ASC LIMIT 10",
    );
    const [settings] = await pool.query("SELECT setting_key, setting_value FROM site_settings");

    res.json({
      services,
      categories,
      gallery,
      clients: dedupeClients(clients),
      testimonials,
      settings: settings.reduce((siteSettings, row) => {
        try {
          siteSettings[row.setting_key] = JSON.parse(row.setting_value);
        } catch {
          siteSettings[row.setting_key] = row.setting_value;
        }

        return siteSettings;
      }, {}),
    });
  }),
);
