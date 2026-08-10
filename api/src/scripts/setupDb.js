import fs from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";

import dotenv from "dotenv";
import mysql from "mysql2/promise";

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const schemaPath = path.join(__dirname, "../../schema.sql");
const schema = await fs.readFile(schemaPath, "utf8");

const connection = await mysql.createConnection({
  host: process.env.MYSQL_HOST,
  user: process.env.MYSQL_USER,
  password: process.env.MYSQL_PASSWORD,
  multipleStatements: true,
});

await connection.query(schema);

const imageColumnMigrations = [
  ["services", "image_url", "LONGTEXT NULL"],
  ["product_categories", "image_url", "LONGTEXT NULL"],
  ["products", "main_image_url", "LONGTEXT NULL"],
  ["product_images", "image_url", "LONGTEXT NOT NULL"],
  ["product_subproducts", "image_url", "LONGTEXT NULL"],
  ["product_variants", "image_url", "LONGTEXT NULL"],
  ["logo_designs", "image_url", "LONGTEXT NOT NULL"],
  ["gallery_images", "image_url", "LONGTEXT NOT NULL"],
  ["blogs", "featured_image_url", "LONGTEXT NULL"],
  ["industries", "icon_url", "LONGTEXT NULL"],
  ["industries", "image_url", "LONGTEXT NULL"],
  ["clients", "logo_url", "LONGTEXT NULL"],
  ["testimonials", "image_url", "LONGTEXT NULL"],
];

for (const [table, column, definition] of imageColumnMigrations) {
  try {
    await connection.query(`ALTER TABLE ${table} MODIFY COLUMN ${column} ${definition}`);
  } catch (error) {
    if (error.code !== "ER_BAD_FIELD_ERROR") throw error;
  }
}

try {
  await connection.query("ALTER TABLE product_variants ADD COLUMN image_url LONGTEXT AFTER detail");
} catch (error) {
  if (error.code !== "ER_DUP_FIELDNAME") throw error;
}
try {
  await connection.query("ALTER TABLE products ADD COLUMN item_count INT UNSIGNED NULL AFTER main_image_url");
} catch (error) {
  if (error.code !== "ER_DUP_FIELDNAME") throw error;
}
await connection.query(`
  DELETE c1 FROM clients c1
  INNER JOIN clients c2
    ON c1.name = c2.name
    AND c1.id > c2.id
`);
try {
  await connection.query("ALTER TABLE clients ADD UNIQUE KEY uq_clients_name (name)");
} catch (error) {
  if (error.code !== "ER_DUP_KEYNAME") throw error;
}
await connection.end();

console.log(`Database schema applied from ${schemaPath}`);
