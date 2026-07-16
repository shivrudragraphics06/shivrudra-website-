import { Router } from "express";

import { pool } from "../db.js";
import { asyncHandler } from "../utils/asyncHandler.js";

export const publicRoutes = Router();

publicRoutes.get(
  "/services",
  asyncHandler(async (_req, res) => {
    const [rows] = await pool.query("SELECT * FROM services WHERE is_active = 1 ORDER BY sort_order ASC, id DESC");
    const [products] = await pool.query(
      "SELECT id, service_id, name, slug FROM products WHERE is_active = 1 ORDER BY sort_order ASC, id DESC",
    );

    res.json(
      rows.map((service) => ({
        ...service,
        blurb: service.short_description,
        subs: products.filter((product) => product.service_id === service.id).map((product) => product.name),
        products: products.filter((product) => product.service_id === service.id),
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
    res.json(rows);
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
    const [variants] = await pool.execute(
      "SELECT * FROM product_variants WHERE product_id = ? AND is_active = 1 ORDER BY sort_order ASC, id DESC",
      [product.id],
    );

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
    const [clients] = await pool.query("SELECT * FROM clients WHERE is_active = 1 ORDER BY sort_order ASC");
    const [testimonials] = await pool.query(
      "SELECT * FROM testimonials WHERE is_active = 1 ORDER BY sort_order ASC LIMIT 10",
    );
    const [settings] = await pool.query("SELECT setting_key, setting_value FROM site_settings");

    res.json({
      services,
      categories,
      gallery,
      clients,
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
