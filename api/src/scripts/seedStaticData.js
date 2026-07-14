import fs from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";
import slugify from "slugify";

import { pool } from "../db.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootDir = path.resolve(__dirname, "../../..");

function extractConst(source, name) {
  const marker = `const ${name}`;
  const exportMarker = `export const ${name}`;
  const start = source.indexOf(exportMarker) >= 0 ? source.indexOf(exportMarker) : source.indexOf(marker);
  if (start < 0) throw new Error(`Could not find ${name}`);

  const equals = source.indexOf("=", start);
  let index = source.indexOf("[", equals);
  if (index < 0) throw new Error(`Could not find ${name} array`);

  let depth = 0;
  let inString = false;
  let quote = "";
  let escaped = false;

  for (; index < source.length; index += 1) {
    const char = source[index];

    if (inString) {
      if (escaped) {
        escaped = false;
      } else if (char === "\\") {
        escaped = true;
      } else if (char === quote) {
        inString = false;
      }
      continue;
    }

    if (char === '"' || char === "'" || char === "`") {
      inString = true;
      quote = char;
      continue;
    }

    if (char === "[") depth += 1;
    if (char === "]") depth -= 1;

    if (depth === 0) {
      return source.slice(source.indexOf("[", equals), index + 1);
    }
  }

  throw new Error(`Could not parse ${name}`);
}

function evaluateArray(source, name) {
  return Function(`"use strict"; return (${extractConst(source, name)});`)();
}

function evaluateOptionalArray(source, name) {
  try {
    return evaluateArray(source, name);
  } catch (error) {
    if (String(error.message || "").includes(`Could not find ${name}`)) return [];
    throw error;
  }
}

function toSlug(value) {
  return slugify(value, { lower: true, strict: true });
}

async function upsertService(service, index) {
  await pool.execute(
    `INSERT INTO services (name, slug, short_description, description, sort_order, is_active)
     VALUES (?, ?, ?, ?, ?, 1)
     ON DUPLICATE KEY UPDATE
       name = VALUES(name),
       short_description = VALUES(short_description),
       description = VALUES(description),
       sort_order = VALUES(sort_order),
       is_active = 1`,
    [service.name, service.slug, service.blurb, service.blurb, index],
  );

  const [rows] = await pool.execute("SELECT id FROM services WHERE slug = ?", [service.slug]);
  const serviceId = rows[0].id;

  for (const [productIndex, productName] of service.subs.entries()) {
    await pool.execute(
      `INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
       VALUES (?, ?, ?, ?, ?, ?, 1)
       ON DUPLICATE KEY UPDATE
         service_id = VALUES(service_id),
         name = VALUES(name),
         short_description = VALUES(short_description),
         description = VALUES(description),
         sort_order = VALUES(sort_order),
         is_active = 1`,
      [
        serviceId,
        productName,
        toSlug(productName.replace(/&/g, "and")),
        `${productName} by Shivrudra Graphics`,
        `${productName} service by Shivrudra Graphics.`,
        productIndex,
      ],
    );
  }
}

async function main() {
  const siteSource = await fs.readFile(path.join(rootDir, "src/data/site.ts"), "utf8");
  const homeSource = await fs.readFile(path.join(rootDir, "src/routes/index.tsx"), "utf8");
  const gallerySource = await fs.readFile(path.join(rootDir, "src/components/ProductGallerySection.tsx"), "utf8");

  const services = evaluateArray(siteSource, "SERVICES");
  const categories = evaluateArray(siteSource, "CATEGORIES");
  const industries = evaluateArray(siteSource, "INDUSTRIES");
  const clients = evaluateArray(siteSource, "CLIENTS");
  const gallery = evaluateArray(gallerySource, "PRODUCT_GALLERY_ITEMS");
  const testimonials = evaluateArray(homeSource, "TESTIMONIALS");
  const variants = evaluateOptionalArray(
    await fs.readFile(path.join(rootDir, "src/routes/products.$productSlug.tsx"), "utf8"),
    "VARIANTS",
  );

  for (const [index, service] of services.entries()) await upsertService(service, index);

  for (const [index, category] of categories.entries()) {
    await pool.execute(
      `INSERT INTO product_categories (name, slug, icon, sort_order, is_active)
       VALUES (?, ?, ?, ?, 1)
       ON DUPLICATE KEY UPDATE name = VALUES(name), icon = VALUES(icon), sort_order = VALUES(sort_order), is_active = 1`,
      [category.name, category.slug, category.icon, index],
    );
  }

  for (const [index, industry] of industries.entries()) {
    await pool.execute(
      `INSERT INTO industries (name, slug, sort_order, is_active)
       VALUES (?, ?, ?, 1)
       ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1`,
      [industry, toSlug(industry), index],
    );
  }

  for (const [index, client] of clients.entries()) {
    const [existing] = await pool.execute("SELECT id FROM clients WHERE name = ? LIMIT 1", [client]);
    if (existing[0]) {
      await pool.execute("UPDATE clients SET sort_order = ?, is_active = 1 WHERE id = ?", [index, existing[0].id]);
    } else {
      await pool.execute("INSERT INTO clients (name, sort_order, is_active) VALUES (?, ?, 1)", [client, index]);
    }
  }

  for (const [index, item] of gallery.entries()) {
    const [existing] = await pool.execute("SELECT id FROM gallery_images WHERE title = ? AND category = ? LIMIT 1", [
      item.title,
      item.cat,
    ]);
    if (existing[0]) {
      await pool.execute(
        "UPDATE gallery_images SET image_url = ?, alt_text = ?, sort_order = ?, is_active = 1 WHERE id = ?",
        [item.img, item.title, index, existing[0].id],
      );
    } else {
      await pool.execute(
        "INSERT INTO gallery_images (title, category, image_url, alt_text, sort_order, is_active) VALUES (?, ?, ?, ?, ?, 1)",
        [item.title, item.cat, item.img, item.title, index],
      );
    }
  }

  for (const [index, item] of testimonials.entries()) {
    const [existing] = await pool.execute("SELECT id FROM testimonials WHERE client_name = ? AND message = ? LIMIT 1", [
      item.name,
      item.text,
    ]);
    if (existing[0]) {
      await pool.execute("UPDATE testimonials SET client_role = ?, rating = 5, sort_order = ?, is_active = 1 WHERE id = ?", [
        item.role,
        index,
        existing[0].id,
      ]);
    } else {
      await pool.execute(
        "INSERT INTO testimonials (client_name, client_role, message, rating, sort_order, is_active) VALUES (?, ?, ?, 5, ?, 1)",
        [item.name, item.role, item.text, index],
      );
    }
  }

  for (const [index, variant] of variants.entries()) {
    const [existing] = await pool.execute(
      "SELECT id FROM product_variants WHERE product_id IS NULL AND label = ? LIMIT 1",
      [variant.label],
    );

    if (existing[0]) {
      await pool.execute(
        "UPDATE product_variants SET detail = ?, colors = ?, sort_order = ?, is_active = 1 WHERE id = ?",
        [variant.detail, variant.colors, index, existing[0].id],
      );
    } else {
      await pool.execute(
        "INSERT INTO product_variants (product_id, label, detail, colors, sort_order, is_active) VALUES (NULL, ?, ?, ?, ?, 1)",
        [variant.label, variant.detail, variant.colors, index],
      );
    }
  }

  console.log("Static website data seeded into MySQL.");
  process.exit(0);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
