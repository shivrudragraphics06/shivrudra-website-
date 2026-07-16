import { Router } from "express";
import slugify from "slugify";

import { pool } from "../db.js";
import { requireAdmin } from "../middleware/auth.js";
import { upload } from "../middleware/upload.js";
import { asyncHandler } from "../utils/asyncHandler.js";

export const crudRoutes = Router();

const resources = {
  services: {
    table: "services",
    orderBy: "sort_order ASC, id DESC",
    fields: ["name", "slug", "short_description", "description", "image_url", "sort_order", "is_active"],
  },
  categories: {
    table: "product_categories",
    orderBy: "sort_order ASC, id DESC",
    fields: ["name", "slug", "description", "image_url", "icon", "sort_order", "is_active"],
  },
  products: {
    table: "products",
    orderBy: "sort_order ASC, id DESC",
    fields: [
      "category_id",
      "service_id",
      "name",
      "slug",
      "short_description",
      "description",
      "main_image_url",
      "meta_title",
      "meta_description",
      "sort_order",
      "is_featured",
      "is_active",
    ],
  },
  variants: {
    table: "product_variants",
    orderBy: "sort_order ASC, id DESC",
    fields: ["product_id", "label", "detail", "image_url", "colors", "sort_order", "is_active"],
  },
  "product-images": {
    table: "product_images",
    orderBy: "sort_order ASC, id DESC",
    fields: ["product_id", "image_url", "alt_text", "sort_order"],
  },
  gallery: {
    table: "gallery_images",
    orderBy: "sort_order ASC, id DESC",
    fields: ["title", "category", "image_url", "alt_text", "sort_order", "is_active"],
  },
  blogs: {
    table: "blogs",
    orderBy: "published_at DESC, id DESC",
    fields: [
      "title",
      "slug",
      "excerpt",
      "content",
      "featured_image_url",
      "author",
      "meta_title",
      "meta_description",
      "is_published",
      "published_at",
    ],
  },
  industries: {
    table: "industries",
    orderBy: "sort_order ASC, id DESC",
    fields: ["name", "slug", "description", "icon_url", "image_url", "sort_order", "is_active"],
  },
  clients: {
    table: "clients",
    orderBy: "sort_order ASC, id DESC",
    fields: ["name", "logo_url", "website_url", "sort_order", "is_active"],
  },
  testimonials: {
    table: "testimonials",
    orderBy: "sort_order ASC, id DESC",
    fields: ["client_name", "client_role", "company", "message", "rating", "image_url", "sort_order", "is_active"],
  },
  inquiries: {
    table: "contact_inquiries",
    orderBy: "created_at DESC, id DESC",
    fields: ["name", "mobile", "email", "business", "service", "message", "source", "status"],
  },
  settings: {
    table: "site_settings",
    orderBy: "setting_key ASC",
    fields: ["setting_key", "setting_value"],
  },
};

function getResource(req, res) {
  const config = resources[req.params.resource];
  if (!config) {
    res.status(404).json({ message: "Unknown resource" });
    return null;
  }

  return config;
}

crudRoutes.use(requireAdmin);

crudRoutes.post("/upload", upload.single("image"), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ message: "Image is required" });
  }

  res.json({ url: `/uploads/${req.file.filename}` });
});

crudRoutes.get(
  "/:resource",
  asyncHandler(async (req, res) => {
    const config = getResource(req, res);
    if (!config) return;

    const [rows] = await pool.query(`SELECT * FROM ${config.table} ORDER BY ${config.orderBy}`);
    res.json(rows);
  }),
);

crudRoutes.get(
  "/:resource/:id",
  asyncHandler(async (req, res) => {
    const config = getResource(req, res);
    if (!config) return;

    const [rows] = await pool.execute(`SELECT * FROM ${config.table} WHERE id = ?`, [req.params.id]);
    if (!rows[0]) return res.status(404).json({ message: "Record not found" });

    res.json(rows[0]);
  }),
);

crudRoutes.post(
  "/:resource",
  asyncHandler(async (req, res) => {
    const config = getResource(req, res);
    if (!config) return;

    if (!req.body.slug && (req.body.name || req.body.title)) {
      req.body.slug = slugify(req.body.name || req.body.title, { lower: true, strict: true });
    }

    const fields = config.fields.filter((field) => req.body[field] !== undefined);
    if (!fields.length) {
      return res.status(400).json({ message: "No valid fields provided" });
    }

    const values = fields.map((field) => req.body[field]);
    const placeholders = fields.map(() => "?").join(", ");

    const [result] = await pool.execute(
      `INSERT INTO ${config.table} (${fields.join(", ")}) VALUES (${placeholders})`,
      values,
    );

    res.status(201).json({ id: result.insertId });
  }),
);

crudRoutes.put(
  "/:resource/:id",
  asyncHandler(async (req, res) => {
    const config = getResource(req, res);
    if (!config) return;

    const fields = config.fields.filter((field) => req.body[field] !== undefined);
    if (!fields.length) {
      return res.status(400).json({ message: "No valid fields provided" });
    }

    const assignments = fields.map((field) => `${field} = ?`).join(", ");
    const values = fields.map((field) => req.body[field]);

    await pool.execute(`UPDATE ${config.table} SET ${assignments} WHERE id = ?`, [...values, req.params.id]);
    res.json({ message: "Updated" });
  }),
);

crudRoutes.delete(
  "/:resource/:id",
  asyncHandler(async (req, res) => {
    const config = getResource(req, res);
    if (!config) return;

    await pool.execute(`DELETE FROM ${config.table} WHERE id = ?`, [req.params.id]);
    res.json({ message: "Deleted" });
  }),
);
