import dotenv from "dotenv";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const apiRootDir = path.resolve(__dirname, "..");
const projectRootDir = path.resolve(__dirname, "../..");
const homePublicHtmlDir = process.env.HOME ? path.join(process.env.HOME, "public_html") : "";

for (const envPath of [
  path.resolve(process.cwd(), ".env"),
  path.join(apiRootDir, ".env"),
  path.join(projectRootDir, ".env"),
]) {
  dotenv.config({ path: envPath, quiet: true });
}

const publicRootDir = [
  path.join(projectRootDir, "public"),
  path.join(projectRootDir, "public_html"),
  homePublicHtmlDir,
].find((dir) => dir && fs.existsSync(dir)) || projectRootDir;
const defaultUploadDir = path.join(publicRootDir, "assets", "admin-uploads");

function resolveUploadDir(value) {
  if (!value) return defaultUploadDir;
  return path.isAbsolute(value) ? path.resolve(value) : path.resolve(projectRootDir, value);
}

export const uploadDir = resolveUploadDir(process.env.UPLOAD_DIR);

export const uploadPublicPath = `/${(process.env.UPLOAD_PUBLIC_PATH || "/assets/admin-uploads")
  .replace(/\\/g, "/")
  .replace(/^\/+|\/+$/g, "")}`;

export function uploadedFileUrl(filename) {
  return `${uploadPublicPath}/${filename}`;
}
