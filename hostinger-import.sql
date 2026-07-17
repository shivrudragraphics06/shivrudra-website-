-- Shivrudra Graphics MySQL schema for Hostinger/phpMyAdmin import.
-- Import this file inside the database:
--   u450446868_shivrudra_db
--
-- This file intentionally does not run CREATE DATABASE or USE because
-- Hostinger usually restricts those commands in phpMyAdmin imports.

SET NAMES utf8mb4;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;

CREATE TABLE IF NOT EXISTS admins (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS services (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(160) NOT NULL,
  slug VARCHAR(180) NOT NULL UNIQUE,
  short_description VARCHAR(255),
  description TEXT,
  image_url VARCHAR(500),
  sort_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS product_categories (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(160) NOT NULL,
  slug VARCHAR(180) NOT NULL UNIQUE,
  description TEXT,
  image_url VARCHAR(500),
  icon VARCHAR(80),
  sort_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS products (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  category_id BIGINT UNSIGNED NULL,
  service_id BIGINT UNSIGNED NULL,
  name VARCHAR(180) NOT NULL,
  slug VARCHAR(200) NOT NULL UNIQUE,
  short_description VARCHAR(255),
  description LONGTEXT,
  main_image_url VARCHAR(500),
  item_count INT UNSIGNED NULL,
  meta_title VARCHAR(255),
  meta_description VARCHAR(500),
  sort_order INT DEFAULT 0,
  is_featured BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES product_categories(id) ON DELETE SET NULL,
  CONSTRAINT fk_products_service FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE products ADD COLUMN IF NOT EXISTS item_count INT UNSIGNED NULL AFTER main_image_url;

CREATE TABLE IF NOT EXISTS product_images (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  product_id BIGINT UNSIGNED NOT NULL,
  image_url VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255),
  sort_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_product_images_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS product_subproducts (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  product_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(180) NOT NULL,
  slug VARCHAR(220) NOT NULL UNIQUE,
  short_description VARCHAR(255),
  description LONGTEXT,
  image_url VARCHAR(500),
  item_count INT UNSIGNED NULL,
  sort_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_product_subproducts_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS product_variants (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  product_id BIGINT UNSIGNED NULL,
  label VARCHAR(160) NOT NULL,
  detail VARCHAR(500),
  image_url VARCHAR(500),
  colors VARCHAR(255),
  sort_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_product_variants_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS gallery_images (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(180),
  category VARCHAR(120),
  image_url VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255),
  sort_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS blogs (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(220) NOT NULL,
  slug VARCHAR(240) NOT NULL UNIQUE,
  excerpt VARCHAR(500),
  content LONGTEXT NOT NULL,
  featured_image_url VARCHAR(500),
  author VARCHAR(120),
  meta_title VARCHAR(255),
  meta_description VARCHAR(500),
  is_published BOOLEAN DEFAULT FALSE,
  published_at DATETIME NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS industries (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(160) NOT NULL,
  slug VARCHAR(180) NOT NULL UNIQUE,
  description TEXT,
  icon_url VARCHAR(500),
  image_url VARCHAR(500),
  sort_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS clients (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(180) NOT NULL,
  logo_url VARCHAR(500),
  website_url VARCHAR(500),
  sort_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS testimonials (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  client_name VARCHAR(160) NOT NULL,
  client_role VARCHAR(160),
  company VARCHAR(180),
  message TEXT NOT NULL,
  rating TINYINT UNSIGNED DEFAULT 5,
  image_url VARCHAR(500),
  sort_order INT DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS site_settings (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  setting_key VARCHAR(120) NOT NULL UNIQUE,
  setting_value TEXT,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS contact_inquiries (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(160) NOT NULL,
  mobile VARCHAR(40) NOT NULL,
  email VARCHAR(190),
  business VARCHAR(190),
  service VARCHAR(180),
  message TEXT,
  source VARCHAR(80) DEFAULT 'website',
  status VARCHAR(40) DEFAULT 'new',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Seed frontend content into admin-managed tables.

-- Re-importing this file keeps existing edited records and fills missing defaults.

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Designing', 'designing', 'Creative design solutions from logos to packaging artwork.', 'Creative design solutions from logos to packaging artwork.', '/images/services/designing.jpg', 0, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'designing'
  AND products.slug IN ('logo-design', 'social-media-creatives', 'brochure-design', 'certificate-design', 'calligraphy-and-vector-art', 'flyer-design', 'invitation-card-design', 'car-wrap-design', 'letterhead-design', 'banner-design', 'business-card-design', 'poster-design', 'led-signage-design', 'product-packaging-labels-and-stickers-design');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Designing', 'designing-products', 'Designing products', 'Creative design solutions from logos to packaging artwork.', 0, 1
FROM services WHERE slug = 'designing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Logo Design', 'designing-logo-design', NULL, 'Logo Design by Shivrudra Graphics', 'Logo Design service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'designing' AND products.slug = 'designing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Social Media Creatives', 'designing-social-media-creatives', NULL, 'Social Media Creatives by Shivrudra Graphics', 'Social Media Creatives service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'designing' AND products.slug = 'designing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Brochure Design', 'designing-brochure-design', NULL, 'Brochure Design by Shivrudra Graphics', 'Brochure Design service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'designing' AND products.slug = 'designing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Certificate Design', 'designing-certificate-design', NULL, 'Certificate Design by Shivrudra Graphics', 'Certificate Design service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'designing' AND products.slug = 'designing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Calligraphy & Vector Art', 'designing-calligraphy-and-vector-art', NULL, 'Calligraphy & Vector Art by Shivrudra Graphics', 'Calligraphy & Vector Art service by Shivrudra Graphics.', 4, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'designing' AND products.slug = 'designing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Flyer Design', 'designing-flyer-design', NULL, 'Flyer Design by Shivrudra Graphics', 'Flyer Design service by Shivrudra Graphics.', 5, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'designing' AND products.slug = 'designing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Invitation Card Design', 'designing-invitation-card-design', NULL, 'Invitation Card Design by Shivrudra Graphics', 'Invitation Card Design service by Shivrudra Graphics.', 6, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'designing' AND products.slug = 'designing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Car Wrap Design', 'designing-car-wrap-design', NULL, 'Car Wrap Design by Shivrudra Graphics', 'Car Wrap Design service by Shivrudra Graphics.', 7, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'designing' AND products.slug = 'designing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Letterhead Design', 'designing-letterhead-design', NULL, 'Letterhead Design by Shivrudra Graphics', 'Letterhead Design service by Shivrudra Graphics.', 8, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'designing' AND products.slug = 'designing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Banner Design', 'designing-banner-design', NULL, 'Banner Design by Shivrudra Graphics', 'Banner Design service by Shivrudra Graphics.', 9, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'designing' AND products.slug = 'designing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Business Card Design', 'designing-business-card-design', NULL, 'Business Card Design by Shivrudra Graphics', 'Business Card Design service by Shivrudra Graphics.', 10, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'designing' AND products.slug = 'designing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Poster Design', 'designing-poster-design', NULL, 'Poster Design by Shivrudra Graphics', 'Poster Design service by Shivrudra Graphics.', 11, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'designing' AND products.slug = 'designing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'LED Signage Design', 'designing-led-signage-design', NULL, 'LED Signage Design by Shivrudra Graphics', 'LED Signage Design service by Shivrudra Graphics.', 12, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'designing' AND products.slug = 'designing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Product Packaging Labels & Stickers Design', 'designing-product-packaging-labels-and-stickers-design', NULL, 'Product Packaging Labels & Stickers Design by Shivrudra Graphics', 'Product Packaging Labels & Stickers Design service by Shivrudra Graphics.', 13, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'designing' AND products.slug = 'designing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Flex Printing', 'flex-printing', 'Vibrant large-format flex prints for outdoor & indoor branding.', 'Vibrant large-format flex prints for outdoor & indoor branding.', '/images/services/flex-printing.png', 1, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'flex-printing'
  AND products.slug IN ('normal-flex-printing', 'black-back-flex-printing', 'star-flex-printing', 'backlit-flex-printing', 'one-way-vision-printing', 'roll-up-standee', 'canopy-standee', 'graffiti-wall-printing');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Flex Printing', 'flex-printing-products', 'Flex Printing products', 'Vibrant large-format flex prints for outdoor & indoor branding.', 0, 1
FROM services WHERE slug = 'flex-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Normal Flex Printing', 'flex-printing-normal-flex-printing', NULL, 'Normal Flex Printing by Shivrudra Graphics', 'Normal Flex Printing service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'flex-printing' AND products.slug = 'flex-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Black Back Flex Printing', 'flex-printing-black-back-flex-printing', NULL, 'Black Back Flex Printing by Shivrudra Graphics', 'Black Back Flex Printing service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'flex-printing' AND products.slug = 'flex-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Star Flex Printing', 'flex-printing-star-flex-printing', NULL, 'Star Flex Printing by Shivrudra Graphics', 'Star Flex Printing service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'flex-printing' AND products.slug = 'flex-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Backlit Flex Printing', 'flex-printing-backlit-flex-printing', NULL, 'Backlit Flex Printing by Shivrudra Graphics', 'Backlit Flex Printing service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'flex-printing' AND products.slug = 'flex-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'One Way Vision Printing', 'flex-printing-one-way-vision-printing', NULL, 'One Way Vision Printing by Shivrudra Graphics', 'One Way Vision Printing service by Shivrudra Graphics.', 4, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'flex-printing' AND products.slug = 'flex-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Roll Up Standee', 'flex-printing-roll-up-standee', NULL, 'Roll Up Standee by Shivrudra Graphics', 'Roll Up Standee service by Shivrudra Graphics.', 5, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'flex-printing' AND products.slug = 'flex-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Canopy Standee', 'flex-printing-canopy-standee', NULL, 'Canopy Standee by Shivrudra Graphics', 'Canopy Standee service by Shivrudra Graphics.', 6, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'flex-printing' AND products.slug = 'flex-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Graffiti Wall Printing', 'flex-printing-graffiti-wall-printing', NULL, 'Graffiti Wall Printing by Shivrudra Graphics', 'Graffiti Wall Printing service by Shivrudra Graphics.', 7, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'flex-printing' AND products.slug = 'flex-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Vinyl Printing', 'vinyl-printing', 'Premium vinyl prints for vehicles, walls, floors and more.', 'Premium vinyl prints for vehicles, walls, floors and more.', '/images/services/vinyl-printing.png', 2, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'vinyl-printing'
  AND products.slug IN ('vinyl-printing', 'frosted-filming', 'retro-vinyl-printing', '3m-vinyl-printing', 'transparent-vinyl-printing', 'night-glow-vinyl', 'vinyl-foam-board', 'floor-graphics-printing', 'table-top-printing', 'cutout-standees', 'sun-board-standee', 'car-branding', 'wallpaper-printing', 'bus-branding');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Vinyl Printing', 'vinyl-printing-products', 'Vinyl Printing products', 'Premium vinyl prints for vehicles, walls, floors and more.', 0, 1
FROM services WHERE slug = 'vinyl-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Vinyl Printing', 'vinyl-printing-vinyl-printing', NULL, 'Vinyl Printing by Shivrudra Graphics', 'Vinyl Printing service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'vinyl-printing' AND products.slug = 'vinyl-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Frosted Filming', 'vinyl-printing-frosted-filming', NULL, 'Frosted Filming by Shivrudra Graphics', 'Frosted Filming service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'vinyl-printing' AND products.slug = 'vinyl-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Retro Vinyl Printing', 'vinyl-printing-retro-vinyl-printing', NULL, 'Retro Vinyl Printing by Shivrudra Graphics', 'Retro Vinyl Printing service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'vinyl-printing' AND products.slug = 'vinyl-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, '3M Vinyl Printing', 'vinyl-printing-3m-vinyl-printing', NULL, '3M Vinyl Printing by Shivrudra Graphics', '3M Vinyl Printing service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'vinyl-printing' AND products.slug = 'vinyl-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Transparent Vinyl Printing', 'vinyl-printing-transparent-vinyl-printing', NULL, 'Transparent Vinyl Printing by Shivrudra Graphics', 'Transparent Vinyl Printing service by Shivrudra Graphics.', 4, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'vinyl-printing' AND products.slug = 'vinyl-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Night Glow Vinyl', 'vinyl-printing-night-glow-vinyl', NULL, 'Night Glow Vinyl by Shivrudra Graphics', 'Night Glow Vinyl service by Shivrudra Graphics.', 5, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'vinyl-printing' AND products.slug = 'vinyl-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Vinyl Foam Board', 'vinyl-printing-vinyl-foam-board', NULL, 'Vinyl Foam Board by Shivrudra Graphics', 'Vinyl Foam Board service by Shivrudra Graphics.', 6, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'vinyl-printing' AND products.slug = 'vinyl-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Floor Graphics Printing', 'vinyl-printing-floor-graphics-printing', NULL, 'Floor Graphics Printing by Shivrudra Graphics', 'Floor Graphics Printing service by Shivrudra Graphics.', 7, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'vinyl-printing' AND products.slug = 'vinyl-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Table Top Printing', 'vinyl-printing-table-top-printing', NULL, 'Table Top Printing by Shivrudra Graphics', 'Table Top Printing service by Shivrudra Graphics.', 8, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'vinyl-printing' AND products.slug = 'vinyl-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Cutout Standees', 'vinyl-printing-cutout-standees', NULL, 'Cutout Standees by Shivrudra Graphics', 'Cutout Standees service by Shivrudra Graphics.', 9, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'vinyl-printing' AND products.slug = 'vinyl-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Sun Board Standee', 'vinyl-printing-sun-board-standee', NULL, 'Sun Board Standee by Shivrudra Graphics', 'Sun Board Standee service by Shivrudra Graphics.', 10, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'vinyl-printing' AND products.slug = 'vinyl-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Car Branding', 'vinyl-printing-car-branding', NULL, 'Car Branding by Shivrudra Graphics', 'Car Branding service by Shivrudra Graphics.', 11, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'vinyl-printing' AND products.slug = 'vinyl-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Wallpaper Printing', 'vinyl-printing-wallpaper-printing', NULL, 'Wallpaper Printing by Shivrudra Graphics', 'Wallpaper Printing service by Shivrudra Graphics.', 12, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'vinyl-printing' AND products.slug = 'vinyl-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Bus Branding', 'vinyl-printing-bus-branding', NULL, 'Bus Branding by Shivrudra Graphics', 'Bus Branding service by Shivrudra Graphics.', 13, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'vinyl-printing' AND products.slug = 'vinyl-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('UV Printing', 'uv-printing', 'High-resolution UV printing on rigid and flexible substrates.', 'High-resolution UV printing on rigid and flexible substrates.', '/images/services/uv-printing.png', 3, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'uv-printing'
  AND products.slug IN ('uv-vinyl-printing', 'uv-fabric-printing', 'uv-canvas-printing', 'uv-translite-printing', 'uv-acrylic-printing', 'uv-foam-printing', 'uv-acp-printing');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'UV Printing', 'uv-printing-products', 'UV Printing products', 'High-resolution UV printing on rigid and flexible substrates.', 0, 1
FROM services WHERE slug = 'uv-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'UV Vinyl Printing', 'uv-printing-uv-vinyl-printing', NULL, 'UV Vinyl Printing by Shivrudra Graphics', 'UV Vinyl Printing service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'uv-printing' AND products.slug = 'uv-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'UV Fabric Printing', 'uv-printing-uv-fabric-printing', NULL, 'UV Fabric Printing by Shivrudra Graphics', 'UV Fabric Printing service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'uv-printing' AND products.slug = 'uv-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'UV Canvas Printing', 'uv-printing-uv-canvas-printing', NULL, 'UV Canvas Printing by Shivrudra Graphics', 'UV Canvas Printing service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'uv-printing' AND products.slug = 'uv-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'UV Translite Printing', 'uv-printing-uv-translite-printing', NULL, 'UV Translite Printing by Shivrudra Graphics', 'UV Translite Printing service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'uv-printing' AND products.slug = 'uv-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'UV Acrylic Printing', 'uv-printing-uv-acrylic-printing', NULL, 'UV Acrylic Printing by Shivrudra Graphics', 'UV Acrylic Printing service by Shivrudra Graphics.', 4, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'uv-printing' AND products.slug = 'uv-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'UV Foam Printing', 'uv-printing-uv-foam-printing', NULL, 'UV Foam Printing by Shivrudra Graphics', 'UV Foam Printing service by Shivrudra Graphics.', 5, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'uv-printing' AND products.slug = 'uv-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'UV ACP Printing', 'uv-printing-uv-acp-printing', NULL, 'UV ACP Printing by Shivrudra Graphics', 'UV ACP Printing service by Shivrudra Graphics.', 6, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'uv-printing' AND products.slug = 'uv-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Screen Printing', 'screen-printing', 'Industrial screen printing on plastic, metal, glass and textiles.', 'Industrial screen printing on plastic, metal, glass and textiles.', '/images/services/screen-printing.png', 4, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing'
  AND products.slug IN ('polycarbonate-sticker-printing', 'polycarbonate-labels-printing', 'sun-pack-printing', 'bottle-printing', 'plastic-crate-printing', 'vinyl-tag-printing', 'polyester-printing', 'school-bag-printing', 'umbrella-printing', 'membrane-keypads', 'control-panel-sticker', 'pp-box-printing', 'corrugate-box-printing', 'metal-qr-code-printing', 'textile-printing', 'glass-printing', 'wooden-printing', 'ss-plate-printing', 'ms-plate-printing', 'aluminum-plate-printing');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Screen Printing', 'screen-printing-products', 'Screen Printing products', 'Industrial screen printing on plastic, metal, glass and textiles.', 0, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Polycarbonate Sticker Printing', 'screen-printing-polycarbonate-sticker-printing', NULL, 'Polycarbonate Sticker Printing by Shivrudra Graphics', 'Polycarbonate Sticker Printing service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Polycarbonate Labels Printing', 'screen-printing-polycarbonate-labels-printing', NULL, 'Polycarbonate Labels Printing by Shivrudra Graphics', 'Polycarbonate Labels Printing service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Sun Pack Printing', 'screen-printing-sun-pack-printing', NULL, 'Sun Pack Printing by Shivrudra Graphics', 'Sun Pack Printing service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Bottle Printing', 'screen-printing-bottle-printing', NULL, 'Bottle Printing by Shivrudra Graphics', 'Bottle Printing service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Plastic Crate Printing', 'screen-printing-plastic-crate-printing', NULL, 'Plastic Crate Printing by Shivrudra Graphics', 'Plastic Crate Printing service by Shivrudra Graphics.', 4, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Vinyl Tag Printing', 'screen-printing-vinyl-tag-printing', NULL, 'Vinyl Tag Printing by Shivrudra Graphics', 'Vinyl Tag Printing service by Shivrudra Graphics.', 5, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Polyester Printing', 'screen-printing-polyester-printing', NULL, 'Polyester Printing by Shivrudra Graphics', 'Polyester Printing service by Shivrudra Graphics.', 6, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'School Bag Printing', 'screen-printing-school-bag-printing', NULL, 'School Bag Printing by Shivrudra Graphics', 'School Bag Printing service by Shivrudra Graphics.', 7, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Umbrella Printing', 'screen-printing-umbrella-printing', NULL, 'Umbrella Printing by Shivrudra Graphics', 'Umbrella Printing service by Shivrudra Graphics.', 8, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Membrane Keypads', 'screen-printing-membrane-keypads', NULL, 'Membrane Keypads by Shivrudra Graphics', 'Membrane Keypads service by Shivrudra Graphics.', 9, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Control Panel Sticker', 'screen-printing-control-panel-sticker', NULL, 'Control Panel Sticker by Shivrudra Graphics', 'Control Panel Sticker service by Shivrudra Graphics.', 10, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'PP Box Printing', 'screen-printing-pp-box-printing', NULL, 'PP Box Printing by Shivrudra Graphics', 'PP Box Printing service by Shivrudra Graphics.', 11, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Corrugate Box Printing', 'screen-printing-corrugate-box-printing', NULL, 'Corrugate Box Printing by Shivrudra Graphics', 'Corrugate Box Printing service by Shivrudra Graphics.', 12, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Metal QR Code Printing', 'screen-printing-metal-qr-code-printing', NULL, 'Metal QR Code Printing by Shivrudra Graphics', 'Metal QR Code Printing service by Shivrudra Graphics.', 13, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Textile Printing', 'screen-printing-textile-printing', NULL, 'Textile Printing by Shivrudra Graphics', 'Textile Printing service by Shivrudra Graphics.', 14, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Glass Printing', 'screen-printing-glass-printing', NULL, 'Glass Printing by Shivrudra Graphics', 'Glass Printing service by Shivrudra Graphics.', 15, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Wooden Printing', 'screen-printing-wooden-printing', NULL, 'Wooden Printing by Shivrudra Graphics', 'Wooden Printing service by Shivrudra Graphics.', 16, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'SS Plate Printing', 'screen-printing-ss-plate-printing', NULL, 'SS Plate Printing by Shivrudra Graphics', 'SS Plate Printing service by Shivrudra Graphics.', 17, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'MS Plate Printing', 'screen-printing-ms-plate-printing', NULL, 'MS Plate Printing by Shivrudra Graphics', 'MS Plate Printing service by Shivrudra Graphics.', 18, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Aluminum Plate Printing', 'screen-printing-aluminum-plate-printing', NULL, 'Aluminum Plate Printing by Shivrudra Graphics', 'Aluminum Plate Printing service by Shivrudra Graphics.', 19, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'screen-printing' AND products.slug = 'screen-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Digital Printing', 'digital-printing', 'Crisp digital prints for labels, tags, cards and packaging.', 'Crisp digital prints for labels, tags, cards and packaging.', '/images/services/digital-printing.png', 5, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing'
  AND products.slug IN ('texture-paper-printing', 'sticker-paper-printing', 'nt-paper-printing', 'transparent-paper-printing', 'product-label-printing', 'tag-printing', 'coupon-printing', 'wristband-printing', 'certificate-printing', 'tent-cards-printing', 'invitation-cards-printing', 'menu-card-printing', 'danglers-printing', 'barcode-sticker-printing', 'safety-signage-poster-printing', 'door-hangers-printing', 'vehicle-parking-sticker-printing', 'cable-tag-printing', 'roll-labels-printing', 'packaging-sticker-printing', 'custom-car-stickers', 'pvc-id-card-printing', 'lanyard-printing', 'industrial-packaging-label');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Digital Printing', 'digital-printing-products', 'Digital Printing products', 'Crisp digital prints for labels, tags, cards and packaging.', 0, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Texture Paper Printing', 'digital-printing-texture-paper-printing', NULL, 'Texture Paper Printing by Shivrudra Graphics', 'Texture Paper Printing service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Sticker Paper Printing', 'digital-printing-sticker-paper-printing', NULL, 'Sticker Paper Printing by Shivrudra Graphics', 'Sticker Paper Printing service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'NT Paper Printing', 'digital-printing-nt-paper-printing', NULL, 'NT Paper Printing by Shivrudra Graphics', 'NT Paper Printing service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Transparent Paper Printing', 'digital-printing-transparent-paper-printing', NULL, 'Transparent Paper Printing by Shivrudra Graphics', 'Transparent Paper Printing service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Product Label Printing', 'digital-printing-product-label-printing', NULL, 'Product Label Printing by Shivrudra Graphics', 'Product Label Printing service by Shivrudra Graphics.', 4, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Tag Printing', 'digital-printing-tag-printing', NULL, 'Tag Printing by Shivrudra Graphics', 'Tag Printing service by Shivrudra Graphics.', 5, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Coupon Printing', 'digital-printing-coupon-printing', NULL, 'Coupon Printing by Shivrudra Graphics', 'Coupon Printing service by Shivrudra Graphics.', 6, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Wristband Printing', 'digital-printing-wristband-printing', NULL, 'Wristband Printing by Shivrudra Graphics', 'Wristband Printing service by Shivrudra Graphics.', 7, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Certificate Printing', 'digital-printing-certificate-printing', NULL, 'Certificate Printing by Shivrudra Graphics', 'Certificate Printing service by Shivrudra Graphics.', 8, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Tent Cards Printing', 'digital-printing-tent-cards-printing', NULL, 'Tent Cards Printing by Shivrudra Graphics', 'Tent Cards Printing service by Shivrudra Graphics.', 9, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Invitation Cards Printing', 'digital-printing-invitation-cards-printing', NULL, 'Invitation Cards Printing by Shivrudra Graphics', 'Invitation Cards Printing service by Shivrudra Graphics.', 10, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Menu Card Printing', 'digital-printing-menu-card-printing', NULL, 'Menu Card Printing by Shivrudra Graphics', 'Menu Card Printing service by Shivrudra Graphics.', 11, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Danglers Printing', 'digital-printing-danglers-printing', NULL, 'Danglers Printing by Shivrudra Graphics', 'Danglers Printing service by Shivrudra Graphics.', 12, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Barcode Sticker Printing', 'digital-printing-barcode-sticker-printing', NULL, 'Barcode Sticker Printing by Shivrudra Graphics', 'Barcode Sticker Printing service by Shivrudra Graphics.', 13, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Safety Signage Poster Printing', 'digital-printing-safety-signage-poster-printing', NULL, 'Safety Signage Poster Printing by Shivrudra Graphics', 'Safety Signage Poster Printing service by Shivrudra Graphics.', 14, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Door Hangers Printing', 'digital-printing-door-hangers-printing', NULL, 'Door Hangers Printing by Shivrudra Graphics', 'Door Hangers Printing service by Shivrudra Graphics.', 15, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Vehicle Parking Sticker Printing', 'digital-printing-vehicle-parking-sticker-printing', NULL, 'Vehicle Parking Sticker Printing by Shivrudra Graphics', 'Vehicle Parking Sticker Printing service by Shivrudra Graphics.', 16, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Cable Tag Printing', 'digital-printing-cable-tag-printing', NULL, 'Cable Tag Printing by Shivrudra Graphics', 'Cable Tag Printing service by Shivrudra Graphics.', 17, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Roll Labels Printing', 'digital-printing-roll-labels-printing', NULL, 'Roll Labels Printing by Shivrudra Graphics', 'Roll Labels Printing service by Shivrudra Graphics.', 18, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Packaging Sticker Printing', 'digital-printing-packaging-sticker-printing', NULL, 'Packaging Sticker Printing by Shivrudra Graphics', 'Packaging Sticker Printing service by Shivrudra Graphics.', 19, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Custom Car Stickers', 'digital-printing-custom-car-stickers', NULL, 'Custom Car Stickers by Shivrudra Graphics', 'Custom Car Stickers service by Shivrudra Graphics.', 20, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'PVC ID Card Printing', 'digital-printing-pvc-id-card-printing', NULL, 'PVC ID Card Printing by Shivrudra Graphics', 'PVC ID Card Printing service by Shivrudra Graphics.', 21, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Lanyard Printing', 'digital-printing-lanyard-printing', NULL, 'Lanyard Printing by Shivrudra Graphics', 'Lanyard Printing service by Shivrudra Graphics.', 22, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Industrial Packaging Label', 'digital-printing-industrial-packaging-label', NULL, 'Industrial Packaging Label by Shivrudra Graphics', 'Industrial Packaging Label service by Shivrudra Graphics.', 23, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'digital-printing' AND products.slug = 'digital-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Offset Printing', 'offset-printing', 'Bulk offset printing for stationery, books and packaging.', 'Bulk offset printing for stationery, books and packaging.', '/images/services/offset-printing.png', 6, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing'
  AND products.slug IN ('pawati-book-printing', 'gift-voucher-printing', 'packaging-sleeves', 'wrapping-paper', 'seal-stickers', 'ticket-printing', 'bookmark-printing', 'rack-card-printing', 'header-card-printing', 'shelf-wobblers-printing', 'bottle-neck-tags-printing', 'swing-tags-printing', 'tree-tag-printing', 'cloth-tag-printing', 'business-card-printing', 'envelope-printing', 'brochure-printing', 'leaflet-printing', 'letterhead-printing', 'register-printing', 'bank-form-printing', 'prospectus-printing', 'stationery-printing', 'pharmacy-literature-printing', 'scratch-card-printing', 'box-printing', 'synthetic-tags', 'report-card-printing', 'file-printing', 'hospital-file-printing', 'pocket-folder-printing', 'prescription-pad-printing', 'medical-pouch-printing', 'calendar-printing', 'diary-printing', 'bill-book-printing', 'receipt-book-printing', 'notebook-printing', 'catalogue-printing', 'notepads-printing');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Offset Printing', 'offset-printing-products', 'Offset Printing products', 'Bulk offset printing for stationery, books and packaging.', 0, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Pawati Book Printing', 'offset-printing-pawati-book-printing', NULL, 'Pawati Book Printing by Shivrudra Graphics', 'Pawati Book Printing service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Gift Voucher Printing', 'offset-printing-gift-voucher-printing', NULL, 'Gift Voucher Printing by Shivrudra Graphics', 'Gift Voucher Printing service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Packaging Sleeves', 'offset-printing-packaging-sleeves', NULL, 'Packaging Sleeves by Shivrudra Graphics', 'Packaging Sleeves service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Wrapping Paper', 'offset-printing-wrapping-paper', NULL, 'Wrapping Paper by Shivrudra Graphics', 'Wrapping Paper service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Seal Stickers', 'offset-printing-seal-stickers', NULL, 'Seal Stickers by Shivrudra Graphics', 'Seal Stickers service by Shivrudra Graphics.', 4, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Ticket Printing', 'offset-printing-ticket-printing', NULL, 'Ticket Printing by Shivrudra Graphics', 'Ticket Printing service by Shivrudra Graphics.', 5, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Bookmark Printing', 'offset-printing-bookmark-printing', NULL, 'Bookmark Printing by Shivrudra Graphics', 'Bookmark Printing service by Shivrudra Graphics.', 6, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Rack Card Printing', 'offset-printing-rack-card-printing', NULL, 'Rack Card Printing by Shivrudra Graphics', 'Rack Card Printing service by Shivrudra Graphics.', 7, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Header Card Printing', 'offset-printing-header-card-printing', NULL, 'Header Card Printing by Shivrudra Graphics', 'Header Card Printing service by Shivrudra Graphics.', 8, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Shelf Wobblers Printing', 'offset-printing-shelf-wobblers-printing', NULL, 'Shelf Wobblers Printing by Shivrudra Graphics', 'Shelf Wobblers Printing service by Shivrudra Graphics.', 9, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Bottle Neck Tags Printing', 'offset-printing-bottle-neck-tags-printing', NULL, 'Bottle Neck Tags Printing by Shivrudra Graphics', 'Bottle Neck Tags Printing service by Shivrudra Graphics.', 10, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Swing Tags Printing', 'offset-printing-swing-tags-printing', NULL, 'Swing Tags Printing by Shivrudra Graphics', 'Swing Tags Printing service by Shivrudra Graphics.', 11, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Tree Tag Printing', 'offset-printing-tree-tag-printing', NULL, 'Tree Tag Printing by Shivrudra Graphics', 'Tree Tag Printing service by Shivrudra Graphics.', 12, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Cloth Tag Printing', 'offset-printing-cloth-tag-printing', NULL, 'Cloth Tag Printing by Shivrudra Graphics', 'Cloth Tag Printing service by Shivrudra Graphics.', 13, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Business Card Printing', 'offset-printing-business-card-printing', NULL, 'Business Card Printing by Shivrudra Graphics', 'Business Card Printing service by Shivrudra Graphics.', 14, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Envelope Printing', 'offset-printing-envelope-printing', NULL, 'Envelope Printing by Shivrudra Graphics', 'Envelope Printing service by Shivrudra Graphics.', 15, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Brochure Printing', 'offset-printing-brochure-printing', NULL, 'Brochure Printing by Shivrudra Graphics', 'Brochure Printing service by Shivrudra Graphics.', 16, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Leaflet Printing', 'offset-printing-leaflet-printing', NULL, 'Leaflet Printing by Shivrudra Graphics', 'Leaflet Printing service by Shivrudra Graphics.', 17, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Letterhead Printing', 'offset-printing-letterhead-printing', NULL, 'Letterhead Printing by Shivrudra Graphics', 'Letterhead Printing service by Shivrudra Graphics.', 18, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Register Printing', 'offset-printing-register-printing', NULL, 'Register Printing by Shivrudra Graphics', 'Register Printing service by Shivrudra Graphics.', 19, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Bank Form Printing', 'offset-printing-bank-form-printing', NULL, 'Bank Form Printing by Shivrudra Graphics', 'Bank Form Printing service by Shivrudra Graphics.', 20, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Prospectus Printing', 'offset-printing-prospectus-printing', NULL, 'Prospectus Printing by Shivrudra Graphics', 'Prospectus Printing service by Shivrudra Graphics.', 21, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Stationery Printing', 'offset-printing-stationery-printing', NULL, 'Stationery Printing by Shivrudra Graphics', 'Stationery Printing service by Shivrudra Graphics.', 22, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Pharmacy Literature Printing', 'offset-printing-pharmacy-literature-printing', NULL, 'Pharmacy Literature Printing by Shivrudra Graphics', 'Pharmacy Literature Printing service by Shivrudra Graphics.', 23, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Scratch Card Printing', 'offset-printing-scratch-card-printing', NULL, 'Scratch Card Printing by Shivrudra Graphics', 'Scratch Card Printing service by Shivrudra Graphics.', 24, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Box Printing', 'offset-printing-box-printing', NULL, 'Box Printing by Shivrudra Graphics', 'Box Printing service by Shivrudra Graphics.', 25, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Synthetic Tags', 'offset-printing-synthetic-tags', NULL, 'Synthetic Tags by Shivrudra Graphics', 'Synthetic Tags service by Shivrudra Graphics.', 26, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Report Card Printing', 'offset-printing-report-card-printing', NULL, 'Report Card Printing by Shivrudra Graphics', 'Report Card Printing service by Shivrudra Graphics.', 27, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'File Printing', 'offset-printing-file-printing', NULL, 'File Printing by Shivrudra Graphics', 'File Printing service by Shivrudra Graphics.', 28, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Hospital File Printing', 'offset-printing-hospital-file-printing', NULL, 'Hospital File Printing by Shivrudra Graphics', 'Hospital File Printing service by Shivrudra Graphics.', 29, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Pocket Folder Printing', 'offset-printing-pocket-folder-printing', NULL, 'Pocket Folder Printing by Shivrudra Graphics', 'Pocket Folder Printing service by Shivrudra Graphics.', 30, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Prescription Pad Printing', 'offset-printing-prescription-pad-printing', NULL, 'Prescription Pad Printing by Shivrudra Graphics', 'Prescription Pad Printing service by Shivrudra Graphics.', 31, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Medical Pouch Printing', 'offset-printing-medical-pouch-printing', NULL, 'Medical Pouch Printing by Shivrudra Graphics', 'Medical Pouch Printing service by Shivrudra Graphics.', 32, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Calendar Printing', 'offset-printing-calendar-printing', NULL, 'Calendar Printing by Shivrudra Graphics', 'Calendar Printing service by Shivrudra Graphics.', 33, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Diary Printing', 'offset-printing-diary-printing', NULL, 'Diary Printing by Shivrudra Graphics', 'Diary Printing service by Shivrudra Graphics.', 34, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Bill Book Printing', 'offset-printing-bill-book-printing', NULL, 'Bill Book Printing by Shivrudra Graphics', 'Bill Book Printing service by Shivrudra Graphics.', 35, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Receipt Book Printing', 'offset-printing-receipt-book-printing', NULL, 'Receipt Book Printing by Shivrudra Graphics', 'Receipt Book Printing service by Shivrudra Graphics.', 36, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Notebook Printing', 'offset-printing-notebook-printing', NULL, 'Notebook Printing by Shivrudra Graphics', 'Notebook Printing service by Shivrudra Graphics.', 37, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Catalogue Printing', 'offset-printing-catalogue-printing', NULL, 'Catalogue Printing by Shivrudra Graphics', 'Catalogue Printing service by Shivrudra Graphics.', 38, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Notepads Printing', 'offset-printing-notepads-printing', NULL, 'Notepads Printing by Shivrudra Graphics', 'Notepads Printing service by Shivrudra Graphics.', 39, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'offset-printing' AND products.slug = 'offset-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Photo Frame', 'photo-frame', 'Custom photo frames in premium finishes.', 'Custom photo frames in premium finishes.', '/images/services/photo-frame.jpg', 7, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'photo-frame'
  AND products.slug IN ('wooden-frames', 'acrylic-frames', 'collage-frames', 'award-frames');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Photo Frame', 'photo-frame-products', 'Photo Frame products', 'Custom photo frames in premium finishes.', 0, 1
FROM services WHERE slug = 'photo-frame'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Wooden Frames', 'photo-frame-wooden-frames', NULL, 'Wooden Frames by Shivrudra Graphics', 'Wooden Frames service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'photo-frame' AND products.slug = 'photo-frame-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Acrylic Frames', 'photo-frame-acrylic-frames', NULL, 'Acrylic Frames by Shivrudra Graphics', 'Acrylic Frames service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'photo-frame' AND products.slug = 'photo-frame-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Collage Frames', 'photo-frame-collage-frames', NULL, 'Collage Frames by Shivrudra Graphics', 'Collage Frames service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'photo-frame' AND products.slug = 'photo-frame-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Award Frames', 'photo-frame-award-frames', NULL, 'Award Frames by Shivrudra Graphics', 'Award Frames service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'photo-frame' AND products.slug = 'photo-frame-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Badge & Dome Printing', 'badge-dome-printing', 'Glossy dome stickers and brand badges.', 'Glossy dome stickers and brand badges.', '/images/services/badge-and-dome-printing.png', 8, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'badge-dome-printing'
  AND products.slug IN ('dome-stickers', 'metal-badges', 'id-badges', 'logo-domes');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Badge & Dome Printing', 'badge-dome-printing-products', 'Badge & Dome Printing products', 'Glossy dome stickers and brand badges.', 0, 1
FROM services WHERE slug = 'badge-dome-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Dome Stickers', 'badge-dome-printing-dome-stickers', NULL, 'Dome Stickers by Shivrudra Graphics', 'Dome Stickers service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'badge-dome-printing' AND products.slug = 'badge-dome-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Metal Badges', 'badge-dome-printing-metal-badges', NULL, 'Metal Badges by Shivrudra Graphics', 'Metal Badges service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'badge-dome-printing' AND products.slug = 'badge-dome-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'ID Badges', 'badge-dome-printing-id-badges', NULL, 'ID Badges by Shivrudra Graphics', 'ID Badges service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'badge-dome-printing' AND products.slug = 'badge-dome-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Logo Domes', 'badge-dome-printing-logo-domes', NULL, 'Logo Domes by Shivrudra Graphics', 'Logo Domes service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'badge-dome-printing' AND products.slug = 'badge-dome-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Bag Printing', 'bag-printing', 'Custom printed bags for promotion and retail.', 'Custom printed bags for promotion and retail.', '/images/services/bag-printing.png', 9, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'bag-printing'
  AND products.slug IN ('cloth-bags', 'non-woven-bags', 'jute-bags', 'paper-bags');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Bag Printing', 'bag-printing-products', 'Bag Printing products', 'Custom printed bags for promotion and retail.', 0, 1
FROM services WHERE slug = 'bag-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Cloth Bags', 'bag-printing-cloth-bags', NULL, 'Cloth Bags by Shivrudra Graphics', 'Cloth Bags service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'bag-printing' AND products.slug = 'bag-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Non Woven Bags', 'bag-printing-non-woven-bags', NULL, 'Non Woven Bags by Shivrudra Graphics', 'Non Woven Bags service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'bag-printing' AND products.slug = 'bag-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Jute Bags', 'bag-printing-jute-bags', NULL, 'Jute Bags by Shivrudra Graphics', 'Jute Bags service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'bag-printing' AND products.slug = 'bag-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Paper Bags', 'bag-printing-paper-bags', NULL, 'Paper Bags by Shivrudra Graphics', 'Paper Bags service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'bag-printing' AND products.slug = 'bag-printing-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Stamp', 'stamp', 'Custom stamps for office, billing, numbering and date marking needs.', 'Custom stamps for office, billing, numbering and date marking needs.', '/images/services/rubber-stamps.png', 10, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'stamp'
  AND products.slug IN ('stamp', 'pre-ink-stamp', 'sun-stamp', 'colop-stamp', 'trodat-stamp', 'numbering-stamp', 'colop-numbering-stamp', 'dolphin-numbering-stamp', 'dater-stamp', 'colop-dater-stamp', 'dolphin-dater-stamp');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Stamp', 'stamp-products', 'Stamp products', 'Custom stamps for office, billing, numbering and date marking needs.', 0, 1
FROM services WHERE slug = 'stamp'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Stamp', 'stamp-stamp', NULL, 'Stamp by Shivrudra Graphics', 'Stamp service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'stamp' AND products.slug = 'stamp-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Pre Ink Stamp', 'stamp-pre-ink-stamp', NULL, 'Pre Ink Stamp by Shivrudra Graphics', 'Pre Ink Stamp service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'stamp' AND products.slug = 'stamp-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Sun Stamp', 'stamp-sun-stamp', NULL, 'Sun Stamp by Shivrudra Graphics', 'Sun Stamp service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'stamp' AND products.slug = 'stamp-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Colop Stamp', 'stamp-colop-stamp', NULL, 'Colop Stamp by Shivrudra Graphics', 'Colop Stamp service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'stamp' AND products.slug = 'stamp-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Trodat Stamp', 'stamp-trodat-stamp', NULL, 'Trodat Stamp by Shivrudra Graphics', 'Trodat Stamp service by Shivrudra Graphics.', 4, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'stamp' AND products.slug = 'stamp-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Numbering Stamp', 'stamp-numbering-stamp', NULL, 'Numbering Stamp by Shivrudra Graphics', 'Numbering Stamp service by Shivrudra Graphics.', 5, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'stamp' AND products.slug = 'stamp-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Colop Numbering Stamp', 'stamp-colop-numbering-stamp', NULL, 'Colop Numbering Stamp by Shivrudra Graphics', 'Colop Numbering Stamp service by Shivrudra Graphics.', 6, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'stamp' AND products.slug = 'stamp-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Dolphin Numbering Stamp', 'stamp-dolphin-numbering-stamp', NULL, 'Dolphin Numbering Stamp by Shivrudra Graphics', 'Dolphin Numbering Stamp service by Shivrudra Graphics.', 7, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'stamp' AND products.slug = 'stamp-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Dater Stamp', 'stamp-dater-stamp', NULL, 'Dater Stamp by Shivrudra Graphics', 'Dater Stamp service by Shivrudra Graphics.', 8, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'stamp' AND products.slug = 'stamp-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Colop Dater Stamp', 'stamp-colop-dater-stamp', NULL, 'Colop Dater Stamp by Shivrudra Graphics', 'Colop Dater Stamp service by Shivrudra Graphics.', 9, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'stamp' AND products.slug = 'stamp-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Dolphin Dater Stamp', 'stamp-dolphin-dater-stamp', NULL, 'Dolphin Dater Stamp by Shivrudra Graphics', 'Dolphin Dater Stamp service by Shivrudra Graphics.', 10, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'stamp' AND products.slug = 'stamp-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Engraving & Marking', 'engraving-marking', 'Laser engraving and industrial marking solutions.', 'Laser engraving and industrial marking solutions.', '/images/services/engraving-and-marking.png', 11, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'engraving-marking'
  AND products.slug IN ('laser-engraving', 'metal-marking', 'acrylic-engraving', 'wood-engraving');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Engraving & Marking', 'engraving-marking-products', 'Engraving & Marking products', 'Laser engraving and industrial marking solutions.', 0, 1
FROM services WHERE slug = 'engraving-marking'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Laser Engraving', 'engraving-marking-laser-engraving', NULL, 'Laser Engraving by Shivrudra Graphics', 'Laser Engraving service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'engraving-marking' AND products.slug = 'engraving-marking-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Metal Marking', 'engraving-marking-metal-marking', NULL, 'Metal Marking by Shivrudra Graphics', 'Metal Marking service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'engraving-marking' AND products.slug = 'engraving-marking-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Acrylic Engraving', 'engraving-marking-acrylic-engraving', NULL, 'Acrylic Engraving by Shivrudra Graphics', 'Acrylic Engraving service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'engraving-marking' AND products.slug = 'engraving-marking-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Wood Engraving', 'engraving-marking-wood-engraving', NULL, 'Wood Engraving by Shivrudra Graphics', 'Wood Engraving service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'engraving-marking' AND products.slug = 'engraving-marking-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Keychains', 'keychain', 'Custom keychains for promotions and gifting.', 'Custom keychains for promotions and gifting.', '/images/services/keychains.png', 12, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'keychain'
  AND products.slug IN ('metal-keychains', 'acrylic-keychains', 'wooden-keychains', 'led-keychains');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Keychains', 'keychain-products', 'Keychains products', 'Custom keychains for promotions and gifting.', 0, 1
FROM services WHERE slug = 'keychain'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Metal Keychains', 'keychain-metal-keychains', NULL, 'Metal Keychains by Shivrudra Graphics', 'Metal Keychains service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'keychain' AND products.slug = 'keychain-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Acrylic Keychains', 'keychain-acrylic-keychains', NULL, 'Acrylic Keychains by Shivrudra Graphics', 'Acrylic Keychains service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'keychain' AND products.slug = 'keychain-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Wooden Keychains', 'keychain-wooden-keychains', NULL, 'Wooden Keychains by Shivrudra Graphics', 'Wooden Keychains service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'keychain' AND products.slug = 'keychain-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'LED Keychains', 'keychain-led-keychains', NULL, 'LED Keychains by Shivrudra Graphics', 'LED Keychains service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'keychain' AND products.slug = 'keychain-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Corporate Gifts', 'corporate-gift', 'Premium curated gifts for clients & employees.', 'Premium curated gifts for clients & employees.', '/images/services/corporate-gift.jpg', 13, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift'
  AND products.slug IN ('pen-keychain', 'cardholder-pen-keychain', 'dairy-pen', 'pen-dairy-keychain', 'pen-dairy-keychain-cardholder', 'pen-dairy-mug', 'pen-bottle-keychain', 'pen-keychain-dairy-temperature-bottle', 'pen-dairy-keychain-cardholder-temperature-bottle', 'pen-dairy-mug-keychain-mobile-stand-temperature-bottle', 'dairy-pen-temperature-bottle-laptop-stand', 'bamboo-dairy-cardholder-keychain-pen', 'pen', 'keychain', 'mobile-stand', 'bottle', 'mug', 'mug-printing', 'cardholder', 'dairy');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Corporate Gifts', 'corporate-gift-products', 'Corporate Gifts products', 'Premium curated gifts for clients & employees.', 0, 1
FROM services WHERE slug = 'corporate-gift'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Pen + Keychain', 'corporate-gift-pen-keychain', 15, '15 Items', 'Pen + Keychain service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Cardholder + Pen + Keychain', 'corporate-gift-cardholder-pen-keychain', 6, '6 Items', 'Cardholder + Pen + Keychain service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Dairy + Pen', 'corporate-gift-dairy-pen', 36, '36 Items', 'Dairy + Pen service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Pen + Dairy + Keychain', 'corporate-gift-pen-dairy-keychain', 14, '14 Items', 'Pen + Dairy + Keychain service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Pen + Dairy + Keychain + Cardholder', 'corporate-gift-pen-dairy-keychain-cardholder', 13, '13 Items', 'Pen + Dairy + Keychain + Cardholder service by Shivrudra Graphics.', 4, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Pen + Dairy + Mug', 'corporate-gift-pen-dairy-mug', 5, '5 Items', 'Pen + Dairy + Mug service by Shivrudra Graphics.', 5, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Pen + Bottle + Keychain', 'corporate-gift-pen-bottle-keychain', 10, '10 Items', 'Pen + Bottle + Keychain service by Shivrudra Graphics.', 6, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Pen + Keychain + Dairy + Temperature Bottle', 'corporate-gift-pen-keychain-dairy-temperature-bottle', 4, '4 Items', 'Pen + Keychain + Dairy + Temperature Bottle service by Shivrudra Graphics.', 7, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Pen + Dairy + Keychain + Cardholder + Temperature Bottle', 'corporate-gift-pen-dairy-keychain-cardholder-temperature-bottle', 6, '6 Items', 'Pen + Dairy + Keychain + Cardholder + Temperature Bottle service by Shivrudra Graphics.', 8, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Pen + Dairy + Mug + Keychain + Mobile Stand + Temperature Bottle', 'corporate-gift-pen-dairy-mug-keychain-mobile-stand-temperature-bottle', 5, '5 Items', 'Pen + Dairy + Mug + Keychain + Mobile Stand + Temperature Bottle service by Shivrudra Graphics.', 9, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Dairy + Pen + Temperature Bottle + Laptop Stand', 'corporate-gift-dairy-pen-temperature-bottle-laptop-stand', 2, '2 Items', 'Dairy + Pen + Temperature Bottle + Laptop Stand service by Shivrudra Graphics.', 10, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Bamboo Dairy + Cardholder + Keychain + Pen', 'corporate-gift-bamboo-dairy-cardholder-keychain-pen', 9, '9 Items', 'Bamboo Dairy + Cardholder + Keychain + Pen service by Shivrudra Graphics.', 11, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Pen', 'corporate-gift-pen', 50, '50 Items', 'Pen service by Shivrudra Graphics.', 12, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Keychain', 'corporate-gift-keychain', 7, '7 Items', 'Keychain service by Shivrudra Graphics.', 13, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Mobile Stand', 'corporate-gift-mobile-stand', 5, '5 Items', 'Mobile Stand service by Shivrudra Graphics.', 14, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Bottle', 'corporate-gift-bottle', 27, '27 Items', 'Bottle service by Shivrudra Graphics.', 15, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Mug', 'corporate-gift-mug', 22, '22 Items', 'Mug service by Shivrudra Graphics.', 16, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Mug Printing', 'corporate-gift-mug-printing', 1, '1 Item', 'Mug Printing service by Shivrudra Graphics.', 17, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Cardholder', 'corporate-gift-cardholder', 20, '20 Items', 'Cardholder service by Shivrudra Graphics.', 18, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Dairy', 'corporate-gift-dairy', 16, '16 Items', 'Dairy service by Shivrudra Graphics.', 19, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'corporate-gift' AND products.slug = 'corporate-gift-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Industrial Name Plates', 'industrial-name-plates', 'Durable name plates for industrial use.', 'Durable name plates for industrial use.', '/images/services/industrial-name-plates.png', 14, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'industrial-name-plates'
  AND products.slug IN ('ss-name-plates', 'ms-name-plates', 'aluminum-plates', 'anodized-plates');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Industrial Name Plates', 'industrial-name-plates-products', 'Industrial Name Plates products', 'Durable name plates for industrial use.', 0, 1
FROM services WHERE slug = 'industrial-name-plates'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'SS Name Plates', 'industrial-name-plates-ss-name-plates', NULL, 'SS Name Plates by Shivrudra Graphics', 'SS Name Plates service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'industrial-name-plates' AND products.slug = 'industrial-name-plates-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'MS Name Plates', 'industrial-name-plates-ms-name-plates', NULL, 'MS Name Plates by Shivrudra Graphics', 'MS Name Plates service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'industrial-name-plates' AND products.slug = 'industrial-name-plates-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Aluminum Plates', 'industrial-name-plates-aluminum-plates', NULL, 'Aluminum Plates by Shivrudra Graphics', 'Aluminum Plates service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'industrial-name-plates' AND products.slug = 'industrial-name-plates-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Anodized Plates', 'industrial-name-plates-anodized-plates', NULL, 'Anodized Plates by Shivrudra Graphics', 'Anodized Plates service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'industrial-name-plates' AND products.slug = 'industrial-name-plates-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Premium Signages', 'signage', 'Premium wayfinding, name plate, award and acrylic signage solutions.', 'Premium wayfinding, name plate, award and acrylic signage solutions.', '/images/services/signage.png', 15, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'signage'
  AND products.slug IN ('way-finding-signage', 'free-hand-signage', 'directory-signage', 'table-top-signage', 'home-name-plates', 'plaque', 'awards', 'hangers', '3d-sign', '2d-sign', 'acrylic-sign');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Premium Signages', 'signage-products', 'Premium Signages products', 'Premium wayfinding, name plate, award and acrylic signage solutions.', 0, 1
FROM services WHERE slug = 'signage'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Way Finding Signage', 'signage-way-finding-signage', NULL, 'Way Finding Signage by Shivrudra Graphics', 'Way Finding Signage service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'signage' AND products.slug = 'signage-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Free Hand Signage', 'signage-free-hand-signage', NULL, 'Free Hand Signage by Shivrudra Graphics', 'Free Hand Signage service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'signage' AND products.slug = 'signage-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Directory Signage', 'signage-directory-signage', NULL, 'Directory Signage by Shivrudra Graphics', 'Directory Signage service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'signage' AND products.slug = 'signage-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Table Top Signage', 'signage-table-top-signage', NULL, 'Table Top Signage by Shivrudra Graphics', 'Table Top Signage service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'signage' AND products.slug = 'signage-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Home Name Plates', 'signage-home-name-plates', NULL, 'Home Name Plates by Shivrudra Graphics', 'Home Name Plates service by Shivrudra Graphics.', 4, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'signage' AND products.slug = 'signage-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Plaque', 'signage-plaque', NULL, 'Plaque by Shivrudra Graphics', 'Plaque service by Shivrudra Graphics.', 5, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'signage' AND products.slug = 'signage-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Awards', 'signage-awards', NULL, 'Awards by Shivrudra Graphics', 'Awards service by Shivrudra Graphics.', 6, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'signage' AND products.slug = 'signage-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Hangers', 'signage-hangers', NULL, 'Hangers by Shivrudra Graphics', 'Hangers service by Shivrudra Graphics.', 7, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'signage' AND products.slug = 'signage-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, '3D Sign', 'signage-3d-sign', NULL, '3D Sign by Shivrudra Graphics', '3D Sign service by Shivrudra Graphics.', 8, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'signage' AND products.slug = 'signage-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, '2D Sign', 'signage-2d-sign', NULL, '2D Sign by Shivrudra Graphics', '2D Sign service by Shivrudra Graphics.', 9, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'signage' AND products.slug = 'signage-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Acrylic Sign', 'signage-acrylic-sign', NULL, 'Acrylic Sign by Shivrudra Graphics', 'Acrylic Sign service by Shivrudra Graphics.', 10, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'signage' AND products.slug = 'signage-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Trophies & Medals', 'trophies-medals', 'Custom trophies, medals and certificates for events and recognition.', 'Custom trophies, medals and certificates for events and recognition.', '/images/services/trophies-and-medals.png', 16, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'trophies-medals'
  AND products.slug IN ('acrylic-trophies', 'wooden-trophies', 'plastic-frame-trophies', 'metal-frame-trophies', 'foil-trophies', 'metal-trophies', 'abs-trophies', 'flag-trophies', 'cups-trophies', 'medals', 'silver-certificate', 'golden-certificate');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Trophies & Medals', 'trophies-medals-products', 'Trophies & Medals products', 'Custom trophies, medals and certificates for events and recognition.', 0, 1
FROM services WHERE slug = 'trophies-medals'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Acrylic Trophies', 'trophies-medals-acrylic-trophies', NULL, 'Acrylic Trophies by Shivrudra Graphics', 'Acrylic Trophies service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'trophies-medals' AND products.slug = 'trophies-medals-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Wooden Trophies', 'trophies-medals-wooden-trophies', NULL, 'Wooden Trophies by Shivrudra Graphics', 'Wooden Trophies service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'trophies-medals' AND products.slug = 'trophies-medals-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Plastic Frame Trophies', 'trophies-medals-plastic-frame-trophies', NULL, 'Plastic Frame Trophies by Shivrudra Graphics', 'Plastic Frame Trophies service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'trophies-medals' AND products.slug = 'trophies-medals-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Metal Frame Trophies', 'trophies-medals-metal-frame-trophies', NULL, 'Metal Frame Trophies by Shivrudra Graphics', 'Metal Frame Trophies service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'trophies-medals' AND products.slug = 'trophies-medals-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Foil Trophies', 'trophies-medals-foil-trophies', NULL, 'Foil Trophies by Shivrudra Graphics', 'Foil Trophies service by Shivrudra Graphics.', 4, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'trophies-medals' AND products.slug = 'trophies-medals-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Metal Trophies', 'trophies-medals-metal-trophies', NULL, 'Metal Trophies by Shivrudra Graphics', 'Metal Trophies service by Shivrudra Graphics.', 5, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'trophies-medals' AND products.slug = 'trophies-medals-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'ABS Trophies', 'trophies-medals-abs-trophies', NULL, 'ABS Trophies by Shivrudra Graphics', 'ABS Trophies service by Shivrudra Graphics.', 6, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'trophies-medals' AND products.slug = 'trophies-medals-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Flag Trophies', 'trophies-medals-flag-trophies', NULL, 'Flag Trophies by Shivrudra Graphics', 'Flag Trophies service by Shivrudra Graphics.', 7, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'trophies-medals' AND products.slug = 'trophies-medals-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Cups Trophies', 'trophies-medals-cups-trophies', NULL, 'Cups Trophies by Shivrudra Graphics', 'Cups Trophies service by Shivrudra Graphics.', 8, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'trophies-medals' AND products.slug = 'trophies-medals-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Medals', 'trophies-medals-medals', NULL, 'Medals by Shivrudra Graphics', 'Medals service by Shivrudra Graphics.', 9, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'trophies-medals' AND products.slug = 'trophies-medals-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Silver Certificate', 'trophies-medals-silver-certificate', NULL, 'Silver Certificate by Shivrudra Graphics', 'Silver Certificate service by Shivrudra Graphics.', 10, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'trophies-medals' AND products.slug = 'trophies-medals-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Golden Certificate', 'trophies-medals-golden-certificate', NULL, 'Golden Certificate by Shivrudra Graphics', 'Golden Certificate service by Shivrudra Graphics.', 11, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'trophies-medals' AND products.slug = 'trophies-medals-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Safety Signages', 'safety-signages', 'Compliant safety signage for every workplace.', 'Compliant safety signage for every workplace.', '/images/services/safety-signages.png', 17, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'safety-signages'
  AND products.slug IN ('vinyl-safety-signage', 'emergency-safety-signage', 'warning-safety-signage', 'fire-safety-signage', 'prohibition-signage', 'recycle-signage', 'safety-floor-signage', 'road-signage', 'no-parking-signage', 'emergency-exit-signage', 'wear-safety-helmet-signage', 'main-switch-signage');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Safety Signages', 'safety-signages-products', 'Safety Signages products', 'Compliant safety signage for every workplace.', 0, 1
FROM services WHERE slug = 'safety-signages'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Vinyl Safety Signage', 'safety-signages-vinyl-safety-signage', NULL, 'Vinyl Safety Signage by Shivrudra Graphics', 'Vinyl Safety Signage service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'safety-signages' AND products.slug = 'safety-signages-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Emergency Safety Signage', 'safety-signages-emergency-safety-signage', NULL, 'Emergency Safety Signage by Shivrudra Graphics', 'Emergency Safety Signage service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'safety-signages' AND products.slug = 'safety-signages-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Warning Safety Signage', 'safety-signages-warning-safety-signage', NULL, 'Warning Safety Signage by Shivrudra Graphics', 'Warning Safety Signage service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'safety-signages' AND products.slug = 'safety-signages-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Fire Safety Signage', 'safety-signages-fire-safety-signage', NULL, 'Fire Safety Signage by Shivrudra Graphics', 'Fire Safety Signage service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'safety-signages' AND products.slug = 'safety-signages-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Prohibition Signage', 'safety-signages-prohibition-signage', NULL, 'Prohibition Signage by Shivrudra Graphics', 'Prohibition Signage service by Shivrudra Graphics.', 4, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'safety-signages' AND products.slug = 'safety-signages-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Recycle Signage', 'safety-signages-recycle-signage', NULL, 'Recycle Signage by Shivrudra Graphics', 'Recycle Signage service by Shivrudra Graphics.', 5, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'safety-signages' AND products.slug = 'safety-signages-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Safety Floor Signage', 'safety-signages-safety-floor-signage', NULL, 'Safety Floor Signage by Shivrudra Graphics', 'Safety Floor Signage service by Shivrudra Graphics.', 6, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'safety-signages' AND products.slug = 'safety-signages-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Road Signage', 'safety-signages-road-signage', NULL, 'Road Signage by Shivrudra Graphics', 'Road Signage service by Shivrudra Graphics.', 7, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'safety-signages' AND products.slug = 'safety-signages-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'No Parking Signage', 'safety-signages-no-parking-signage', NULL, 'No Parking Signage by Shivrudra Graphics', 'No Parking Signage service by Shivrudra Graphics.', 8, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'safety-signages' AND products.slug = 'safety-signages-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Emergency Exit Signage', 'safety-signages-emergency-exit-signage', NULL, 'Emergency Exit Signage by Shivrudra Graphics', 'Emergency Exit Signage service by Shivrudra Graphics.', 9, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'safety-signages' AND products.slug = 'safety-signages-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Wear Safety Helmet Signage', 'safety-signages-wear-safety-helmet-signage', NULL, 'Wear Safety Helmet Signage by Shivrudra Graphics', 'Wear Safety Helmet Signage service by Shivrudra Graphics.', 10, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'safety-signages' AND products.slug = 'safety-signages-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Main Switch Signage', 'safety-signages-main-switch-signage', NULL, 'Main Switch Signage by Shivrudra Graphics', 'Main Switch Signage service by Shivrudra Graphics.', 11, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'safety-signages' AND products.slug = 'safety-signages-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Laser & CNC Cutting', 'laser-cnc-cutting', 'Precision laser and CNC cutting services.', 'Precision laser and CNC cutting services.', '/images/services/laser-and-cnc-cutting.png', 18, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

DELETE products FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'laser-cnc-cutting'
  AND products.slug IN ('acrylic-cutting', 'metal-cutting', 'wood-cutting', 'acp-cutting');

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Laser & CNC Cutting', 'laser-cnc-cutting-products', 'Laser & CNC Cutting products', 'Precision laser and CNC cutting services.', 0, 1
FROM services WHERE slug = 'laser-cnc-cutting'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Acrylic Cutting', 'laser-cnc-cutting-acrylic-cutting', NULL, 'Acrylic Cutting by Shivrudra Graphics', 'Acrylic Cutting service by Shivrudra Graphics.', 0, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'laser-cnc-cutting' AND products.slug = 'laser-cnc-cutting-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Metal Cutting', 'laser-cnc-cutting-metal-cutting', NULL, 'Metal Cutting by Shivrudra Graphics', 'Metal Cutting service by Shivrudra Graphics.', 1, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'laser-cnc-cutting' AND products.slug = 'laser-cnc-cutting-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'Wood Cutting', 'laser-cnc-cutting-wood-cutting', NULL, 'Wood Cutting by Shivrudra Graphics', 'Wood Cutting service by Shivrudra Graphics.', 2, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'laser-cnc-cutting' AND products.slug = 'laser-cnc-cutting-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_subproducts (product_id, name, slug, item_count, short_description, description, sort_order, is_active)
SELECT products.id, 'ACP Cutting', 'laser-cnc-cutting-acp-cutting', NULL, 'ACP Cutting by Shivrudra Graphics', 'ACP Cutting service by Shivrudra Graphics.', 3, 1
FROM products
INNER JOIN services ON services.id = products.service_id
WHERE services.slug = 'laser-cnc-cutting' AND products.slug = 'laser-cnc-cutting-products'
ON DUPLICATE KEY UPDATE product_id = VALUES(product_id), name = VALUES(name), item_count = VALUES(item_count), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_categories (name, slug, icon, sort_order, is_active)
VALUES ('Commercial Printing', 'commercial-printing', 'Printer', 0, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon = VALUES(icon), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_categories (name, slug, icon, sort_order, is_active)
VALUES ('Industrial Printing', 'industrial-printing', 'Factory', 1, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon = VALUES(icon), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_categories (name, slug, icon, sort_order, is_active)
VALUES ('Corporate Branding', 'corporate-branding', 'Building2', 2, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon = VALUES(icon), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_categories (name, slug, icon, sort_order, is_active)
VALUES ('LED Sign Boards', 'led-sign-boards', 'Lightbulb', 3, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon = VALUES(icon), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_categories (name, slug, icon, sort_order, is_active)
VALUES ('Signages', 'signages', 'Signpost', 4, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon = VALUES(icon), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_categories (name, slug, icon, sort_order, is_active)
VALUES ('Packaging Labels', 'packaging-labels', 'Package', 5, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon = VALUES(icon), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_categories (name, slug, icon, sort_order, is_active)
VALUES ('Corporate Gifts', 'corporate-gifts', 'Gift', 6, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon = VALUES(icon), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_categories (name, slug, icon, sort_order, is_active)
VALUES ('Vehicle Branding', 'vehicle-branding', 'Car', 7, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon = VALUES(icon), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_categories (name, slug, icon, sort_order, is_active)
VALUES ('Safety Signages', 'safety-signages', 'ShieldAlert', 8, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon = VALUES(icon), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_categories (name, slug, icon, sort_order, is_active)
VALUES ('Digital Printing', 'digital-printing', 'Monitor', 9, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon = VALUES(icon), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_categories (name, slug, icon, sort_order, is_active)
VALUES ('Offset Printing', 'offset-printing', 'Layers', 10, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon = VALUES(icon), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO product_categories (name, slug, icon, sort_order, is_active)
VALUES ('Custom Branding', 'custom-branding', 'Sparkles', 11, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon = VALUES(icon), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Agriculture', 'agriculture', '/images/industries/agriculture.png', '/images/industries/agriculture.png', 0, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Education', 'education', '/images/industries/education.png', '/images/industries/education.png', 1, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Wholesale Trade', 'wholesale-trade', '/images/industries/wholesale-trade.png', '/images/industries/wholesale-trade.png', 2, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Mining', 'mining', '/images/industries/mining.png', '/images/industries/mining.png', 3, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Home Builders', 'home-builders', '/images/industries/home-builders.png', '/images/industries/home-builders.png', 4, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Automotive', 'automotive', '/images/industries/automotive.png', '/images/industries/automotive.png', 5, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Retail', 'retail', '/images/industries/retail.png', '/images/industries/retail.png', 6, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Manufacturing', 'manufacturing', '/images/industries/manufacturing.png', '/images/industries/manufacturing.png', 7, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Construction', 'construction', '/images/industries/construction.png', '/images/industries/construction.png', 8, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Food & Beverage', 'food-and-beverage', '/images/industries/food-and-beverage.png', '/images/industries/food-and-beverage.png', 9, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Cosmetics', 'cosmetics', '/images/industries/cosmetics.png', '/images/industries/cosmetics.png', 10, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Health Care', 'health-care', '/images/industries/health-care.png', '/images/industries/health-care.png', 11, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Government', 'government', '/images/industries/government.png', '/images/industries/government.png', 12, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Event', 'event', '/images/industries/event.png', '/images/industries/event.png', 13, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Waste Management', 'waste-management', '/images/industries/waste-management.png', '/images/industries/waste-management.png', 14, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Bank', 'bank', '/images/industries/bank.png', '/images/industries/bank.png', 15, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Infrastructure', 'infrastructure', '/images/industries/infrastructure.png', '/images/industries/infrastructure.png', 16, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('IT', 'it', '/images/industries/it.png', '/images/industries/it.png', 17, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Hotel', 'hotel', '/images/industries/hotel.png', '/images/industries/hotel.png', 18, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Engineering', 'engineering', '/images/industries/engineering.png', '/images/industries/engineering.png', 19, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Pharmaceuticals', 'pharmaceuticals', '/images/industries/pharmaceuticals.png', '/images/industries/pharmaceuticals.png', 20, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Telecom', 'telecom', '/images/industries/telecom.png', '/images/industries/telecom.png', 21, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Shipping', 'shipping', '/images/industries/shipping.png', '/images/industries/shipping.png', 22, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Insurance', 'insurance', '/images/industries/insurance.png', '/images/industries/insurance.png', 23, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Tourism', 'tourism', '/images/industries/tourism.png', '/images/industries/tourism.png', 24, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Advertising & Media', 'advertising-and-media', '/images/industries/advertising-and-media.png', '/images/industries/advertising-and-media.png', 25, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Bakery', 'bakery', '/images/industries/bakery.png', '/images/industries/bakery.png', 26, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Land Developers', 'land-developers', '/images/industries/land-developers.png', '/images/industries/land-developers.png', 27, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, icon_url, image_url, sort_order, is_active)
VALUES ('Decorator', 'decorator', '/images/industries/decorator.png', '/images/industries/decorator.png', 28, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), icon_url = VALUES(icon_url), image_url = VALUES(image_url), sort_order = VALUES(sort_order), is_active = 1;

UPDATE clients SET is_active = 0;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Bank of India', '/images/clients/01-bank-of-india.png', 0, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Indian Oil', '/images/clients/02-indian-oil.png', 1, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('HP Petrol', '/images/clients/03-hp-petrol.png', 2, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Dexgreen', '/images/clients/04-dexgreen.png', 3, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Sunteck', '/images/clients/05-sunteck.png', 4, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Pirajees', '/images/clients/06-pirajees.png', 5, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Sahuwala', '/images/clients/07-sahuwala.png', 6, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Agrovan', '/images/clients/08-agrovan.png', 7, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Cherise', '/images/clients/09-cherise.png', 8, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Sarvadnya', '/images/clients/10-sarvadnya.png', 9, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Sadhu Vaswani Gurukul', '/images/clients/11-sadhu-vaswani-gurukul.png', 10, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Bharat School', '/images/clients/12-bharat-school.png', 11, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Angel School', '/images/clients/13-angel-school.png', 12, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Acute', '/images/clients/14-acute.png', 13, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Caramellas', '/images/clients/15-caramellas.png', 14, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Circuit House', '/images/clients/16-circuit-house.png', 15, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('GBRU', '/images/clients/17-gbru.png', 16, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Redragon', '/images/clients/18-redragon.png', 17, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Mahalaxmi Groups', '/images/clients/19-mahalaxmi-groups.png', 18, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Shreyash', '/images/clients/20-shreyash.png', 19, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Lexicon', '/images/clients/21-lexicon.png', 20, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('JSPM', '/images/clients/22-jspm.png', 21, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Edumont', '/images/clients/23-edumont.png', 22, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Autopeepal', '/images/clients/24-autopeepal.png', 23, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Gravotech', '/images/clients/25-gravotech.png', 24, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Bettinelli', '/images/clients/26-bettinelli.png', 25, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Mobiliti', '/images/clients/27-mobiliti.png', 26, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Dan', '/images/clients/28-dan.png', 27, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Rainbow', '/images/clients/29-rainbow.png', 28, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Apollo', '/images/clients/30-apollo.png', 29, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Shree Lifecare', '/images/clients/31-shree-lifecare.png', 30, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Shree Hospital', '/images/clients/32-shree-hospital.png', 31, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Sardar', '/images/clients/33-sardar.png', 32, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Shomeshwar Bhel', '/images/clients/34-shomeshwar-bhel.png', 33, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Gurudatta Wadapav', '/images/clients/35-gurudatta-wadapav.png', 34, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Serum', '/images/clients/36-serum.png', 35, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Axiss Health Club', '/images/clients/37-axiss-health-club.png', 36, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Inigma Air', '/images/clients/38-inigma-air.png', 37, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
VALUES ('Sharpedge', '/images/clients/39-sharpedge.png', 38, 1)
ON DUPLICATE KEY UPDATE logo_url = VALUES(logo_url), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO gallery_images (title, category, image_url, alt_text, sort_order, is_active)
SELECT 'Offset Printing Press', 'Printing', 'https://images.unsplash.com/photo-1599507593499-a3f7d7d97667?w=1000&q=80', 'Offset Printing Press', 0, 1
WHERE NOT EXISTS (SELECT 1 FROM gallery_images WHERE title = 'Offset Printing Press' LIMIT 1);

INSERT INTO gallery_images (title, category, image_url, alt_text, sort_order, is_active)
SELECT 'Digital Print Run', 'Printing', 'https://images.unsplash.com/photo-1601225612051-d44d9c2c1b3a?w=1000&q=80', 'Digital Print Run', 1, 1
WHERE NOT EXISTS (SELECT 1 FROM gallery_images WHERE title = 'Digital Print Run' LIMIT 1);

INSERT INTO gallery_images (title, category, image_url, alt_text, sort_order, is_active)
SELECT 'Pylon Signage', 'Signage', 'https://images.unsplash.com/photo-1567446537708-ac4aa75c9c28?w=1000&q=80', 'Pylon Signage', 2, 1
WHERE NOT EXISTS (SELECT 1 FROM gallery_images WHERE title = 'Pylon Signage' LIMIT 1);

INSERT INTO gallery_images (title, category, image_url, alt_text, sort_order, is_active)
SELECT 'Acrylic Letter Sign', 'Signage', 'https://images.unsplash.com/photo-1521791136064-7986c2920216?w=1000&q=80', 'Acrylic Letter Sign', 3, 1
WHERE NOT EXISTS (SELECT 1 FROM gallery_images WHERE title = 'Acrylic Letter Sign' LIMIT 1);

INSERT INTO gallery_images (title, category, image_url, alt_text, sort_order, is_active)
SELECT '3D LED Signage', 'LED Boards', 'https://images.unsplash.com/photo-1517524206127-48bbd363f3d7?w=1000&q=80', '3D LED Signage', 4, 1
WHERE NOT EXISTS (SELECT 1 FROM gallery_images WHERE title = '3D LED Signage' LIMIT 1);

INSERT INTO gallery_images (title, category, image_url, alt_text, sort_order, is_active)
SELECT 'Neon Storefront', 'LED Boards', 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=1000&q=80', 'Neon Storefront', 5, 1
WHERE NOT EXISTS (SELECT 1 FROM gallery_images WHERE title = 'Neon Storefront' LIMIT 1);

INSERT INTO gallery_images (title, category, image_url, alt_text, sort_order, is_active)
SELECT 'Branded Hampers', 'Corporate Gifts', 'https://images.unsplash.com/photo-1513885535751-8b9238bd345a?w=1000&q=80', 'Branded Hampers', 6, 1
WHERE NOT EXISTS (SELECT 1 FROM gallery_images WHERE title = 'Branded Hampers' LIMIT 1);

INSERT INTO gallery_images (title, category, image_url, alt_text, sort_order, is_active)
SELECT 'Premium Diaries', 'Corporate Gifts', 'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?w=1000&q=80', 'Premium Diaries', 7, 1
WHERE NOT EXISTS (SELECT 1 FROM gallery_images WHERE title = 'Premium Diaries' LIMIT 1);

INSERT INTO gallery_images (title, category, image_url, alt_text, sort_order, is_active)
SELECT 'Car Wrap', 'Vehicle Branding', 'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=1000&q=80', 'Car Wrap', 8, 1
WHERE NOT EXISTS (SELECT 1 FROM gallery_images WHERE title = 'Car Wrap' LIMIT 1);

INSERT INTO gallery_images (title, category, image_url, alt_text, sort_order, is_active)
SELECT 'Bus Branding', 'Vehicle Branding', 'https://images.unsplash.com/photo-1570125909232-eb263c188f7e?w=1000&q=80', 'Bus Branding', 9, 1
WHERE NOT EXISTS (SELECT 1 FROM gallery_images WHERE title = 'Bus Branding' LIMIT 1);

INSERT INTO gallery_images (title, category, image_url, alt_text, sort_order, is_active)
SELECT 'SS Name Plate', 'Industrial Labels', 'https://images.unsplash.com/photo-1581091215367-9b6c00b3039a?w=1000&q=80', 'SS Name Plate', 10, 1
WHERE NOT EXISTS (SELECT 1 FROM gallery_images WHERE title = 'SS Name Plate' LIMIT 1);

INSERT INTO gallery_images (title, category, image_url, alt_text, sort_order, is_active)
SELECT 'Control Panel Stickers', 'Industrial Labels', 'https://images.unsplash.com/photo-1565514020179-026b92b84bb6?w=1000&q=80', 'Control Panel Stickers', 11, 1
WHERE NOT EXISTS (SELECT 1 FROM gallery_images WHERE title = 'Control Panel Stickers' LIMIT 1);

INSERT INTO testimonials (client_name, client_role, message, rating, sort_order, is_active)
SELECT 'Rahul Jadhav', 'Retail Store Owner', 'Shivrudra Graphics delivered our store branding on time with excellent print quality. The team understood the requirement clearly and handled the installation neatly.', 5, 0, 1
WHERE NOT EXISTS (SELECT 1 FROM testimonials WHERE client_name = 'Rahul Jadhav' LIMIT 1);

INSERT INTO testimonials (client_name, client_role, message, rating, sort_order, is_active)
SELECT 'Priya Kulkarni', 'Marketing Manager', 'We regularly work with them for banners, labels and signage. Their finishing, color output and response time have been very dependable.', 5, 1, 1
WHERE NOT EXISTS (SELECT 1 FROM testimonials WHERE client_name = 'Priya Kulkarni' LIMIT 1);

INSERT INTO testimonials (client_name, client_role, message, rating, sort_order, is_active)
SELECT 'Amit Patil', 'Business Owner', 'From design to final print, the experience was smooth. The team suggested practical options and the final signage looked premium.', 5, 2, 1
WHERE NOT EXISTS (SELECT 1 FROM testimonials WHERE client_name = 'Amit Patil' LIMIT 1);

INSERT INTO site_settings (setting_key, setting_value)
VALUES ('contact', '{"phones":["+91 9075 28 5858","+91 9657 44 9996","+91 9067 17 5858"],"email":"info@shivrudragraphics.com","website":"www.shivrudragraphics.com","whatsapp":"919075285858","address":"Shop No. 10, Ground Floor, K.B. Plaza, Opp. Nivaan Meadows, Kesnand-Wagholi Road, Kesnand, Wagholi, Pune 412 207"}')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

INSERT INTO site_settings (setting_key, setting_value)
VALUES ('site_tagline', 'Commercial, Industrial, Corporate Printing and LED Sign Board Manufacturers')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

INSERT INTO site_settings (setting_key, setting_value)
VALUES ('process_steps', '["Lead","Inspection","Estimate","Design","Print","Production","Fabrication","Delivery","Installation","Feedback"]')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

INSERT INTO site_settings (setting_key, setting_value)
VALUES ('why_choose', '["Customer Satisfaction is Our First Priority","Transparent Communication","Premium Quality Products","Reliable & Professional Service","On-Time Delivery Commitment","High-Quality Printing Solutions","Advanced & Modern Technology","Skilled & Experienced Team","Bulk Order Capability","Creative & Unique Design Approach","Complete End-to-End Printing Solutions","Strong Brand Identity Support"]')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

INSERT INTO site_settings (setting_key, setting_value)
VALUES ('timeline', '[{"year":"2014","title":"Chintamani Arts","desc":"Founded at Kesnand & Kolwadi with a passion for creative graphics."},{"year":"2016","title":"Shivrudra Design","desc":"Rebranded to focus on design-led print solutions."},{"year":"2019","title":"Shivrudra Graphics","desc":"Expanded into industrial printing, signage and branding."},{"year":"2026","title":"Shivrudra Graphics Pvt Ltd","desc":"Incorporated as a private limited company serving pan-India brands."}]')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

INSERT INTO site_settings (setting_key, setting_value)
VALUES ('gallery_categories', '["All","Printing","Signage","LED Boards","Corporate Gifts","Vehicle Branding","Industrial Labels","Safety Boards","Packaging","Office Branding","Shop Branding"]')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

INSERT INTO site_settings (setting_key, setting_value)
VALUES ('logo_types', '[{"name":"Minimal Logos","colors":"from-white via-[#f7f7f7] to-[#ffe9e9]","mark":"M"},{"name":"Typography Logos","colors":"from-[#fff7d1] via-white to-[#ffe2df]","mark":"Aa"},{"name":"3D Logos","colors":"from-[#fff0c2] via-[#ffe6d1] to-[#ffd6d1]","mark":"3D"},{"name":"Lettermark Logos","colors":"from-white via-[#eef4ff] to-[#ffe8e2]","mark":"SG"},{"name":"Mascot Logos","colors":"from-[#fff3cf] via-white to-[#e9f7ee]","mark":"MC"},{"name":"Emblem Logos","colors":"from-[#f7f7f7] via-white to-[#ffecc4]","mark":"EM"},{"name":"Icon Logos","colors":"from-white via-[#fff5d9] to-[#ffdede]","mark":"IC"},{"name":"Calligraphy Logos","colors":"from-[#fff8df] via-white to-[#f7e7ff]","mark":"CA"}]')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

INSERT INTO site_settings (setting_key, setting_value)
VALUES ('directors', '[{"name":"Aadesh C. Nimbalkar","role":"Director"},{"name":"Akshay N. Kalbhor","role":"Director"}]')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);

INSERT INTO site_settings (setting_key, setting_value)
VALUES ('about_principles', '[{"title":"Vision","description":"To provide all types of graphics solutions to increase the growth of clients and build inclusive partnerships based on trust and mutual respect."},{"title":"Mission","description":"To become the most valued business partner for clients and help them grow their business."},{"title":"Values","description":"Integrity, Innovation, Teamwork, Environment-Friendly Approach, Respect for People."}]')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);



SET foreign_key_checks = 1;

