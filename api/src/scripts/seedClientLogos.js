import fs from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";

import { pool } from "../db.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootDir = path.resolve(__dirname, "../../..");
const clientsPagePath = path.join(rootDir, "src/routes/clients.tsx");
const clientAssetsDir = path.join(rootDir, "src/assets/client logos");
const publicImageDir = path.join(rootDir, "public/images/clients");

function toSafeFileName(value) {
  return value
    .trim()
    .toLowerCase()
    .replace(/&/g, "and")
    .replace(/[^a-z0-9.]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

function toTitle(value) {
  return value
    .replace(/\.[^.]+$/, "")
    .replace(/[-_]+/g, " ")
    .replace(/\s+/g, " ")
    .trim()
    .replace(/\b\w/g, (letter) => letter.toUpperCase());
}

function parseFrontendClients(source) {
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

    if (fileName) {
      clients.push({ name, fileName });
    }
  }

  return clients;
}

async function main() {
  await fs.mkdir(publicImageDir, { recursive: true });

  const source = await fs.readFile(clientsPagePath, "utf8");
  const clients = parseFrontendClients(source);
  const usedFiles = new Set(clients.map((client) => client.fileName.toLowerCase()));
  const assetFiles = await fs.readdir(clientAssetsDir);

  for (const fileName of assetFiles) {
    if (!usedFiles.has(fileName.toLowerCase())) {
      clients.push({ name: toTitle(fileName), fileName });
    }
  }

  for (const [index, client] of clients.entries()) {
    const sourcePath = path.join(clientAssetsDir, client.fileName);
    const extension = path.extname(client.fileName);
    const destinationName = `${String(index + 1).padStart(2, "0")}-${toSafeFileName(client.name)}${extension}`;
    const destinationPath = path.join(publicImageDir, destinationName);
    const logoUrl = `/images/clients/${destinationName}`;

    await fs.copyFile(sourcePath, destinationPath);
    await pool.execute(
      `INSERT INTO clients (name, logo_url, sort_order, is_active)
       VALUES (?, ?, ?, 1)
       ON DUPLICATE KEY UPDATE
         logo_url = VALUES(logo_url),
         sort_order = VALUES(sort_order),
         is_active = 1`,
      [client.name, logoUrl, index],
    );
  }

  await pool.end();
  console.log(`Imported ${clients.length} client logos into MySQL.`);
}

main().catch(async (error) => {
  console.error(error);
  await pool.end();
  process.exit(1);
});
