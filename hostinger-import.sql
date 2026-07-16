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

CREATE TABLE IF NOT EXISTS product_images (
  id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  product_id BIGINT UNSIGNED NOT NULL,
  image_url VARCHAR(500) NOT NULL,
  alt_text VARCHAR(255),
  sort_order INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_product_images_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
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
VALUES ('Designing', 'designing', 'Creative design solutions from logos to packaging artwork.', 'Creative design solutions from logos to packaging artwork.', '/uploads/services/designing.jpg', 0, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Logo Design', 'logo-design', 'Logo Design by Shivrudra Graphics', 'Logo Design service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'designing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Social Media Creatives', 'social-media-creatives', 'Social Media Creatives by Shivrudra Graphics', 'Social Media Creatives service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'designing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Brochure Design', 'brochure-design', 'Brochure Design by Shivrudra Graphics', 'Brochure Design service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'designing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Certificate Design', 'certificate-design', 'Certificate Design by Shivrudra Graphics', 'Certificate Design service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'designing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Calligraphy & Vector Art', 'calligraphy-and-vector-art', 'Calligraphy & Vector Art by Shivrudra Graphics', 'Calligraphy & Vector Art service by Shivrudra Graphics.', 4, 1
FROM services WHERE slug = 'designing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Flyer Design', 'flyer-design', 'Flyer Design by Shivrudra Graphics', 'Flyer Design service by Shivrudra Graphics.', 5, 1
FROM services WHERE slug = 'designing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Invitation Card Design', 'invitation-card-design', 'Invitation Card Design by Shivrudra Graphics', 'Invitation Card Design service by Shivrudra Graphics.', 6, 1
FROM services WHERE slug = 'designing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Car Wrap Design', 'car-wrap-design', 'Car Wrap Design by Shivrudra Graphics', 'Car Wrap Design service by Shivrudra Graphics.', 7, 1
FROM services WHERE slug = 'designing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Letterhead Design', 'letterhead-design', 'Letterhead Design by Shivrudra Graphics', 'Letterhead Design service by Shivrudra Graphics.', 8, 1
FROM services WHERE slug = 'designing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Banner Design', 'banner-design', 'Banner Design by Shivrudra Graphics', 'Banner Design service by Shivrudra Graphics.', 9, 1
FROM services WHERE slug = 'designing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Business Card Design', 'business-card-design', 'Business Card Design by Shivrudra Graphics', 'Business Card Design service by Shivrudra Graphics.', 10, 1
FROM services WHERE slug = 'designing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Poster Design', 'poster-design', 'Poster Design by Shivrudra Graphics', 'Poster Design service by Shivrudra Graphics.', 11, 1
FROM services WHERE slug = 'designing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'LED Signage Design', 'led-signage-design', 'LED Signage Design by Shivrudra Graphics', 'LED Signage Design service by Shivrudra Graphics.', 12, 1
FROM services WHERE slug = 'designing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Product Packaging Labels & Stickers Design', 'product-packaging-labels-and-stickers-design', 'Product Packaging Labels & Stickers Design by Shivrudra Graphics', 'Product Packaging Labels & Stickers Design service by Shivrudra Graphics.', 13, 1
FROM services WHERE slug = 'designing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Flex Printing', 'flex-printing', 'Vibrant large-format flex prints for outdoor & indoor branding.', 'Vibrant large-format flex prints for outdoor & indoor branding.', '/uploads/services/flex-printing.png', 1, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Normal Flex Printing', 'normal-flex-printing', 'Normal Flex Printing by Shivrudra Graphics', 'Normal Flex Printing service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'flex-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Black Back Flex Printing', 'black-back-flex-printing', 'Black Back Flex Printing by Shivrudra Graphics', 'Black Back Flex Printing service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'flex-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Star Flex Printing', 'star-flex-printing', 'Star Flex Printing by Shivrudra Graphics', 'Star Flex Printing service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'flex-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Backlit Flex Printing', 'backlit-flex-printing', 'Backlit Flex Printing by Shivrudra Graphics', 'Backlit Flex Printing service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'flex-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'One Way Vision Printing', 'one-way-vision-printing', 'One Way Vision Printing by Shivrudra Graphics', 'One Way Vision Printing service by Shivrudra Graphics.', 4, 1
FROM services WHERE slug = 'flex-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Roll Up Standee', 'roll-up-standee', 'Roll Up Standee by Shivrudra Graphics', 'Roll Up Standee service by Shivrudra Graphics.', 5, 1
FROM services WHERE slug = 'flex-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Canopy Standee', 'canopy-standee', 'Canopy Standee by Shivrudra Graphics', 'Canopy Standee service by Shivrudra Graphics.', 6, 1
FROM services WHERE slug = 'flex-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Graffiti Wall Printing', 'graffiti-wall-printing', 'Graffiti Wall Printing by Shivrudra Graphics', 'Graffiti Wall Printing service by Shivrudra Graphics.', 7, 1
FROM services WHERE slug = 'flex-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Vinyl Printing', 'vinyl-printing', 'Premium vinyl prints for vehicles, walls, floors and more.', 'Premium vinyl prints for vehicles, walls, floors and more.', '/uploads/services/vinyl-printing.png', 2, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Vinyl Printing', 'vinyl-printing', 'Vinyl Printing by Shivrudra Graphics', 'Vinyl Printing service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'vinyl-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Frosted Filming', 'frosted-filming', 'Frosted Filming by Shivrudra Graphics', 'Frosted Filming service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'vinyl-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Retro Vinyl Printing', 'retro-vinyl-printing', 'Retro Vinyl Printing by Shivrudra Graphics', 'Retro Vinyl Printing service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'vinyl-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, '3M Vinyl Printing', '3m-vinyl-printing', '3M Vinyl Printing by Shivrudra Graphics', '3M Vinyl Printing service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'vinyl-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Transparent Vinyl Printing', 'transparent-vinyl-printing', 'Transparent Vinyl Printing by Shivrudra Graphics', 'Transparent Vinyl Printing service by Shivrudra Graphics.', 4, 1
FROM services WHERE slug = 'vinyl-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Night Glow Vinyl', 'night-glow-vinyl', 'Night Glow Vinyl by Shivrudra Graphics', 'Night Glow Vinyl service by Shivrudra Graphics.', 5, 1
FROM services WHERE slug = 'vinyl-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Vinyl Foam Board', 'vinyl-foam-board', 'Vinyl Foam Board by Shivrudra Graphics', 'Vinyl Foam Board service by Shivrudra Graphics.', 6, 1
FROM services WHERE slug = 'vinyl-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Floor Graphics Printing', 'floor-graphics-printing', 'Floor Graphics Printing by Shivrudra Graphics', 'Floor Graphics Printing service by Shivrudra Graphics.', 7, 1
FROM services WHERE slug = 'vinyl-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Table Top Printing', 'table-top-printing', 'Table Top Printing by Shivrudra Graphics', 'Table Top Printing service by Shivrudra Graphics.', 8, 1
FROM services WHERE slug = 'vinyl-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Cutout Standees', 'cutout-standees', 'Cutout Standees by Shivrudra Graphics', 'Cutout Standees service by Shivrudra Graphics.', 9, 1
FROM services WHERE slug = 'vinyl-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Sun Board Standee', 'sun-board-standee', 'Sun Board Standee by Shivrudra Graphics', 'Sun Board Standee service by Shivrudra Graphics.', 10, 1
FROM services WHERE slug = 'vinyl-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Car Branding', 'car-branding', 'Car Branding by Shivrudra Graphics', 'Car Branding service by Shivrudra Graphics.', 11, 1
FROM services WHERE slug = 'vinyl-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Wallpaper Printing', 'wallpaper-printing', 'Wallpaper Printing by Shivrudra Graphics', 'Wallpaper Printing service by Shivrudra Graphics.', 12, 1
FROM services WHERE slug = 'vinyl-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Bus Branding', 'bus-branding', 'Bus Branding by Shivrudra Graphics', 'Bus Branding service by Shivrudra Graphics.', 13, 1
FROM services WHERE slug = 'vinyl-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('UV Printing', 'uv-printing', 'High-resolution UV printing on rigid and flexible substrates.', 'High-resolution UV printing on rigid and flexible substrates.', '/uploads/services/uv-printing.png', 3, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'UV Vinyl Printing', 'uv-vinyl-printing', 'UV Vinyl Printing by Shivrudra Graphics', 'UV Vinyl Printing service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'uv-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'UV Fabric Printing', 'uv-fabric-printing', 'UV Fabric Printing by Shivrudra Graphics', 'UV Fabric Printing service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'uv-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'UV Canvas Printing', 'uv-canvas-printing', 'UV Canvas Printing by Shivrudra Graphics', 'UV Canvas Printing service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'uv-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'UV Translite Printing', 'uv-translite-printing', 'UV Translite Printing by Shivrudra Graphics', 'UV Translite Printing service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'uv-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'UV Acrylic Printing', 'uv-acrylic-printing', 'UV Acrylic Printing by Shivrudra Graphics', 'UV Acrylic Printing service by Shivrudra Graphics.', 4, 1
FROM services WHERE slug = 'uv-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'UV Foam Printing', 'uv-foam-printing', 'UV Foam Printing by Shivrudra Graphics', 'UV Foam Printing service by Shivrudra Graphics.', 5, 1
FROM services WHERE slug = 'uv-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'UV ACP Printing', 'uv-acp-printing', 'UV ACP Printing by Shivrudra Graphics', 'UV ACP Printing service by Shivrudra Graphics.', 6, 1
FROM services WHERE slug = 'uv-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Screen Printing', 'screen-printing', 'Industrial screen printing on plastic, metal, glass and textiles.', 'Industrial screen printing on plastic, metal, glass and textiles.', '/uploads/services/screen-printing.png', 4, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Polycarbonate Sticker Printing', 'polycarbonate-sticker-printing', 'Polycarbonate Sticker Printing by Shivrudra Graphics', 'Polycarbonate Sticker Printing service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Polycarbonate Labels Printing', 'polycarbonate-labels-printing', 'Polycarbonate Labels Printing by Shivrudra Graphics', 'Polycarbonate Labels Printing service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Sun Pack Printing', 'sun-pack-printing', 'Sun Pack Printing by Shivrudra Graphics', 'Sun Pack Printing service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Bottle Printing', 'bottle-printing', 'Bottle Printing by Shivrudra Graphics', 'Bottle Printing service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Plastic Crate Printing', 'plastic-crate-printing', 'Plastic Crate Printing by Shivrudra Graphics', 'Plastic Crate Printing service by Shivrudra Graphics.', 4, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Vinyl Tag Printing', 'vinyl-tag-printing', 'Vinyl Tag Printing by Shivrudra Graphics', 'Vinyl Tag Printing service by Shivrudra Graphics.', 5, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Polyester Printing', 'polyester-printing', 'Polyester Printing by Shivrudra Graphics', 'Polyester Printing service by Shivrudra Graphics.', 6, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'School Bag Printing', 'school-bag-printing', 'School Bag Printing by Shivrudra Graphics', 'School Bag Printing service by Shivrudra Graphics.', 7, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Umbrella Printing', 'umbrella-printing', 'Umbrella Printing by Shivrudra Graphics', 'Umbrella Printing service by Shivrudra Graphics.', 8, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Membrane Keypads', 'membrane-keypads', 'Membrane Keypads by Shivrudra Graphics', 'Membrane Keypads service by Shivrudra Graphics.', 9, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Control Panel Sticker', 'control-panel-sticker', 'Control Panel Sticker by Shivrudra Graphics', 'Control Panel Sticker service by Shivrudra Graphics.', 10, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'PP Box Printing', 'pp-box-printing', 'PP Box Printing by Shivrudra Graphics', 'PP Box Printing service by Shivrudra Graphics.', 11, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Corrugate Box Printing', 'corrugate-box-printing', 'Corrugate Box Printing by Shivrudra Graphics', 'Corrugate Box Printing service by Shivrudra Graphics.', 12, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Metal QR Code Printing', 'metal-qr-code-printing', 'Metal QR Code Printing by Shivrudra Graphics', 'Metal QR Code Printing service by Shivrudra Graphics.', 13, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Textile Printing', 'textile-printing', 'Textile Printing by Shivrudra Graphics', 'Textile Printing service by Shivrudra Graphics.', 14, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Glass Printing', 'glass-printing', 'Glass Printing by Shivrudra Graphics', 'Glass Printing service by Shivrudra Graphics.', 15, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Wooden Printing', 'wooden-printing', 'Wooden Printing by Shivrudra Graphics', 'Wooden Printing service by Shivrudra Graphics.', 16, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'SS Plate Printing', 'ss-plate-printing', 'SS Plate Printing by Shivrudra Graphics', 'SS Plate Printing service by Shivrudra Graphics.', 17, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'MS Plate Printing', 'ms-plate-printing', 'MS Plate Printing by Shivrudra Graphics', 'MS Plate Printing service by Shivrudra Graphics.', 18, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Aluminum Plate Printing', 'aluminum-plate-printing', 'Aluminum Plate Printing by Shivrudra Graphics', 'Aluminum Plate Printing service by Shivrudra Graphics.', 19, 1
FROM services WHERE slug = 'screen-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Digital Printing', 'digital-printing', 'Crisp digital prints for labels, tags, cards and packaging.', 'Crisp digital prints for labels, tags, cards and packaging.', '/uploads/services/digital-printing.png', 5, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Texture Paper Printing', 'texture-paper-printing', 'Texture Paper Printing by Shivrudra Graphics', 'Texture Paper Printing service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Sticker Paper Printing', 'sticker-paper-printing', 'Sticker Paper Printing by Shivrudra Graphics', 'Sticker Paper Printing service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'NT Paper Printing', 'nt-paper-printing', 'NT Paper Printing by Shivrudra Graphics', 'NT Paper Printing service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Transparent Paper Printing', 'transparent-paper-printing', 'Transparent Paper Printing by Shivrudra Graphics', 'Transparent Paper Printing service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Product Label Printing', 'product-label-printing', 'Product Label Printing by Shivrudra Graphics', 'Product Label Printing service by Shivrudra Graphics.', 4, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Tag Printing', 'tag-printing', 'Tag Printing by Shivrudra Graphics', 'Tag Printing service by Shivrudra Graphics.', 5, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Coupon Printing', 'coupon-printing', 'Coupon Printing by Shivrudra Graphics', 'Coupon Printing service by Shivrudra Graphics.', 6, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Wristband Printing', 'wristband-printing', 'Wristband Printing by Shivrudra Graphics', 'Wristband Printing service by Shivrudra Graphics.', 7, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Certificate Printing', 'certificate-printing', 'Certificate Printing by Shivrudra Graphics', 'Certificate Printing service by Shivrudra Graphics.', 8, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Tent Cards Printing', 'tent-cards-printing', 'Tent Cards Printing by Shivrudra Graphics', 'Tent Cards Printing service by Shivrudra Graphics.', 9, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Invitation Cards Printing', 'invitation-cards-printing', 'Invitation Cards Printing by Shivrudra Graphics', 'Invitation Cards Printing service by Shivrudra Graphics.', 10, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Menu Card Printing', 'menu-card-printing', 'Menu Card Printing by Shivrudra Graphics', 'Menu Card Printing service by Shivrudra Graphics.', 11, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Danglers Printing', 'danglers-printing', 'Danglers Printing by Shivrudra Graphics', 'Danglers Printing service by Shivrudra Graphics.', 12, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Barcode Sticker Printing', 'barcode-sticker-printing', 'Barcode Sticker Printing by Shivrudra Graphics', 'Barcode Sticker Printing service by Shivrudra Graphics.', 13, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Safety Signage Poster Printing', 'safety-signage-poster-printing', 'Safety Signage Poster Printing by Shivrudra Graphics', 'Safety Signage Poster Printing service by Shivrudra Graphics.', 14, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Door Hangers Printing', 'door-hangers-printing', 'Door Hangers Printing by Shivrudra Graphics', 'Door Hangers Printing service by Shivrudra Graphics.', 15, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Vehicle Parking Sticker Printing', 'vehicle-parking-sticker-printing', 'Vehicle Parking Sticker Printing by Shivrudra Graphics', 'Vehicle Parking Sticker Printing service by Shivrudra Graphics.', 16, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Cable Tag Printing', 'cable-tag-printing', 'Cable Tag Printing by Shivrudra Graphics', 'Cable Tag Printing service by Shivrudra Graphics.', 17, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Roll Labels Printing', 'roll-labels-printing', 'Roll Labels Printing by Shivrudra Graphics', 'Roll Labels Printing service by Shivrudra Graphics.', 18, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Packaging Sticker Printing', 'packaging-sticker-printing', 'Packaging Sticker Printing by Shivrudra Graphics', 'Packaging Sticker Printing service by Shivrudra Graphics.', 19, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Custom Car Stickers', 'custom-car-stickers', 'Custom Car Stickers by Shivrudra Graphics', 'Custom Car Stickers service by Shivrudra Graphics.', 20, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'PVC ID Card Printing', 'pvc-id-card-printing', 'PVC ID Card Printing by Shivrudra Graphics', 'PVC ID Card Printing service by Shivrudra Graphics.', 21, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Lanyard Printing', 'lanyard-printing', 'Lanyard Printing by Shivrudra Graphics', 'Lanyard Printing service by Shivrudra Graphics.', 22, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Industrial Packaging Label', 'industrial-packaging-label', 'Industrial Packaging Label by Shivrudra Graphics', 'Industrial Packaging Label service by Shivrudra Graphics.', 23, 1
FROM services WHERE slug = 'digital-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Offset Printing', 'offset-printing', 'Bulk offset printing for stationery, books and packaging.', 'Bulk offset printing for stationery, books and packaging.', '/uploads/services/offset-printing.png', 6, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Pawati Book Printing', 'pawati-book-printing', 'Pawati Book Printing by Shivrudra Graphics', 'Pawati Book Printing service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Gift Voucher Printing', 'gift-voucher-printing', 'Gift Voucher Printing by Shivrudra Graphics', 'Gift Voucher Printing service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Packaging Sleeves', 'packaging-sleeves', 'Packaging Sleeves by Shivrudra Graphics', 'Packaging Sleeves service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Wrapping Paper', 'wrapping-paper', 'Wrapping Paper by Shivrudra Graphics', 'Wrapping Paper service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Seal Stickers', 'seal-stickers', 'Seal Stickers by Shivrudra Graphics', 'Seal Stickers service by Shivrudra Graphics.', 4, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Ticket Printing', 'ticket-printing', 'Ticket Printing by Shivrudra Graphics', 'Ticket Printing service by Shivrudra Graphics.', 5, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Bookmark Printing', 'bookmark-printing', 'Bookmark Printing by Shivrudra Graphics', 'Bookmark Printing service by Shivrudra Graphics.', 6, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Rack Card Printing', 'rack-card-printing', 'Rack Card Printing by Shivrudra Graphics', 'Rack Card Printing service by Shivrudra Graphics.', 7, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Header Card Printing', 'header-card-printing', 'Header Card Printing by Shivrudra Graphics', 'Header Card Printing service by Shivrudra Graphics.', 8, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Shelf Wobblers Printing', 'shelf-wobblers-printing', 'Shelf Wobblers Printing by Shivrudra Graphics', 'Shelf Wobblers Printing service by Shivrudra Graphics.', 9, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Bottle Neck Tags Printing', 'bottle-neck-tags-printing', 'Bottle Neck Tags Printing by Shivrudra Graphics', 'Bottle Neck Tags Printing service by Shivrudra Graphics.', 10, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Swing Tags Printing', 'swing-tags-printing', 'Swing Tags Printing by Shivrudra Graphics', 'Swing Tags Printing service by Shivrudra Graphics.', 11, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Tree Tag Printing', 'tree-tag-printing', 'Tree Tag Printing by Shivrudra Graphics', 'Tree Tag Printing service by Shivrudra Graphics.', 12, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Cloth Tag Printing', 'cloth-tag-printing', 'Cloth Tag Printing by Shivrudra Graphics', 'Cloth Tag Printing service by Shivrudra Graphics.', 13, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Business Card Printing', 'business-card-printing', 'Business Card Printing by Shivrudra Graphics', 'Business Card Printing service by Shivrudra Graphics.', 14, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Envelope Printing', 'envelope-printing', 'Envelope Printing by Shivrudra Graphics', 'Envelope Printing service by Shivrudra Graphics.', 15, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Brochure Printing', 'brochure-printing', 'Brochure Printing by Shivrudra Graphics', 'Brochure Printing service by Shivrudra Graphics.', 16, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Leaflet Printing', 'leaflet-printing', 'Leaflet Printing by Shivrudra Graphics', 'Leaflet Printing service by Shivrudra Graphics.', 17, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Letterhead Printing', 'letterhead-printing', 'Letterhead Printing by Shivrudra Graphics', 'Letterhead Printing service by Shivrudra Graphics.', 18, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Register Printing', 'register-printing', 'Register Printing by Shivrudra Graphics', 'Register Printing service by Shivrudra Graphics.', 19, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Bank Form Printing', 'bank-form-printing', 'Bank Form Printing by Shivrudra Graphics', 'Bank Form Printing service by Shivrudra Graphics.', 20, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Prospectus Printing', 'prospectus-printing', 'Prospectus Printing by Shivrudra Graphics', 'Prospectus Printing service by Shivrudra Graphics.', 21, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Stationery Printing', 'stationery-printing', 'Stationery Printing by Shivrudra Graphics', 'Stationery Printing service by Shivrudra Graphics.', 22, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Pharmacy Literature Printing', 'pharmacy-literature-printing', 'Pharmacy Literature Printing by Shivrudra Graphics', 'Pharmacy Literature Printing service by Shivrudra Graphics.', 23, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Scratch Card Printing', 'scratch-card-printing', 'Scratch Card Printing by Shivrudra Graphics', 'Scratch Card Printing service by Shivrudra Graphics.', 24, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Box Printing', 'box-printing', 'Box Printing by Shivrudra Graphics', 'Box Printing service by Shivrudra Graphics.', 25, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Synthetic Tags', 'synthetic-tags', 'Synthetic Tags by Shivrudra Graphics', 'Synthetic Tags service by Shivrudra Graphics.', 26, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Report Card Printing', 'report-card-printing', 'Report Card Printing by Shivrudra Graphics', 'Report Card Printing service by Shivrudra Graphics.', 27, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'File Printing', 'file-printing', 'File Printing by Shivrudra Graphics', 'File Printing service by Shivrudra Graphics.', 28, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Hospital File Printing', 'hospital-file-printing', 'Hospital File Printing by Shivrudra Graphics', 'Hospital File Printing service by Shivrudra Graphics.', 29, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Pocket Folder Printing', 'pocket-folder-printing', 'Pocket Folder Printing by Shivrudra Graphics', 'Pocket Folder Printing service by Shivrudra Graphics.', 30, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Prescription Pad Printing', 'prescription-pad-printing', 'Prescription Pad Printing by Shivrudra Graphics', 'Prescription Pad Printing service by Shivrudra Graphics.', 31, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Medical Pouch Printing', 'medical-pouch-printing', 'Medical Pouch Printing by Shivrudra Graphics', 'Medical Pouch Printing service by Shivrudra Graphics.', 32, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Calendar Printing', 'calendar-printing', 'Calendar Printing by Shivrudra Graphics', 'Calendar Printing service by Shivrudra Graphics.', 33, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Diary Printing', 'diary-printing', 'Diary Printing by Shivrudra Graphics', 'Diary Printing service by Shivrudra Graphics.', 34, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Bill Book Printing', 'bill-book-printing', 'Bill Book Printing by Shivrudra Graphics', 'Bill Book Printing service by Shivrudra Graphics.', 35, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Receipt Book Printing', 'receipt-book-printing', 'Receipt Book Printing by Shivrudra Graphics', 'Receipt Book Printing service by Shivrudra Graphics.', 36, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Notebook Printing', 'notebook-printing', 'Notebook Printing by Shivrudra Graphics', 'Notebook Printing service by Shivrudra Graphics.', 37, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Catalogue Printing', 'catalogue-printing', 'Catalogue Printing by Shivrudra Graphics', 'Catalogue Printing service by Shivrudra Graphics.', 38, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Notepads Printing', 'notepads-printing', 'Notepads Printing by Shivrudra Graphics', 'Notepads Printing service by Shivrudra Graphics.', 39, 1
FROM services WHERE slug = 'offset-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Photo Frame', 'photo-frame', 'Custom photo frames in premium finishes.', 'Custom photo frames in premium finishes.', '/uploads/services/photo-frame.jpg', 7, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Wooden Frames', 'wooden-frames', 'Wooden Frames by Shivrudra Graphics', 'Wooden Frames service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'photo-frame'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Acrylic Frames', 'acrylic-frames', 'Acrylic Frames by Shivrudra Graphics', 'Acrylic Frames service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'photo-frame'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Collage Frames', 'collage-frames', 'Collage Frames by Shivrudra Graphics', 'Collage Frames service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'photo-frame'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Award Frames', 'award-frames', 'Award Frames by Shivrudra Graphics', 'Award Frames service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'photo-frame'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Badge & Dome Printing', 'badge-dome-printing', 'Glossy dome stickers and brand badges.', 'Glossy dome stickers and brand badges.', '/uploads/services/badge-and-dome-printing.png', 8, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Dome Stickers', 'dome-stickers', 'Dome Stickers by Shivrudra Graphics', 'Dome Stickers service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'badge-dome-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Metal Badges', 'metal-badges', 'Metal Badges by Shivrudra Graphics', 'Metal Badges service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'badge-dome-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'ID Badges', 'id-badges', 'ID Badges by Shivrudra Graphics', 'ID Badges service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'badge-dome-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Logo Domes', 'logo-domes', 'Logo Domes by Shivrudra Graphics', 'Logo Domes service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'badge-dome-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Bag Printing', 'bag-printing', 'Custom printed bags for promotion and retail.', 'Custom printed bags for promotion and retail.', '/uploads/services/bag-printing.png', 9, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Cloth Bags', 'cloth-bags', 'Cloth Bags by Shivrudra Graphics', 'Cloth Bags service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'bag-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Non Woven Bags', 'non-woven-bags', 'Non Woven Bags by Shivrudra Graphics', 'Non Woven Bags service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'bag-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Jute Bags', 'jute-bags', 'Jute Bags by Shivrudra Graphics', 'Jute Bags service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'bag-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Paper Bags', 'paper-bags', 'Paper Bags by Shivrudra Graphics', 'Paper Bags service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'bag-printing'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Stamp', 'stamp', 'Custom stamps for office, billing, numbering and date marking needs.', 'Custom stamps for office, billing, numbering and date marking needs.', '/uploads/services/rubber-stamps.png', 10, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Stamp', 'stamp', 'Stamp by Shivrudra Graphics', 'Stamp service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'stamp'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Pre Ink Stamp', 'pre-ink-stamp', 'Pre Ink Stamp by Shivrudra Graphics', 'Pre Ink Stamp service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'stamp'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Sun Stamp', 'sun-stamp', 'Sun Stamp by Shivrudra Graphics', 'Sun Stamp service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'stamp'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Colop Stamp', 'colop-stamp', 'Colop Stamp by Shivrudra Graphics', 'Colop Stamp service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'stamp'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Trodat Stamp', 'trodat-stamp', 'Trodat Stamp by Shivrudra Graphics', 'Trodat Stamp service by Shivrudra Graphics.', 4, 1
FROM services WHERE slug = 'stamp'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Numbering Stamp', 'numbering-stamp', 'Numbering Stamp by Shivrudra Graphics', 'Numbering Stamp service by Shivrudra Graphics.', 5, 1
FROM services WHERE slug = 'stamp'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Colop Numbering Stamp', 'colop-numbering-stamp', 'Colop Numbering Stamp by Shivrudra Graphics', 'Colop Numbering Stamp service by Shivrudra Graphics.', 6, 1
FROM services WHERE slug = 'stamp'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Dolphin Numbering Stamp', 'dolphin-numbering-stamp', 'Dolphin Numbering Stamp by Shivrudra Graphics', 'Dolphin Numbering Stamp service by Shivrudra Graphics.', 7, 1
FROM services WHERE slug = 'stamp'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Dater Stamp', 'dater-stamp', 'Dater Stamp by Shivrudra Graphics', 'Dater Stamp service by Shivrudra Graphics.', 8, 1
FROM services WHERE slug = 'stamp'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Colop Dater Stamp', 'colop-dater-stamp', 'Colop Dater Stamp by Shivrudra Graphics', 'Colop Dater Stamp service by Shivrudra Graphics.', 9, 1
FROM services WHERE slug = 'stamp'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Dolphin Dater Stamp', 'dolphin-dater-stamp', 'Dolphin Dater Stamp by Shivrudra Graphics', 'Dolphin Dater Stamp service by Shivrudra Graphics.', 10, 1
FROM services WHERE slug = 'stamp'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Engraving & Marking', 'engraving-marking', 'Laser engraving and industrial marking solutions.', 'Laser engraving and industrial marking solutions.', '/uploads/services/engraving-and-marking.png', 11, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Laser Engraving', 'laser-engraving', 'Laser Engraving by Shivrudra Graphics', 'Laser Engraving service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'engraving-marking'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Metal Marking', 'metal-marking', 'Metal Marking by Shivrudra Graphics', 'Metal Marking service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'engraving-marking'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Acrylic Engraving', 'acrylic-engraving', 'Acrylic Engraving by Shivrudra Graphics', 'Acrylic Engraving service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'engraving-marking'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Wood Engraving', 'wood-engraving', 'Wood Engraving by Shivrudra Graphics', 'Wood Engraving service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'engraving-marking'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Keychains', 'keychain', 'Custom keychains for promotions and gifting.', 'Custom keychains for promotions and gifting.', '/uploads/services/keychains.png', 12, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Metal Keychains', 'metal-keychains', 'Metal Keychains by Shivrudra Graphics', 'Metal Keychains service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'keychain'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Acrylic Keychains', 'acrylic-keychains', 'Acrylic Keychains by Shivrudra Graphics', 'Acrylic Keychains service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'keychain'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Wooden Keychains', 'wooden-keychains', 'Wooden Keychains by Shivrudra Graphics', 'Wooden Keychains service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'keychain'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'LED Keychains', 'led-keychains', 'LED Keychains by Shivrudra Graphics', 'LED Keychains service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'keychain'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Corporate Gifts', 'corporate-gift', 'Premium curated gifts for clients & employees.', 'Premium curated gifts for clients & employees.', '/uploads/services/corporate-gift.jpg', 13, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Diaries', 'diaries', 'Diaries by Shivrudra Graphics', 'Diaries service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'corporate-gift'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Pens', 'pens', 'Pens by Shivrudra Graphics', 'Pens service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'corporate-gift'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Bottles', 'bottles', 'Bottles by Shivrudra Graphics', 'Bottles service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'corporate-gift'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Hampers', 'hampers', 'Hampers by Shivrudra Graphics', 'Hampers service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'corporate-gift'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Industrial Name Plates', 'industrial-name-plates', 'Durable name plates for industrial use.', 'Durable name plates for industrial use.', '/uploads/services/industrial-name-plates.png', 14, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'SS Name Plates', 'ss-name-plates', 'SS Name Plates by Shivrudra Graphics', 'SS Name Plates service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'industrial-name-plates'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'MS Name Plates', 'ms-name-plates', 'MS Name Plates by Shivrudra Graphics', 'MS Name Plates service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'industrial-name-plates'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Aluminum Plates', 'aluminum-plates', 'Aluminum Plates by Shivrudra Graphics', 'Aluminum Plates service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'industrial-name-plates'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Anodized Plates', 'anodized-plates', 'Anodized Plates by Shivrudra Graphics', 'Anodized Plates service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'industrial-name-plates'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Premium Signages', 'signage', 'Premium wayfinding, name plate, award and acrylic signage solutions.', 'Premium wayfinding, name plate, award and acrylic signage solutions.', '/uploads/services/signage.png', 15, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Way Finding Signage', 'way-finding-signage', 'Way Finding Signage by Shivrudra Graphics', 'Way Finding Signage service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'signage'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Free Hand Signage', 'free-hand-signage', 'Free Hand Signage by Shivrudra Graphics', 'Free Hand Signage service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'signage'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Directory Signage', 'directory-signage', 'Directory Signage by Shivrudra Graphics', 'Directory Signage service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'signage'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Table Top Signage', 'table-top-signage', 'Table Top Signage by Shivrudra Graphics', 'Table Top Signage service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'signage'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Home Name Plates', 'home-name-plates', 'Home Name Plates by Shivrudra Graphics', 'Home Name Plates service by Shivrudra Graphics.', 4, 1
FROM services WHERE slug = 'signage'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Plaque', 'plaque', 'Plaque by Shivrudra Graphics', 'Plaque service by Shivrudra Graphics.', 5, 1
FROM services WHERE slug = 'signage'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Awards', 'awards', 'Awards by Shivrudra Graphics', 'Awards service by Shivrudra Graphics.', 6, 1
FROM services WHERE slug = 'signage'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Hangers', 'hangers', 'Hangers by Shivrudra Graphics', 'Hangers service by Shivrudra Graphics.', 7, 1
FROM services WHERE slug = 'signage'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, '3D Sign', '3d-sign', '3D Sign by Shivrudra Graphics', '3D Sign service by Shivrudra Graphics.', 8, 1
FROM services WHERE slug = 'signage'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, '2D Sign', '2d-sign', '2D Sign by Shivrudra Graphics', '2D Sign service by Shivrudra Graphics.', 9, 1
FROM services WHERE slug = 'signage'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Acrylic Sign', 'acrylic-sign', 'Acrylic Sign by Shivrudra Graphics', 'Acrylic Sign service by Shivrudra Graphics.', 10, 1
FROM services WHERE slug = 'signage'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Trophies & Medals', 'trophies-medals', 'Custom trophies, medals and certificates for events and recognition.', 'Custom trophies, medals and certificates for events and recognition.', '/uploads/services/trophies-and-medals.png', 16, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Acrylic Trophies', 'acrylic-trophies', 'Acrylic Trophies by Shivrudra Graphics', 'Acrylic Trophies service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'trophies-medals'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Wooden Trophies', 'wooden-trophies', 'Wooden Trophies by Shivrudra Graphics', 'Wooden Trophies service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'trophies-medals'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Plastic Frame Trophies', 'plastic-frame-trophies', 'Plastic Frame Trophies by Shivrudra Graphics', 'Plastic Frame Trophies service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'trophies-medals'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Metal Frame Trophies', 'metal-frame-trophies', 'Metal Frame Trophies by Shivrudra Graphics', 'Metal Frame Trophies service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'trophies-medals'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Foil Trophies', 'foil-trophies', 'Foil Trophies by Shivrudra Graphics', 'Foil Trophies service by Shivrudra Graphics.', 4, 1
FROM services WHERE slug = 'trophies-medals'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Metal Trophies', 'metal-trophies', 'Metal Trophies by Shivrudra Graphics', 'Metal Trophies service by Shivrudra Graphics.', 5, 1
FROM services WHERE slug = 'trophies-medals'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'ABS Trophies', 'abs-trophies', 'ABS Trophies by Shivrudra Graphics', 'ABS Trophies service by Shivrudra Graphics.', 6, 1
FROM services WHERE slug = 'trophies-medals'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Flag Trophies', 'flag-trophies', 'Flag Trophies by Shivrudra Graphics', 'Flag Trophies service by Shivrudra Graphics.', 7, 1
FROM services WHERE slug = 'trophies-medals'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Cups Trophies', 'cups-trophies', 'Cups Trophies by Shivrudra Graphics', 'Cups Trophies service by Shivrudra Graphics.', 8, 1
FROM services WHERE slug = 'trophies-medals'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Medals', 'medals', 'Medals by Shivrudra Graphics', 'Medals service by Shivrudra Graphics.', 9, 1
FROM services WHERE slug = 'trophies-medals'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Silver Certificate', 'silver-certificate', 'Silver Certificate by Shivrudra Graphics', 'Silver Certificate service by Shivrudra Graphics.', 10, 1
FROM services WHERE slug = 'trophies-medals'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Golden Certificate', 'golden-certificate', 'Golden Certificate by Shivrudra Graphics', 'Golden Certificate service by Shivrudra Graphics.', 11, 1
FROM services WHERE slug = 'trophies-medals'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Safety Signages', 'safety-signages', 'Compliant safety signage for every workplace.', 'Compliant safety signage for every workplace.', '/uploads/services/safety-signages.png', 17, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Vinyl Safety Signage', 'vinyl-safety-signage', 'Vinyl Safety Signage by Shivrudra Graphics', 'Vinyl Safety Signage service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'safety-signages'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Emergency Safety Signage', 'emergency-safety-signage', 'Emergency Safety Signage by Shivrudra Graphics', 'Emergency Safety Signage service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'safety-signages'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Warning Safety Signage', 'warning-safety-signage', 'Warning Safety Signage by Shivrudra Graphics', 'Warning Safety Signage service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'safety-signages'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Fire Safety Signage', 'fire-safety-signage', 'Fire Safety Signage by Shivrudra Graphics', 'Fire Safety Signage service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'safety-signages'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Prohibition Signage', 'prohibition-signage', 'Prohibition Signage by Shivrudra Graphics', 'Prohibition Signage service by Shivrudra Graphics.', 4, 1
FROM services WHERE slug = 'safety-signages'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Recycle Signage', 'recycle-signage', 'Recycle Signage by Shivrudra Graphics', 'Recycle Signage service by Shivrudra Graphics.', 5, 1
FROM services WHERE slug = 'safety-signages'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Safety Floor Signage', 'safety-floor-signage', 'Safety Floor Signage by Shivrudra Graphics', 'Safety Floor Signage service by Shivrudra Graphics.', 6, 1
FROM services WHERE slug = 'safety-signages'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Road Signage', 'road-signage', 'Road Signage by Shivrudra Graphics', 'Road Signage service by Shivrudra Graphics.', 7, 1
FROM services WHERE slug = 'safety-signages'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'No Parking Signage', 'no-parking-signage', 'No Parking Signage by Shivrudra Graphics', 'No Parking Signage service by Shivrudra Graphics.', 8, 1
FROM services WHERE slug = 'safety-signages'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Emergency Exit Signage', 'emergency-exit-signage', 'Emergency Exit Signage by Shivrudra Graphics', 'Emergency Exit Signage service by Shivrudra Graphics.', 9, 1
FROM services WHERE slug = 'safety-signages'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Wear Safety Helmet Signage', 'wear-safety-helmet-signage', 'Wear Safety Helmet Signage by Shivrudra Graphics', 'Wear Safety Helmet Signage service by Shivrudra Graphics.', 10, 1
FROM services WHERE slug = 'safety-signages'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Main Switch Signage', 'main-switch-signage', 'Main Switch Signage by Shivrudra Graphics', 'Main Switch Signage service by Shivrudra Graphics.', 11, 1
FROM services WHERE slug = 'safety-signages'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO services (name, slug, short_description, description, image_url, sort_order, is_active)
VALUES ('Laser & CNC Cutting', 'laser-cnc-cutting', 'Precision laser and CNC cutting services.', 'Precision laser and CNC cutting services.', '/uploads/services/laser-and-cnc-cutting.png', 18, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), image_url = COALESCE(NULLIF(services.image_url, ''), VALUES(image_url)), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Acrylic Cutting', 'acrylic-cutting', 'Acrylic Cutting by Shivrudra Graphics', 'Acrylic Cutting service by Shivrudra Graphics.', 0, 1
FROM services WHERE slug = 'laser-cnc-cutting'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Metal Cutting', 'metal-cutting', 'Metal Cutting by Shivrudra Graphics', 'Metal Cutting service by Shivrudra Graphics.', 1, 1
FROM services WHERE slug = 'laser-cnc-cutting'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'Wood Cutting', 'wood-cutting', 'Wood Cutting by Shivrudra Graphics', 'Wood Cutting service by Shivrudra Graphics.', 2, 1
FROM services WHERE slug = 'laser-cnc-cutting'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO products (service_id, name, slug, short_description, description, sort_order, is_active)
SELECT id, 'ACP Cutting', 'acp-cutting', 'ACP Cutting by Shivrudra Graphics', 'ACP Cutting service by Shivrudra Graphics.', 3, 1
FROM services WHERE slug = 'laser-cnc-cutting'
ON DUPLICATE KEY UPDATE service_id = VALUES(service_id), name = VALUES(name), short_description = VALUES(short_description), description = VALUES(description), sort_order = VALUES(sort_order), is_active = 1;

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

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Agriculture', 'agriculture', 0, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Education', 'education', 1, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Wholesale Trade', 'wholesale-trade', 2, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Mining', 'mining', 3, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Home Builders', 'home-builders', 4, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Automotive', 'automotive', 5, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Retail', 'retail', 6, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Manufacturing', 'manufacturing', 7, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Construction', 'construction', 8, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Food & Beverage', 'food-and-beverage', 9, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Cosmetics', 'cosmetics', 10, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Health Care', 'health-care', 11, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Government', 'government', 12, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Event', 'event', 13, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Waste Management', 'waste-management', 14, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Bank', 'bank', 15, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Infrastructure', 'infrastructure', 16, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('IT', 'it', 17, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Hotel', 'hotel', 18, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Engineering', 'engineering', 19, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Pharmaceuticals', 'pharmaceuticals', 20, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Telecom', 'telecom', 21, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Shipping', 'shipping', 22, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Insurance', 'insurance', 23, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Tourism', 'tourism', 24, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Advertising & Media', 'advertising-and-media', 25, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Bakery', 'bakery', 26, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Land Developers', 'land-developers', 27, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO industries (name, slug, sort_order, is_active)
VALUES ('Decorator', 'decorator', 28, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), sort_order = VALUES(sort_order), is_active = 1;

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Bank of India', '/uploads/clients/01-bank-of-india.png', 0, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Bank of India' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Indian Oil', '/uploads/clients/02-indian-oil.png', 1, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Indian Oil' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'HP Petrol', '/uploads/clients/03-hp-petrol.png', 2, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'HP Petrol' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Dexgreen', '/uploads/clients/04-dexgreen.png', 3, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Dexgreen' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Sunteck', '/uploads/clients/05-sunteck.png', 4, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Sunteck' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Pirajees', '/uploads/clients/06-pirajees.png', 5, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Pirajees' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Sahuwala', '/uploads/clients/07-sahuwala.png', 6, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Sahuwala' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Agrovan', '/uploads/clients/08-agrovan.png', 7, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Agrovan' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Cherise', '/uploads/clients/09-cherise.png', 8, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Cherise' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Sarvadnya', '/uploads/clients/10-sarvadnya.png', 9, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Sarvadnya' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Sadhu Vaswani Gurukul', '/uploads/clients/11-sadhu-vaswani-gurukul.png', 10, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Sadhu Vaswani Gurukul' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Bharat School', '/uploads/clients/12-bharat-school.png', 11, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Bharat School' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Angel School', '/uploads/clients/13-angel-school.png', 12, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Angel School' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Acute', '/uploads/clients/14-acute.png', 13, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Acute' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Caramellas', '/uploads/clients/15-caramellas.png', 14, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Caramellas' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Circuit House', '/uploads/clients/16-circuit-house.png', 15, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Circuit House' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'GBRU', '/uploads/clients/17-gbru.png', 16, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'GBRU' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Redragon', '/uploads/clients/18-redragon.png', 17, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Redragon' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Mahalaxmi Groups', '/uploads/clients/19-mahalaxmi-groups.png', 18, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Mahalaxmi Groups' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Shreyash', '/uploads/clients/20-shreyash.png', 19, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Shreyash' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Lexicon', '/uploads/clients/21-lexicon.png', 20, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Lexicon' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'JSPM', '/uploads/clients/22-jspm.png', 21, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'JSPM' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Edumont', '/uploads/clients/23-edumont.png', 22, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Edumont' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Autopeepal', '/uploads/clients/24-autopeepal.png', 23, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Autopeepal' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Gravotech', '/uploads/clients/25-gravotech.png', 24, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Gravotech' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Bettinelli', '/uploads/clients/26-bettinelli.png', 25, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Bettinelli' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Mobiliti', '/uploads/clients/27-mobiliti.png', 26, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Mobiliti' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Dan', '/uploads/clients/28-dan.png', 27, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Dan' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Rainbow', '/uploads/clients/29-rainbow.png', 28, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Rainbow' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Apollo', '/uploads/clients/30-apollo.png', 29, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Apollo' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Shree Lifecare', '/uploads/clients/31-shree-lifecare.png', 30, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Shree Lifecare' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Shree Hospital', '/uploads/clients/32-shree-hospital.png', 31, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Shree Hospital' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Sardar', '/uploads/clients/33-sardar.png', 32, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Sardar' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Shomeshwar Bhel', '/uploads/clients/34-shomeshwar-bhel.png', 33, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Shomeshwar Bhel' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Gurudatta Wadapav', '/uploads/clients/35-gurudatta-wadapav.png', 34, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Gurudatta Wadapav' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Serum', '/uploads/clients/36-serum.png', 35, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Serum' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Axiss Health Club', '/uploads/clients/37-axiss-health-club.png', 36, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Axiss Health Club' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Inigma Air', '/uploads/clients/38-inigma-air.png', 37, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Inigma Air' LIMIT 1);

INSERT INTO clients (name, logo_url, sort_order, is_active)
SELECT 'Sharpedge', '/uploads/clients/39-sharpedge.png', 38, 1
WHERE NOT EXISTS (SELECT 1 FROM clients WHERE name = 'Sharpedge' LIMIT 1);

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

