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
try {
  await connection.query("ALTER TABLE product_variants ADD COLUMN image_url VARCHAR(500) AFTER detail");
} catch (error) {
  if (error.code !== "ER_DUP_FIELDNAME") throw error;
}
try {
  await connection.query("ALTER TABLE products ADD COLUMN item_count INT UNSIGNED NULL AFTER main_image_url");
} catch (error) {
  if (error.code !== "ER_DUP_FIELDNAME") throw error;
}
await connection.end();

console.log(`Database schema applied from ${schemaPath}`);
