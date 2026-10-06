const API_URL = import.meta.env.VITE_API_URL || "http://localhost:5000";
const UPLOADS_BASE_URL = import.meta.env.VITE_UPLOADS_BASE_URL || "";
const ADMIN_UPLOADS_PATH = "/assets/admin-uploads/";

function sameSiteUploadsBaseUrl() {
  if (typeof window === "undefined") return "";

  const origin = window.location.origin;
  if (/^https?:\/\/localhost(?::\d+)?$/i.test(origin) || /^https?:\/\/127\.0\.0\.1(?::\d+)?$/i.test(origin)) {
    return "";
  }

  return origin;
}

function toAdminUploadPath(path: string) {
  const normalizedPath = path.replace(/\\/g, "/");

  if (normalizedPath.startsWith(ADMIN_UPLOADS_PATH)) return normalizedPath;

  const uploadsIndex = normalizedPath.indexOf("uploads/");
  if (uploadsIndex < 0 || normalizedPath.startsWith("/images/")) return normalizedPath;

  return `${ADMIN_UPLOADS_PATH}${normalizedPath.slice(uploadsIndex + "uploads/".length)}`;
}

function uploadedAssetUrl(publicUploadPath: string) {
  const uploadsBaseUrl = UPLOADS_BASE_URL || sameSiteUploadsBaseUrl() || API_URL;
  return `${uploadsBaseUrl.replace(/\/+$/g, "")}${publicUploadPath}`;
}

export function assetUrl(path?: string | null) {
  if (!path) return "";
  if (path.startsWith("data:")) return path;

  if (/^https?:\/\//i.test(path)) {
    try {
      const url = new URL(path);
      const uploadPath = toAdminUploadPath(url.pathname);
      if (uploadPath.startsWith(ADMIN_UPLOADS_PATH)) return uploadedAssetUrl(`${uploadPath}${url.search}`);
    } catch {
      return path;
    }

    return path;
  }

  const publicUploadPath = toAdminUploadPath(path);

  if (publicUploadPath.startsWith(ADMIN_UPLOADS_PATH)) {
    return uploadedAssetUrl(publicUploadPath);
  }

  if (publicUploadPath.startsWith("/assets/") || publicUploadPath.startsWith("/images/")) {
    return publicUploadPath;
  }

  const publicPath = publicUploadPath.startsWith("/") ? publicUploadPath : `/${publicUploadPath}`;

  return `${API_URL}${publicPath}`;
}

export async function publicApi<T>(path: string): Promise<T> {
  const response = await fetch(`${API_URL}/api/public${path}`);
  if (!response.ok) throw new Error("API request failed");
  return response.json();
}

export async function adminApi<T>(path: string, options: RequestInit = {}): Promise<T> {
  const token = localStorage.getItem("admin_token");
  const isFormData = options.body instanceof FormData;
  const controller = new AbortController();
  const timeout = window.setTimeout(() => controller.abort(), 20000);

  let response: Response;
  try {
    response = await fetch(`${API_URL}/api/admin${path}`, {
      ...options,
      signal: controller.signal,
      headers: {
        ...(isFormData ? {} : { "Content-Type": "application/json" }),
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
        ...options.headers,
      },
    });
  } catch (error) {
    if (error instanceof DOMException && error.name === "AbortError") {
      throw new Error("Request timed out. Please try again.");
    }

    throw error;
  } finally {
    window.clearTimeout(timeout);
  }

  if (!response.ok) {
    const data = await response.json().catch(() => ({}));
    throw new Error(data.message || "API request failed");
  }

  return response.json();
}

export async function loginAdmin(email: string, password: string) {
  const response = await fetch(`${API_URL}/api/auth/login`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ email, password }),
  });

  if (!response.ok) throw new Error("Invalid login");

  return response.json() as Promise<{
    token: string;
    admin: { id: number; name: string; email: string };
  }>;
}
