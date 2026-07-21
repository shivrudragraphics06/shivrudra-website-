import { pool } from "./db.js";

let tableReady = false;

export async function ensureLogoDesignsTable() {
  if (tableReady) return;

  await pool.query(`
    CREATE TABLE IF NOT EXISTS logo_designs (
      id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
      service_id BIGINT UNSIGNED NULL,
      gallery_type VARCHAR(40) DEFAULT 'product',
      product_id BIGINT UNSIGNED NULL,
      sub_product_id BIGINT UNSIGNED NULL,
      title VARCHAR(180),
      image_url VARCHAR(500) NOT NULL,
      alt_text VARCHAR(255),
      sort_order INT DEFAULT 0,
      is_active BOOLEAN DEFAULT TRUE,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    )
  `);

  try {
    await pool.query("ALTER TABLE logo_designs ADD COLUMN service_id BIGINT UNSIGNED NULL AFTER id");
  } catch (error) {
    if (error.code !== "ER_DUP_FIELDNAME") throw error;
  }

  try {
    await pool.query("ALTER TABLE logo_designs ADD COLUMN product_id BIGINT UNSIGNED NULL AFTER service_id");
  } catch (error) {
    if (error.code !== "ER_DUP_FIELDNAME") throw error;
  }

  try {
    await pool.query("ALTER TABLE logo_designs ADD COLUMN gallery_type VARCHAR(40) DEFAULT 'product' AFTER service_id");
  } catch (error) {
    if (error.code !== "ER_DUP_FIELDNAME") throw error;
  }

  try {
    await pool.query("ALTER TABLE logo_designs ADD COLUMN sub_product_id BIGINT UNSIGNED NULL AFTER product_id");
  } catch (error) {
    if (error.code !== "ER_DUP_FIELDNAME") throw error;
  }

  tableReady = true;
}
