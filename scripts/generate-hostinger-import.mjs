import fs from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootDir = path.resolve(__dirname, "..");

function extractArray(source, name) {
  const marker = source.includes(`export const ${name}`) ? `export const ${name}` : `const ${name}`;
  const start = source.indexOf(marker);
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
      if (escaped) escaped = false;
      else if (char === "\\") escaped = true;
      else if (char === quote) inString = false;
      continue;
    }

    if (char === '"' || char === "'" || char === "`") {
      inString = true;
      quote = char;
      continue;
    }

    if (char === "[") depth += 1;
    if (char === "]") depth -= 1;

    if (depth === 0) return source.slice(source.indexOf("[", equals), index + 1);
  }

  throw new Error(`Could not parse ${name}`);
}

function extractObject(source, name) {
  const start = source.indexOf(`export const ${name}`);
  if (start < 0) throw new Error(`Could not find ${name}`);

  const equals = source.indexOf("=", start);
  let index = source.indexOf("{", equals);
  if (index < 0) throw new Error(`Could not find ${name} object`);

  let depth = 0;
  let inString = false;
  let quote = "";
  let escaped = false;

  for (; index < source.length; index += 1) {
    const char = source[index];

    if (inString) {
      if (escaped) escaped = false;
      else if (char === "\\") escaped = true;
      else if (char === quote) inString = false;
      continue;
    }

    if (char === '"' || char === "'" || char === "`") {
      inString = true;
      quote = char;
      continue;
    }

    if (char === "{") depth += 1;
    if (char === "}") depth -= 1;

    if (depth === 0) return source.slice(source.indexOf("{", equals), index + 1);
  }

  throw new Error(`Could not parse ${name}`);
}

function evaluateArray(source, name) {
  return Function(`"use strict"; return (${extractArray(source, name)});`)();
}

function evaluateObject(source, name) {
  return Function(`"use strict"; return (${extractObject(source, name)});`)();
}

function sql(value) {
  if (value === null || value === undefined) return "NULL";
  if (typeof value === "number") return String(value);
  if (typeof value === "boolean") return value ? "1" : "0";
  return `'${String(value).replace(/\\/g, "\\\\").replace(/'/g, "''")}'`;
}

function jsonSql(value) {
  return sql(JSON.stringify(value));
}

function slugify(value) {
  return value
    .replace(/&/g, "and")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

function safeFileName(value) {
  return value
    .trim()
    .toLowerCase()
    .replace(/&/g, "and")
    .replace(/[^a-z0-9.]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

function titleFromFile(value) {
  return value
    .replace(/\.[^.]+$/, "")
    .replace(/[-_]+/g, " ")
    .replace(/\s+/g, " ")
    .trim()
    .replace(/\b\w/g, (letter) => letter.toUpperCase());
}

function destinationServiceImage(fileName) {
  return fileName
    .toLowerCase()
    .replace(/&/g, "and")
    .replace(/[^a-z0-9.]+/g, "-")
    .replace(/^-+|-+(?=\.)/g, "");
}

function normalizeTitle(value) {
  return value
    .replace(/\s+\(\d+\)$/g, "")
    .replace(/\s+/g, " ")
    .trim();
}

function parseClients(source, assetFiles) {
  const imports = new Map();
  const importPattern = /import\s+(\w+)\s+from\s+"@\/assets\/client logos\/([^"]+)";/g;
  let importMatch;

  while ((importMatch = importPattern.exec(source))) {
    imports.set(importMatch[1], importMatch[2]);
  }

  const clients = [];
  const clientPattern = /name:\s*"([^"]+)"\s*,\s*logo:\s*(\w+)/g;
  let clientMatch;

  while ((clientMatch = clientPattern.exec(source))) {
    const [, name, logoVariable] = clientMatch;
    const fileName = imports.get(logoVariable);
    if (fileName) clients.push({ name, fileName });
  }

  const usedFiles = new Set(clients.map((client) => client.fileName.toLowerCase()));
  for (const fileName of assetFiles) {
    if (!usedFiles.has(fileName.toLowerCase())) clients.push({ name: titleFromFile(fileName), fileName });
  }

  return clients;
}

