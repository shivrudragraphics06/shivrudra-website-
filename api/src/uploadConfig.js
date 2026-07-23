import dotenv from "dotenv";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const apiRootDir = path.resolve(__dirname, "..");
const projectRootDir = path.resolve(__dirname, "../..");

for (const envPath of [
  path.resolve(process.cwd(), ".env"),
  path.join(apiRootDir, ".env"),
  path.join(projectRootDir, ".env"),
]) {
  dotenv.config({ path: envPath, quiet: true });
}

function hostnameFromUrl(value) {
  if (!value) return "";

  try {
    return new URL(value).hostname;
  } catch {
    return value.replace(/^https?:\/\//, "").split("/")[0];
  }
}

function hostingerDomainPublicHtmlDirs() {
  if (!process.env.HOME) return [];

  const domainsDir = path.join(process.env.HOME, "domains");
  if (!fs.existsSync(domainsDir)) return [];

  return fs
    .readdirSync(domainsDir, { withFileTypes: true })
    .filter((entry) => entry.isDirectory())
    .map((entry) => path.join(domainsDir, entry.name, "public_html"));
}

const uploadDomain = process.env.UPLOAD_DOMAIN || hostnameFromUrl(process.env.CLIENT_URL);
const configuredUploadRoot = process.env.UPLOAD_PUBLIC_ROOT || "";
const homePublicHtmlDir = process.env.HOME ? path.join(process.env.HOME, "public_html") : "";
const domainPublicHtmlDir =
  process.env.HOME && uploadDomain ? path.join(process.env.HOME, "domains", uploadDomain, "public_html") : "";
const domainPublicHtmlDirs = hostingerDomainPublicHtmlDirs();
const preferredDomainPublicHtmlDir =
  domainPublicHtmlDir && fs.existsSync(domainPublicHtmlDir)
    ? domainPublicHtmlDir
    : domainPublicHtmlDirs.find((dir) => fs.existsSync(path.join(dir, "assets", "admin-uploads"))) || "";
const publicRootDir = [
  configuredUploadRoot,
  domainPublicHtmlDir,
  ...domainPublicHtmlDirs.filter((dir) => fs.existsSync(path.join(dir, "assets", "admin-uploads"))),
  ...domainPublicHtmlDirs,
  homePublicHtmlDir,
  path.join(projectRootDir, "public_html"),
  path.join(projectRootDir, "public"),
].find((dir) => dir && fs.existsSync(dir)) || projectRootDir;
const defaultUploadDir = path.join(publicRootDir, "assets", "admin-uploads");
const uploadCandidateRoots = [
  configuredUploadRoot,
  domainPublicHtmlDir,
  preferredDomainPublicHtmlDir,
  ...domainPublicHtmlDirs,
  homePublicHtmlDir,
  path.join(projectRootDir, "public_html"),
  path.join(projectRootDir, "public"),
].filter(Boolean);

function resolveUploadDir(value) {
  if (!value) return defaultUploadDir;

  const resolvedDir = path.isAbsolute(value) ? path.resolve(value) : path.resolve(projectRootDir, value);
  if (!homePublicHtmlDir || !preferredDomainPublicHtmlDir) return resolvedDir;

  const resolvedHomePublicHtmlDir = path.resolve(homePublicHtmlDir);
  const relativeToHomePublicHtml = path.relative(resolvedHomePublicHtmlDir, resolvedDir);
  if (relativeToHomePublicHtml && !relativeToHomePublicHtml.startsWith("..") && !path.isAbsolute(relativeToHomePublicHtml)) {
    return path.resolve(preferredDomainPublicHtmlDir, relativeToHomePublicHtml);
  }

  return resolvedDir;
}

export const uploadDir = resolveUploadDir(process.env.UPLOAD_DIR);
export const uploadRootDir = publicRootDir;
export const uploadMirrorDirs = [
  uploadDir,
  ...uploadCandidateRoots.map((dir) => path.join(dir, "assets", "admin-uploads")),
].filter((dir, index, dirs) => dirs.indexOf(dir) === index);

export const uploadPublicPath = `/${(process.env.UPLOAD_PUBLIC_PATH || "/assets/admin-uploads")
  .replace(/\\/g, "/")
  .replace(/^\/+|\/+$/g, "")}`;

export function uploadedFileUrl(filename) {
  return `${uploadPublicPath}/${filename}`;
}
