import cors from "cors";
import dotenv from "dotenv";
import express from "express";
import path from "path";
import { fileURLToPath } from "url";

import { authRoutes } from "./routes/auth.routes.js";
import { crudRoutes } from "./routes/crud.routes.js";
import { publicRoutes } from "./routes/public.routes.js";
import { uploadDir, uploadPublicPath } from "./uploadConfig.js";

dotenv.config();

const app = express();
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const apiUploadsDir = path.join(__dirname, "../uploads");
const nestedUploadsDir = path.join(__dirname, "uploads");
const legacyUploadsDir = path.resolve(__dirname, "../../uploads");
const allowedOrigins = new Set(
  [
    process.env.CLIENT_URL,
    "https://shivrudragraphics.com",
    "https://www.shivrudragraphics.com",
    "http://localhost:5173",
    "http://127.0.0.1:5173",
  ].filter(Boolean),
);

app.use(
  cors({
    origin(origin, callback) {
      if (!origin || allowedOrigins.has(origin)) {
        callback(null, true);
        return;
      }

      callback(new Error(`CORS blocked origin: ${origin}`));
    },
  }),
);
app.use(express.json({ limit: "12mb" }));
app.use(uploadPublicPath, express.static(uploadDir));
app.use("/uploads", express.static(apiUploadsDir));
app.use("/uploads", express.static(nestedUploadsDir));
app.use("/uploads", express.static(legacyUploadsDir));

app.get("/", (_req, res) =>
  res.json({
    ok: true,
    name: "Shivrudra Graphics API",
    health: "/health",
    publicApi: "/api/public/homepage",
  }),
);
app.get("/health", (_req, res) => res.json({ ok: true }));
app.use("/api/auth", authRoutes);
app.use("/api/admin", crudRoutes);
app.use("/api/public", publicRoutes);

app.use((err, _req, res, _next) => {
  console.error(err);
  res.status(500).json({ message: err.message || "Server error" });
});

app.listen(process.env.PORT || 5000, () => {
  console.log(`API running on http://localhost:${process.env.PORT || 5000}`);
});