function insertIfMissing(table, columns, values, whereColumn, whereValue) {
  return `INSERT INTO ${table} (${columns.join(", ")})
SELECT ${values.join(", ")}
WHERE NOT EXISTS (SELECT 1 FROM ${table} WHERE ${whereColumn} = ${whereValue} LIMIT 1);`;
}

async function main() {
  const siteSource = await fs.readFile(path.join(rootDir, "src/data/site.ts"), "utf8");
  const homeSource = await fs.readFile(path.join(rootDir, "src/routes/index.tsx"), "utf8");
  const gallerySource = await fs.readFile(path.join(rootDir, "src/components/ProductGallerySection.tsx"), "utf8");
  const logoSource = await fs.readFile(path.join(rootDir, "src/routes/logo-design.tsx"), "utf8");
  const clientsSource = await fs.readFile(path.join(rootDir, "src/routes/clients.tsx"), "utf8");
  const clientAssetFiles = await fs.readdir(path.join(rootDir, "src/assets/client logos"));
  const industryAssetFiles = await fs.readdir(path.join(rootDir, "src/assets/industries we serve"));

  const services = evaluateArray(siteSource, "SERVICES");
  const categories = evaluateArray(siteSource, "CATEGORIES");
  const industries = evaluateArray(siteSource, "INDUSTRIES");
  const clients = parseClients(clientsSource, clientAssetFiles);
  const contact = evaluateObject(siteSource, "CONTACT");
  const processSteps = evaluateArray(siteSource, "PROCESS_STEPS");
  const whyChoose = evaluateArray(siteSource, "WHY_CHOOSE");
  const timeline = evaluateArray(siteSource, "TIMELINE");
  const galleryCategories = evaluateArray(siteSource, "GALLERY_CATEGORIES");
  const galleryItems = evaluateArray(gallerySource, "PRODUCT_GALLERY_ITEMS");
  const testimonials = evaluateArray(homeSource, "TESTIMONIALS");
  const logoTypes = evaluateArray(logoSource, "LOGO_TYPES");

  const serviceImages = new Map([
    ["badge-dome-printing", "Badge & Dome Printing.png"],
    ["bag-printing", "Bag Printing.png"],
    ["corporate-gift", "corporate gift.jpg"],
    ["designing", "designing.jpg"],
    ["digital-printing", "Digital Printing.png"],
    ["engraving-marking", "Engraving & Marking.png"],
    ["flex-printing", "Flex Printing.png"],
    ["industrial-name-plates", "Industrial Name Plates.png"],
    ["keychain", "Keychains.png"],
    ["laser-cnc-cutting", "Laser & CNC Cutting.png"],
    ["offset-printing", "Offset Printing.png"],
    ["photo-frame", "Photo frame.jpg"],
    ["premium-signages", "Premium Signages.png"],
    ["stamp", "Rubber Stamps.png"],
    ["safety-signages", "Safety Signages.png"],
    ["screen-printing", "Screen Printing.png"],
    ["signage", "Signage.png"],
    ["trophies-medals", "Trophies & Medals.png"],
    ["uv-printing", "UV Printing.png"],
    ["vinyl-printing", "Vinyl Printing.png"],
  ]);
  const industryImages = new Map(
    industryAssetFiles.map((fileName) => {
      const name = normalizeTitle(titleFromFile(fileName));
      return [name, `/images/industries/${safeFileName(name)}${path.extname(fileName)}`];
    }),
  );

  const schemaPath = path.join(rootDir, "hostinger-import.sql");
  const currentImport = await fs.readFile(schemaPath, "utf8");
  const schema = currentImport.split("-- Seed frontend content into admin-managed tables.")[0].replace(/SET foreign_key_checks = 1;\s*$/i, "");
  const lines = [
    schema.trimEnd(),
    "",
    "-- Seed frontend content into admin-managed tables.",
    "-- Re-importing this file keeps existing edited records and fills missing defaults.",
  ];

  for (const [index, service] of services.entries()) {
    const serviceImage = serviceImages.get(service.slug);
    const imageUrl = serviceImage ? `/images/services/${destinationServiceImage(serviceImage)}` : null;
    lines.push(
      `INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES (${sql(service.name)}, ${sql(service.slug)}, ${sql(service.blurb)}, ${sql(service.blurb)}, ${sql(imageUrl)}, ${index}, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;`,
    );

    for (const [productIndex, productName] of service.subs.entries()) {
      const productSlug = slugify(productName);
      lines.push(
        `INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, ${sql(productName)}, ${sql(productSlug)}, ${sql(`${productName} by Shivrudra Graphics`)}, ${sql(`${productName} service by Shivrudra Graphics.`)}, ${productIndex}, 1
FROM services WHERE slug = ${sql(service.slug)}
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;`,
      );
    }
  }

  for (const [index, category] of categories.entries()) {
    lines.push(
      `INSERT INTO product_categories (name, slug, icon, sort_order, is_active)
VALUES (${sql(category.name)}, ${sql(category.slug)}, ${sql(category.icon)}, ${index}, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon = VALUES(icon), sort_order = VALUES(sort_order), is_active = 1;`,
    );
  }

  for (const [index, industry] of Array.from(new Set(industries)).entries()) {
    const imageUrl = industryImages.get(industry) || null;
    lines.push(
      `INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES (${sql(industry)}, ${sql(slugify(industry))}, ${sql(imageUrl)}, ${sql(imageUrl)}, ${index}, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;`,
    );
  }

  lines.push("UPDATE clients SET is_active = 0;");

  for (const [index, client] of clients.entries()) {
    const extension = path.extname(client.fileName);
    const logoUrl = `/images/clients/${String(index + 1).padStart(2, "0")}-${safeFileName(client.name)}${extension}`;
    lines.push(
      `INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES (${sql(client.name)}, ${sql(logoUrl)}, ${index}, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;`,
    );
  }

  for (const [index, item] of galleryItems.entries()) {
    lines.push(
      insertIfMissing(
        "gallery_images",
        ["title", "category", "image_url", "alt_text", "sort_order", "is_active"],
        [sql(item.title), sql(item.cat), sql(item.img), sql(item.title), String(index), "1"],
        "title",
        sql(item.title),
      ),
    );
  }

  for (const [index, item] of testimonials.entries()) {
    lines.push(
      insertIfMissing(
        "testimonials",
        ["client_name", "client_role", "message", "rating", "sort_order", "is_active"],
        [sql(item.name), sql(item.role), sql(item.text), "5", String(index), "1"],
        "client_name",
        sql(item.name),
      ),
    );
  }

  const settings = {
    contact,
    site_tagline: "Commercial, Industrial, Corporate Printing and LED Sign Board Manufacturers",
    process_steps: processSteps,
    why_choose: whyChoose,
    timeline,
    gallery_categories: galleryCategories,
    logo_types: logoTypes,
    directors: [
      { name: "Aadesh C. Nimbalkar", role: "Director" },
      { name: "Akshay N. Kalbhor", role: "Director" },
    ],
    about_principles: [
      {
        title: "Vision",
        description:
          "To provide all types of graphics solutions to increase the growth of clients and build inclusive partnerships based on trust and mutual respect.",
      },
      {
        title: "Mission",
        description: "To become the most valued business partner for clients and help them grow their business.",
      },
      {
        title: "Values",
        description: "Integrity, Innovation, Teamwork, Environment-Friendly Approach, Respect for People.",
      },
    ],
  };

  for (const [key, value] of Object.entries(settings)) {
    lines.push(
      `INSERT INTO site_settings (setting_key, setting_value)
VALUES (${sql(key)}, ${typeof value === "string" ? sql(value) : jsonSql(value)})
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);`,
    );
  }

  lines.push("", "SET foreign_key_checks = 1;", "");
  await fs.writeFile(schemaPath, `${lines.join("\n\n")}`);
  console.log(`Wrote schema and frontend seed data to ${schemaPath}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
