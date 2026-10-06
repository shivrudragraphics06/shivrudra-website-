import fs from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";

import { uploadDir } from "../uploadConfig.js";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const apiUploadsDir = path.resolve(__dirname, "../../uploads");
const imageExtensions = new Set([".jpg", ".jpeg", ".png", ".gif", ".webp", ".svg", ".avif"]);

async function copyImages(sourceDir) {
  const entries = await fs.readdir(sourceDir, { withFileTypes: true }).catch(() => []);
  let copied = 0;

  await fs.mkdir(uploadDir, { recursive: true });

  for (const entry of entries) {
    const sourcePath = path.join(sourceDir, entry.name);

    if (entry.isDirectory()) {
      copied += await copyImages(sourcePath);
      continue;
    }

    if (!entry.isFile() || !imageExtensions.has(path.extname(entry.name).toLowerCase())) continue;

    await fs.copyFile(sourcePath, path.join(uploadDir, entry.name));
    copied += 1;
  }

  return copied;
}

const copied = await copyImages(apiUploadsDir);
console.log(`Copied ${copied} image(s) from ${apiUploadsDir} to ${uploadDir}`);
