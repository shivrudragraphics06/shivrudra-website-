import fs from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootDir = path.resolve(__dirname, "..");

function safeFileName(value) {
  return value
    .trim()
    .toLowerCase()
    .replace(/&/g, "and")
    .replace(/[^a-z0-9.]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

function serviceFileName(fileName) {
  return fileName
    .toLowerCase()
    .replace(/&/g, "and")
    .replace(/[^a-z0-9.]+/g, "-")
    .replace(/^-+|-+(?=\.)/g, "");
}

function titleFromFile(value) {
  return value
    .replace(/\.[^.]+$/, "")
    .replace(/\s+\(\d+\)$/g, "")
    .replace(/[-_]+/g, " ")
    .replace(/\s+/g, " ")
    .trim()
    .replace(/\b\w/g, (letter) => letter.toUpperCase());
}

async function copyFileOverwrite(source, target) {
  try {
    const [sourceStat, targetStat] = await Promise.all([fs.stat(source), fs.stat(target)]);
    if (sourceStat.size === targetStat.size) return;
  } catch {
    // Source or destination may not exist yet; copy below will surface source errors.
  }

  try {
    await fs.chmod(target, 0o666);
  } catch {
    // The destination may not exist yet.
  }

  await fs.copyFile(source, target);
}

function parseClients(source, assetFiles) {
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
    if (fileName) clients.push({ name, fileName });
  }

  const usedFiles = new Set(clients.map((client) => client.fileName.toLowerCase()));
  for (const fileName of assetFiles) {
    if (!usedFiles.has(fileName.toLowerCase())) clients.push({ name: titleFromFile(fileName), fileName });
  }

  return clients;
}

async function copyServices() {
  const sourceDir = path.join(rootDir, "src/assets/services");
  const targetDir = path.join(rootDir, "public/images/services");
  await fs.mkdir(targetDir, { recursive: true });

  const files = await fs.readdir(sourceDir);
  for (const fileName of files) {
    await copyFileOverwrite(path.join(sourceDir, fileName), path.join(targetDir, serviceFileName(fileName)));
  }

  return files.length;
}

async function copyClients() {
  const sourceDir = path.join(rootDir, "src/assets/client logos");
  const targetDir = path.join(rootDir, "public/images/clients");
  await fs.mkdir(targetDir, { recursive: true });

  const files = await fs.readdir(sourceDir);
  const clientsSource = await fs.readFile(path.join(rootDir, "src/routes/clients.tsx"), "utf8");
  const clients = parseClients(clientsSource, files);

  for (const [index, client] of clients.entries()) {
    const extension = path.extname(client.fileName);
    const name = client.name;
    const targetName = `${String(index + 1).padStart(2, "0")}-${safeFileName(name)}${extension}`;
    await copyFileOverwrite(path.join(sourceDir, client.fileName), path.join(targetDir, targetName));
  }

  return clients.length;
}

async function copyIndustries() {
  const sourceDir = path.join(rootDir, "src/assets/industries we serve");
  const targetDir = path.join(rootDir, "public/images/industries");
  await fs.mkdir(targetDir, { recursive: true });

  const files = await fs.readdir(sourceDir);
  for (const fileName of files) {
    const extension = path.extname(fileName);
    const name = titleFromFile(fileName);
    await copyFileOverwrite(path.join(sourceDir, fileName), path.join(targetDir, `${safeFileName(name)}${extension}`));
  }

  return files.length;
}

async function copyAdminUploads() {
  const sourceDir = path.join(rootDir, "api/uploads");
  const targetDirs = [
    path.join(rootDir, "public/assets/admin-uploads"),
    path.join(rootDir, "shivrudra-public_html-upload/assets/admin-uploads"),
  ];

  let files = [];
  try {
    files = (await fs.readdir(sourceDir, { withFileTypes: true })).filter((entry) => entry.isFile());
  } catch {
    files = [];
  }

  for (const targetDir of targetDirs) {
    await fs.mkdir(targetDir, { recursive: true });
    for (const file of files) {
      if (file.name === ".gitkeep") continue;
      await copyFileOverwrite(path.join(sourceDir, file.name), path.join(targetDir, file.name));
    }
  }

  return files.filter((file) => file.name !== ".gitkeep").length;
}

const [services, clients, industries, adminUploads] = await Promise.all([
  copyServices(),
  copyClients(),
  copyIndustries(),
  copyAdminUploads(),
]);

console.log(
  `Copied ${services} service images, ${clients} client logos, ${industries} industry images, and ${adminUploads} admin uploads to public assets.`,
);
