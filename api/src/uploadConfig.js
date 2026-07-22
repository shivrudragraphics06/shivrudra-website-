import dotenv from "dotenv";
import path from "path";
import { fileURLToPath } from "url";

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const uploadDir = process.env.UPLOAD_DIR
  ? path.resolve(process.env.UPLOAD_DIR)
  : path.resolve(__dirname, "../uploads");

export const uploadPublicPath = `/${(process.env.UPLOAD_PUBLIC_PATH || "/uploads")
  .replace(/\\/g, "/")
  .replace(/^\/+|\/+$/g, "")}`;

export function uploadedFileUrl(filename) {
  return `${uploadPublicPath}/${filename}`;
}
