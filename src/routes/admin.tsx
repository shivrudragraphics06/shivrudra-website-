import {
  BarChart3,
  BriefcaseBusiness,
  Building2,
  FolderTree,
  Image,
  Inbox,
  LayoutDashboard,
  LogOut,
  MessageSquareQuote,
  Newspaper,
  PackagePlus,
  Pencil,
  Plus,
  Save,
  Search,
  Settings,
  Star,
  Trash2,
  Upload,
  Users,
  X,
} from "lucide-react";
import { type ComponentType, type FormEvent, type SVGProps, useEffect, useMemo, useState } from "react";

import logoUrl from "@/assets/logo.png";
import { adminApi, assetUrl, loginAdmin } from "@/lib/api";

export const ADMIN_BASE_PATH = "/shivrudra_graphics-myadmin";

type AdminPath = {
  pathname: string;
  navigate: (path: string) => void;
};

type AdminRecord = Record<string, string | number | boolean | null | undefined> & { id?: number };
type FieldType = "text" | "textarea" | "number" | "checkbox" | "image" | "datetime" | "select";
type Field = {
  name: string;
  label: string;
  type?: FieldType;
  required?: boolean;
  placeholder?: string;
  valueType?: "number" | "string";
  options?: { label: string; value: string | number }[];
  optionsKey?: "categories" | "services" | "products" | "sub-products";
};
type ResourceConfig = {
  key: string;
  label: string;
  singular: string;
  icon: ComponentType<SVGProps<SVGSVGElement>>;
  fields: Field[];
  columns: string[];
};

const resources: ResourceConfig[] = [
  {
    key: "services",
    label: "Services",
    singular: "Service",
    icon: BriefcaseBusiness,
    columns: ["name", "slug", "short_description", "is_active"],
    fields: [
      { name: "name", label: "Name", required: true },
      { name: "slug", label: "Slug", placeholder: "auto-created if blank" },
      { name: "short_description", label: "Short Description", type: "textarea" },
      { name: "description", label: "Description", type: "textarea" },
      { name: "image_url", label: "Image", type: "image" },
      { name: "sort_order", label: "Sort Order", type: "number" },
      { name: "is_active", label: "Active", type: "checkbox" },
    ],
  },
  {
    key: "categories",
    label: "Categories",
    singular: "Category",
    icon: FolderTree,
    columns: ["name", "slug", "icon", "is_active"],
    fields: [
      { name: "name", label: "Name", required: true },
      { name: "slug", label: "Slug", placeholder: "auto-created if blank" },
      { name: "description", label: "Description", type: "textarea" },
      { name: "image_url", label: "Image", type: "image" },
      { name: "icon", label: "Icon" },
      { name: "sort_order", label: "Sort Order", type: "number" },
      { name: "is_active", label: "Active", type: "checkbox" },
    ],
  },
  {
    key: "products",
    label: "Products",
    singular: "Product",
    icon: Star,
    columns: ["name", "service_name", "category_name", "item_count", "main_image_url", "is_active"],
    fields: [
      { name: "category_id", label: "Category", type: "select", optionsKey: "categories" },
      { name: "service_id", label: "Main Service", type: "select", optionsKey: "services" },
      { name: "name", label: "Name", required: true },
      { name: "slug", label: "Slug", placeholder: "auto-created if blank" },
      { name: "short_description", label: "Short Description", type: "textarea" },
      { name: "description", label: "Detailed Page Content", type: "textarea" },
      { name: "main_image_url", label: "Main Image", type: "image" },
      { name: "item_count", label: "Item Count", type: "number" },
      { name: "meta_title", label: "Meta Title" },
      { name: "meta_description", label: "Meta Description", type: "textarea" },
      { name: "sort_order", label: "Sort Order", type: "number" },
      { name: "is_featured", label: "Featured", type: "checkbox" },
      { name: "is_active", label: "Active", type: "checkbox" },
    ],
  },
  {
    key: "sub-products",
    label: "Sub Products",
    singular: "Sub Product",
    icon: PackagePlus,
    columns: ["name", "product_name", "service_name", "item_count", "image_url", "is_active"],
    fields: [
      { name: "product_id", label: "Parent Product", type: "select", optionsKey: "products", required: true },
      { name: "name", label: "Name", required: true },
      { name: "slug", label: "Slug", placeholder: "auto-created if blank" },
      { name: "short_description", label: "Short Description", type: "textarea" },
      { name: "description", label: "Detailed Content", type: "textarea" },
      { name: "image_url", label: "Image", type: "image" },
      { name: "item_count", label: "Item Count", type: "number" },
      { name: "sort_order", label: "Sort Order", type: "number" },
      { name: "is_active", label: "Active", type: "checkbox" },
    ],
  },
  {
    key: "product-gallery",
    label: "Product Gallery",
    singular: "Product Gallery Item",
    icon: Image,
    columns: ["title", "gallery_type", "service_name", "product_name", "sub_product_name", "image_url", "is_active"],
    fields: [
      { name: "service_id", label: "Service", type: "select", optionsKey: "services", required: true },
      {
        name: "gallery_type",
        label: "Type",
        type: "select",
        valueType: "string",
        required: true,
        options: [
          { label: "Product", value: "product" },
          { label: "Sub Product", value: "sub-product" },
        ],
      },
      { name: "product_id", label: "Product", type: "select", optionsKey: "products" },
      { name: "sub_product_id", label: "Sub Product", type: "select", optionsKey: "sub-products" },
      { name: "title", label: "Name" },
      { name: "image_url", label: "Product Image", type: "image", required: true },
      { name: "alt_text", label: "Alt Text" },
      { name: "sort_order", label: "Sort Order", type: "number" },
      { name: "is_active", label: "Active", type: "checkbox" },
    ],
  },
  {
    key: "gallery",
    label: "Gallery",
    singular: "Gallery Image",
    icon: Image,
    columns: ["title", "category", "image_url", "is_active"],
    fields: [
      { name: "title", label: "Title" },
      { name: "category", label: "Category" },
      { name: "image_url", label: "Image", type: "image", required: true },
      { name: "alt_text", label: "Alt Text" },
      { name: "sort_order", label: "Sort Order", type: "number" },
      { name: "is_active", label: "Active", type: "checkbox" },
    ],
  },
  {
    key: "blogs",
    label: "Blogs",
    singular: "Blog",
    icon: Newspaper,
    columns: ["title", "slug", "author", "is_published"],
    fields: [
      { name: "title", label: "Title", required: true },
      { name: "slug", label: "Slug", placeholder: "auto-created if blank" },
      { name: "excerpt", label: "Excerpt", type: "textarea" },
      { name: "content", label: "Content", type: "textarea", required: true },
      { name: "featured_image_url", label: "Featured Image", type: "image" },
      { name: "author", label: "Author" },
      { name: "meta_title", label: "Meta Title" },
      { name: "meta_description", label: "Meta Description", type: "textarea" },
      { name: "published_at", label: "Published At", type: "datetime" },
      { name: "is_published", label: "Published", type: "checkbox" },
    ],
  },
  {
    key: "industries",
    label: "Industries",
    singular: "Industry",
    icon: Building2,
    columns: ["name", "slug", "description", "is_active"],
    fields: [
      { name: "name", label: "Name", required: true },
      { name: "slug", label: "Slug", placeholder: "auto-created if blank" },
      { name: "description", label: "Description", type: "textarea" },
      { name: "icon_url", label: "Icon Image", type: "image" },
      { name: "image_url", label: "Main Image", type: "image" },
      { name: "sort_order", label: "Sort Order", type: "number" },
      { name: "is_active", label: "Active", type: "checkbox" },
    ],
  },
  {
    key: "clients",
    label: "Clients",
    singular: "Client",
    icon: Users,
    columns: ["name", "logo_url", "website_url", "is_active"],
    fields: [
      { name: "name", label: "Name", required: true },
      { name: "logo_url", label: "Logo", type: "image" },
      { name: "website_url", label: "Website URL" },
      { name: "sort_order", label: "Sort Order", type: "number" },
      { name: "is_active", label: "Active", type: "checkbox" },
    ],
  },
  {
    key: "testimonials",
    label: "Testimonials",
    singular: "Testimonial",
    icon: MessageSquareQuote,
    columns: ["client_name", "company", "rating", "is_active"],
    fields: [
      { name: "client_name", label: "Client Name", required: true },
      { name: "client_role", label: "Client Role" },
      { name: "company", label: "Company" },
      { name: "message", label: "Message", type: "textarea", required: true },
      { name: "rating", label: "Rating", type: "number" },
      { name: "image_url", label: "Image", type: "image" },
      { name: "sort_order", label: "Sort Order", type: "number" },
      { name: "is_active", label: "Active", type: "checkbox" },
    ],
  },
  {
    key: "inquiries",
    label: "Inquiries",
    singular: "Inquiry",
    icon: Inbox,
    columns: ["name", "mobile", "service", "status"],
    fields: [
      { name: "name", label: "Name", required: true },
      { name: "mobile", label: "Mobile", required: true },
      { name: "email", label: "Email" },
      { name: "business", label: "Business" },
      { name: "service", label: "Service" },
      { name: "message", label: "Message", type: "textarea" },
      { name: "source", label: "Source" },
      { name: "status", label: "Status", placeholder: "new, contacted, closed" },
    ],
  },
  {
    key: "settings",
    label: "Settings",
    singular: "Setting",
    icon: Settings,
    columns: ["setting_key", "setting_value"],
    fields: [
      { name: "setting_key", label: "Key", required: true },
      { name: "setting_value", label: "Value", type: "textarea" },
    ],
  },
];

const navItems = [
  { path: `${ADMIN_BASE_PATH}/dashboard`, label: "Dashboard", icon: LayoutDashboard },
  ...resources.map((resource) => ({
    path: `${ADMIN_BASE_PATH}/${resource.key}`,
    label: resource.label,
    icon: resource.icon,
  })),
];

function getToken() {
  return localStorage.getItem("admin_token");
}

function formatLabel(value: string) {
  return value.replace(/_/g, " ").replace(/\b\w/g, (letter) => letter.toUpperCase());
}

function toInputValue(value: AdminRecord[string]) {
  if (value === null || value === undefined) return "";
  return String(value);
}

function optionLabel(option: AdminRecord) {
  const name = String(option.name ?? option.title ?? option.id);
  const serviceName = option.service_name ? String(option.service_name) : "";
  const categoryName = option.category_name ? String(option.category_name) : "";
  const context = [serviceName, categoryName].filter(Boolean).join(" / ");
  return context ? `${name} (${context})` : name;
}

function AdminLoginPage({ navigate }: AdminPath) {
  const [email, setEmail] = useState(import.meta.env.ADMIN_EMAIL || "");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    setError("");
    setLoading(true);

    try {
      const data = await loginAdmin(email, password);
      localStorage.setItem("admin_token", data.token);
      localStorage.setItem("admin_name", data.admin.name);
      navigate(`${ADMIN_BASE_PATH}/dashboard`);
    } catch {
      setError("Invalid email or password");
    } finally {
      setLoading(false);
    }
  }

  return (
    <main className="min-h-screen bg-[#f4f5f7] px-4 py-10 text-brand-dark">
      <section className="mx-auto grid min-h-[calc(100vh-5rem)] w-full max-w-5xl items-center gap-8 lg:grid-cols-[1.1fr_0.9fr]">
        <div className="hidden lg:block">
          <img src={logoUrl} alt="Shivrudra Graphics" className="h-20 w-auto" />
          <h1 className="mt-8 max-w-xl font-display text-5xl font-black leading-tight text-brand-dark">
            Shivrudra Graphics Admin
          </h1>
          <p className="mt-5 max-w-lg text-base leading-7 text-muted-foreground">
            Manage website services, product categories, gallery, blogs, clients, industries, and testimonials.
          </p>
        </div>

        <form onSubmit={handleSubmit} className="rounded-lg border bg-white p-6 shadow-soft">
          <img src={logoUrl} alt="Shivrudra Graphics" className="mb-8 h-14 w-auto lg:hidden" />
          <h2 className="font-display text-2xl font-black">Admin Login</h2>
          <div className="mt-6 grid gap-4">
            <label className="grid gap-2 text-sm font-semibold">
              Email
              <input
                className="h-11 rounded-md border px-3 outline-none focus:ring-2 focus:ring-brand-red"
                value={email}
                onChange={(event) => setEmail(event.target.value)}
                type="email"
                required
              />
            </label>
            <label className="grid gap-2 text-sm font-semibold">
              Password
              <input
                className="h-11 rounded-md border px-3 outline-none focus:ring-2 focus:ring-brand-red"
                value={password}
                onChange={(event) => setPassword(event.target.value)}
                type="password"
                required
              />
            </label>
          </div>
          {error ? <p className="mt-4 rounded-md bg-red-50 px-3 py-2 text-sm font-semibold text-red-700">{error}</p> : null}
          <button
            className="mt-6 inline-flex h-11 w-full items-center justify-center rounded-md bg-brand-red px-4 text-sm font-bold text-white shadow-brand transition hover:bg-brand-maroon disabled:opacity-60"
            disabled={loading}
          >
            {loading ? "Signing in..." : "Login"}
          </button>
        </form>
      </section>
    </main>
  );
}

function AdminShell({ pathname, navigate, children }: AdminPath & { children: React.ReactNode }) {
  const adminName = localStorage.getItem("admin_name") || "Admin";

  function logout() {
    localStorage.removeItem("admin_token");
    localStorage.removeItem("admin_name");
    navigate(`${ADMIN_BASE_PATH}/login`);
  }

  return (
    <main className="min-h-screen bg-[#f4f5f7] text-brand-dark">
      <aside className="fixed inset-y-0 left-0 hidden w-64 border-r bg-white lg:block">
        <div className="flex h-20 items-center border-b px-5">
          <img src={logoUrl} alt="Shivrudra Graphics" className="h-12 w-auto" />
        </div>
        <nav className="grid gap-1 p-3">
          {navItems.map((item) => {
            const Icon = item.icon;
            const active = pathname === item.path;
            return (
              <button
                key={item.path}
                onClick={() => navigate(item.path)}
                className={`flex h-10 items-center gap-3 rounded-md px-3 text-left text-sm font-bold transition ${
                  active ? "bg-brand-red text-white" : "text-muted-foreground hover:bg-muted hover:text-brand-dark"
                }`}
              >
                <Icon className="size-4" />
                {item.label}
              </button>
            );
          })}
        </nav>
      </aside>

      <section className="lg:pl-64">
        <header className="sticky top-0 z-20 flex min-h-16 items-center justify-between border-b bg-white/95 px-4 backdrop-blur md:px-6">
          <div>
            <p className="text-xs font-bold uppercase tracking-wide text-brand-red">Admin Panel</p>
            <h1 className="font-display text-lg font-black md:text-xl">Welcome, {adminName}</h1>
          </div>
          <button
            onClick={logout}
            className="inline-flex h-9 items-center gap-2 rounded-md border px-3 text-sm font-bold transition hover:bg-muted"
          >
            <LogOut className="size-4" />
            Logout
          </button>
        </header>

        <div className="border-b bg-white px-4 py-3 lg:hidden">
          <div className="flex gap-2 overflow-x-auto">
            {navItems.map((item) => {
              const Icon = item.icon;
              const active = pathname === item.path;
              return (
                <button
                  key={item.path}
                  onClick={() => navigate(item.path)}
                  className={`inline-flex h-9 shrink-0 items-center gap-2 rounded-md px-3 text-sm font-bold ${
                    active ? "bg-brand-red text-white" : "bg-muted text-muted-foreground"
                  }`}
                >
                  <Icon className="size-4" />
                  {item.label}
                </button>
              );
            })}
          </div>
        </div>

        <div className="p-4 md:p-6">{children}</div>
      </section>
    </main>
  );
}

function AdminDashboard({ navigate }: AdminPath) {
  const [counts, setCounts] = useState<Record<string, number>>({});
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function loadCounts() {
      setLoading(true);
      setError("");

      try {
        const entries = await Promise.all(
          resources.map(async (resource) => {
            const rows = await adminApi<AdminRecord[]>(`/${resource.key}`);
            return [resource.key, rows.length] as const;
          }),
        );
        setCounts(Object.fromEntries(entries));
      } catch (err) {
        setError(err instanceof Error ? err.message : "Dashboard failed to load");
      } finally {
        setLoading(false);
      }
    }

    loadCounts();
  }, []);

  const totalRecords = Object.values(counts).reduce((sum, count) => sum + count, 0);
  const primaryStats = [
    { label: "Total Records", value: loading ? "-" : totalRecords, note: "Across website modules" },
    { label: "Content Modules", value: resources.length, note: "Ready for editing" },
    { label: "API Status", value: error ? "Check" : "Live", note: "Connected to MySQL backend" },
  ];

  return (
    <div>
      <section className="overflow-hidden rounded-lg border bg-white shadow-soft">
        <div className="relative bg-brand-dark px-6 py-7 text-white md:px-8">
          <div className="absolute inset-y-0 right-0 w-1/2 bg-[radial-gradient(circle_at_top_right,rgba(229,37,33,0.42),transparent_42%)]" />
          <div className="relative flex flex-col justify-between gap-5 md:flex-row md:items-end">
            <div>
              <p className="text-xs font-black uppercase tracking-[0.22em] text-brand-yellow">Control Center</p>
              <h2 className="mt-2 font-display text-3xl font-black md:text-4xl">Dashboard</h2>
              <p className="mt-2 max-w-2xl text-sm leading-6 text-white/72">
                Manage the editable sections of Shivrudra Graphics from one clean workspace.
              </p>
            </div>
            <button
              onClick={() => navigate(`${ADMIN_BASE_PATH}/services`)}
              className="inline-flex h-11 items-center justify-center gap-2 rounded-md bg-brand-red px-5 text-sm font-black text-white shadow-brand transition hover:bg-brand-maroon"
            >
              <Plus className="size-4" />
              Add Content
            </button>
          </div>
        </div>

        <div className="grid gap-px bg-border md:grid-cols-3">
          {primaryStats.map((stat) => (
            <div key={stat.label} className="bg-white px-6 py-5">
              <p className="text-xs font-black uppercase tracking-wide text-muted-foreground">{stat.label}</p>
              <p className="mt-2 text-3xl font-black text-brand-dark">{stat.value}</p>
              <p className="mt-1 text-sm text-muted-foreground">{stat.note}</p>
            </div>
          ))}
        </div>
      </section>

      {error ? <p className="mt-5 rounded-md bg-red-50 px-3 py-2 text-sm font-semibold text-red-700">{error}</p> : null}

      <div className="mt-6 flex items-center justify-between gap-4">
        <div>
          <h3 className="font-display text-xl font-black">Website Modules</h3>
          <p className="mt-1 text-sm text-muted-foreground">Open any module to add, edit, delete, publish, and reorder.</p>
        </div>
      </div>

      <div className="mt-4 grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        {resources.map((resource) => {
          const Icon = resource.icon;
          const count = counts[resource.key];
          return (
            <button
              key={resource.key}
              onClick={() => navigate(`${ADMIN_BASE_PATH}/${resource.key}`)}
              className="group relative overflow-hidden rounded-lg border bg-white p-5 text-left shadow-soft transition hover:-translate-y-0.5 hover:border-brand-red hover:shadow-lg"
            >
              <span className="absolute inset-x-0 top-0 h-1 bg-brand-red opacity-0 transition group-hover:opacity-100" />
              <div className="flex items-center justify-between gap-3">
                <span className="grid size-12 place-items-center rounded-lg bg-red-50 text-brand-red transition group-hover:bg-brand-red group-hover:text-white">
                  <Icon className="size-5" />
                </span>
                <span className="grid size-9 place-items-center rounded-md bg-muted text-muted-foreground">
                  <BarChart3 className="size-4" />
                </span>
              </div>
              <p className="mt-6 text-4xl font-black text-brand-dark">{loading ? "-" : count ?? 0}</p>
              <div className="mt-2 flex items-center justify-between gap-3">
                <p className="text-sm font-black text-brand-dark">{resource.label}</p>
                <span className="rounded-full bg-muted px-2.5 py-1 text-xs font-black text-muted-foreground">
                  Manage
                </span>
              </div>
              <p className="mt-3 text-xs leading-5 text-muted-foreground">
                {resource.singular} records available for website content updates.
              </p>
            </button>
          );
        })}
      </div>
    </div>
  );
}

function AdminResourcePage({ resource }: { resource: ResourceConfig }) {
  const [rows, setRows] = useState<AdminRecord[]>([]);
  const [relationOptions, setRelationOptions] = useState<Record<string, AdminRecord[]>>({});
  const [editing, setEditing] = useState<AdminRecord | null>(null);
  const [form, setForm] = useState<AdminRecord>({});
  const [query, setQuery] = useState("");
  const [serviceFilter, setServiceFilter] = useState("");
  const [categoryFilter, setCategoryFilter] = useState("");
  const [productFilter, setProductFilter] = useState("");
  const [galleryTypeFilter, setGalleryTypeFilter] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [saving, setSaving] = useState(false);

  async function loadRows() {
    setLoading(true);
    setError("");

    try {
      setRows(await adminApi<AdminRecord[]>(`/${resource.key}`));
    } catch (err) {
      setError(err instanceof Error ? err.message : `${resource.label} failed to load`);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    setEditing(null);
    setForm(defaultForm(resource));
    setQuery("");
    setServiceFilter("");
    setCategoryFilter("");
    setProductFilter("");
    setGalleryTypeFilter("");
    loadRows();
  }, [resource.key]);

  useEffect(() => {
    async function loadRelationOptions() {
      const optionKeys = Array.from(
        new Set(resource.fields.map((field) => field.optionsKey).filter(Boolean)),
      ) as string[];

      if (!optionKeys.length) {
        setRelationOptions({});
        return;
      }

      const entries = await Promise.all(
        optionKeys.map(async (key) => [key, await adminApi<AdminRecord[]>(`/${key}`)] as const),
      );

      setRelationOptions(Object.fromEntries(entries));
    }

    loadRelationOptions().catch(() => setRelationOptions({}));
  }, [resource.fields, resource.key]);

  const filteredRows = useMemo(() => {
    const term = query.trim().toLowerCase();
    const byRelation = rows.filter((row) => {
      if (resource.key === "products") {
        if (serviceFilter && String(row.service_id ?? "") !== serviceFilter) return false;
        if (categoryFilter && String(row.category_id ?? "") !== categoryFilter) return false;
      }
      if (resource.key === "product-gallery") {
        if (serviceFilter && String(row.service_id ?? "") !== serviceFilter) return false;
        if (galleryTypeFilter && String(row.gallery_type ?? "product") !== galleryTypeFilter) return false;
        if (productFilter) {
          if (galleryTypeFilter === "sub-product") {
            if (String(row.sub_product_id ?? "") !== productFilter) return false;
          } else if (String(row.product_id ?? "") !== productFilter) {
            return false;
          }
        }
      }
      if (resource.key === "sub-products" && productFilter && String(row.product_id ?? "") !== productFilter) {
        return false;
      }
      return true;
    });

    if (!term) return byRelation;

    return byRelation.filter((row) =>
      Object.values(row).some((value) => String(value ?? "").toLowerCase().includes(term)),
    );
  }, [categoryFilter, galleryTypeFilter, productFilter, query, resource.key, rows, serviceFilter]);

  function openCreate() {
    setEditing({});
    setForm({ ...defaultForm(resource), ...(resource.key === "product-gallery" ? { gallery_type: "product" } : {}) });
    setError("");
  }

  function openEdit(row: AdminRecord) {
    setEditing(row);
    setForm({ ...defaultForm(resource), ...row });
    setError("");
  }

  function closeForm() {
    setEditing(null);
    setForm(defaultForm(resource));
  }

  function updateField(field: Field, value: string | boolean) {
    if (field.type === "number" || field.type === "select") {
      if (field.type === "select" && field.valueType === "string") {
        setForm((current) => ({
          ...current,
          [field.name]: value === "" ? "" : String(value),
          ...(resource.key === "product-gallery" && field.name === "gallery_type"
            ? { product_id: null, sub_product_id: null }
            : {}),
        }));
        return;
      }

      setForm((current) => ({
        ...current,
        [field.name]: value === "" ? null : Number(value),
        ...(resource.key === "product-gallery" && field.name === "service_id"
          ? { product_id: null, sub_product_id: null }
          : {}),
      }));
      return;
    }

    setForm((current) => ({ ...current, [field.name]: value }));
  }

  async function uploadImage(field: Field, file?: File) {
    if (!file) return;

    const data = new FormData();
    data.append("image", file);
    const result = await adminApi<{ url: string }>("/upload", { method: "POST", body: data });
    updateField(field, result.url);
  }

  async function saveRecord(event: FormEvent) {
    event.preventDefault();
    setSaving(true);
    setError("");

    try {
      const body = cleanPayload(form, resource);
      const isEdit = Boolean(editing?.id);

      await adminApi(`/${resource.key}${isEdit ? `/${editing?.id}` : ""}`, {
        method: isEdit ? "PUT" : "POST",
        body: JSON.stringify(body),
      });

      await loadRows();
      closeForm();
    } catch (err) {
      setError(err instanceof Error ? err.message : `${resource.singular} could not be saved`);
    } finally {
      setSaving(false);
    }
  }

  async function deleteRecord(row: AdminRecord) {
    if (!row.id) return;
    if (!confirm(`Delete this ${resource.singular.toLowerCase()}?`)) return;

    try {
      await adminApi(`/${resource.key}/${row.id}`, { method: "DELETE" });
      await loadRows();
    } catch (err) {
      setError(err instanceof Error ? err.message : `${resource.singular} could not be deleted`);
    }
  }

  return (
    <div>
      <div className="flex flex-col justify-between gap-4 md:flex-row md:items-end">
        <div>
          <h2 className="font-display text-3xl font-black">{resource.label}</h2>
          <p className="mt-1 text-sm text-muted-foreground">Add, edit, delete, publish, and reorder records.</p>
        </div>
        <button
          onClick={openCreate}
          className="inline-flex h-10 items-center justify-center gap-2 rounded-md bg-brand-red px-4 text-sm font-bold text-white shadow-brand"
        >
          <Plus className="size-4" />
          Add {resource.singular}
        </button>
      </div>

      {error ? <p className="mt-5 rounded-md bg-red-50 px-3 py-2 text-sm font-semibold text-red-700">{error}</p> : null}

      <div className="mt-6 rounded-lg border bg-white p-4 shadow-soft">
        <label className="relative block">
          <Search className="absolute left-3 top-1/2 size-4 -translate-y-1/2 text-muted-foreground" />
          <input
            className="h-10 w-full rounded-md border px-9 text-sm outline-none focus:ring-2 focus:ring-brand-red"
            placeholder={`Search ${resource.label.toLowerCase()}`}
            value={query}
            onChange={(event) => setQuery(event.target.value)}
          />
        </label>

        {resource.key === "products" ? (
          <div className="mt-3 grid gap-3 md:grid-cols-[1fr_1fr_auto]">
            <label className="grid gap-1 text-xs font-black uppercase tracking-wide text-muted-foreground">
              Main Service
              <select
                className="h-10 rounded-md border bg-white px-3 text-sm font-semibold normal-case tracking-normal text-brand-dark outline-none focus:ring-2 focus:ring-brand-red"
                value={serviceFilter}
                onChange={(event) => setServiceFilter(event.target.value)}
              >
                <option value="">All services</option>
                {(relationOptions.services ?? []).map((service) => (
                  <option key={service.id} value={String(service.id)}>
                    {optionLabel(service)}
                  </option>
                ))}
              </select>
            </label>

            <label className="grid gap-1 text-xs font-black uppercase tracking-wide text-muted-foreground">
              Category
              <select
                className="h-10 rounded-md border bg-white px-3 text-sm font-semibold normal-case tracking-normal text-brand-dark outline-none focus:ring-2 focus:ring-brand-red"
                value={categoryFilter}
                onChange={(event) => setCategoryFilter(event.target.value)}
              >
                <option value="">All categories</option>
                {(relationOptions.categories ?? []).map((category) => (
                  <option key={category.id} value={String(category.id)}>
                    {optionLabel(category)}
                  </option>
                ))}
              </select>
            </label>

            <button
              type="button"
              onClick={() => {
                setQuery("");
                setServiceFilter("");
                setCategoryFilter("");
              }}
              className="h-10 self-end rounded-md border px-4 text-sm font-black transition hover:bg-muted"
            >
              Clear Filters
            </button>
          </div>
        ) : null}

        {resource.key === "product-gallery" ? (
          <div className="mt-3 grid gap-3 md:grid-cols-[1fr_0.8fr_1fr_auto]">
            <label className="grid gap-1 text-xs font-black uppercase tracking-wide text-muted-foreground">
              Service
              <select
                className="h-10 rounded-md border bg-white px-3 text-sm font-semibold normal-case tracking-normal text-brand-dark outline-none focus:ring-2 focus:ring-brand-red"
                value={serviceFilter}
                onChange={(event) => {
                  setServiceFilter(event.target.value);
                  setProductFilter("");
                }}
              >
                <option value="">All services</option>
                {(relationOptions.services ?? []).map((service) => (
                  <option key={service.id} value={String(service.id)}>
                    {optionLabel(service)}
                  </option>
                ))}
              </select>
            </label>

            <label className="grid gap-1 text-xs font-black uppercase tracking-wide text-muted-foreground">
              Type
              <select
                className="h-10 rounded-md border bg-white px-3 text-sm font-semibold normal-case tracking-normal text-brand-dark outline-none focus:ring-2 focus:ring-brand-red"
                value={galleryTypeFilter}
                onChange={(event) => {
                  setGalleryTypeFilter(event.target.value);
                  setProductFilter("");
                }}
              >
                <option value="">All types</option>
                <option value="product">Product</option>
                <option value="sub-product">Sub Product</option>
              </select>
            </label>

            <label className="grid gap-1 text-xs font-black uppercase tracking-wide text-muted-foreground">
              {galleryTypeFilter === "sub-product" ? "Sub Product" : "Product"}
              <select
                className="h-10 rounded-md border bg-white px-3 text-sm font-semibold normal-case tracking-normal text-brand-dark outline-none focus:ring-2 focus:ring-brand-red"
                value={productFilter}
                onChange={(event) => setProductFilter(event.target.value)}
              >
                <option value="">{galleryTypeFilter === "sub-product" ? "All sub products" : "All products"}</option>
                {(galleryTypeFilter === "sub-product" ? relationOptions["sub-products"] ?? [] : relationOptions.products ?? [])
                  .filter((option) => !serviceFilter || String(option.service_id ?? "") === serviceFilter)
                  .map((option) => (
                    <option key={option.id} value={String(option.id)}>
                      {optionLabel(option)}
                    </option>
                  ))}
              </select>
            </label>

            <button
              type="button"
              onClick={() => {
                setQuery("");
                setServiceFilter("");
                setProductFilter("");
                setGalleryTypeFilter("");
              }}
              className="h-10 self-end rounded-md border px-4 text-sm font-black transition hover:bg-muted"
            >
              Clear Filters
            </button>
          </div>
        ) : null}

        {resource.key === "sub-products" ? (
          <div className="mt-3 grid gap-3 md:grid-cols-[1fr_auto]">
            <label className="grid gap-1 text-xs font-black uppercase tracking-wide text-muted-foreground">
              Parent Product
              <select
                className="h-10 rounded-md border bg-white px-3 text-sm font-semibold normal-case tracking-normal text-brand-dark outline-none focus:ring-2 focus:ring-brand-red"
                value={productFilter}
                onChange={(event) => setProductFilter(event.target.value)}
              >
                <option value="">All products</option>
                {(relationOptions.products ?? []).map((product) => (
                  <option key={product.id} value={String(product.id)}>
                    {optionLabel(product)}
                  </option>
                ))}
              </select>
            </label>

            <button
              type="button"
              onClick={() => {
                setQuery("");
                setProductFilter("");
              }}
              className="h-10 self-end rounded-md border px-4 text-sm font-black transition hover:bg-muted"
            >
              Clear Filters
            </button>
          </div>
        ) : null}

        <div className="mt-4 overflow-x-auto">
          <table className="w-full min-w-[760px] border-collapse text-left text-sm">
            <thead>
              <tr className="bg-muted">
                {resource.columns.map((column) => (
                  <th key={column} className="border-b px-3 py-3 font-black">
                    {formatLabel(column)}
                  </th>
                ))}
                <th className="w-36 border-b px-3 py-3 font-black">Actions</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr>
                  <td className="px-3 py-8 text-center text-muted-foreground" colSpan={resource.columns.length + 1}>
                    Loading...
                  </td>
                </tr>
              ) : filteredRows.length ? (
                filteredRows.map((row) => (
                  <tr key={row.id} className="border-b last:border-b-0">
                    {resource.columns.map((column) => (
                      <td key={column} className="max-w-[280px] truncate px-3 py-3">
                        {renderCell(row[column], column)}
                      </td>
                    ))}
                    <td className="px-3 py-3">
                      <div className="flex gap-2">
                        <button
                          onClick={() => openEdit(row)}
                          className="grid size-8 place-items-center rounded-md border text-brand-dark transition hover:bg-muted"
                          title="Edit"
                        >
                          <Pencil className="size-4" />
                        </button>
                        <button
                          onClick={() => deleteRecord(row)}
                          className="grid size-8 place-items-center rounded-md border text-brand-red transition hover:bg-red-50"
                          title="Delete"
                        >
                          <Trash2 className="size-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td className="px-3 py-8 text-center text-muted-foreground" colSpan={resource.columns.length + 1}>
                    No records found.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      {editing ? (
        <div className="fixed inset-0 z-50 overflow-y-auto bg-black/40 p-4">
          <form onSubmit={saveRecord} className="mx-auto max-w-3xl rounded-lg bg-white shadow-2xl">
            <div className="flex items-center justify-between border-b px-5 py-4">
              <h3 className="font-display text-xl font-black">
                {editing.id ? "Edit" : "Add"} {resource.singular}
              </h3>
              <button type="button" onClick={closeForm} className="grid size-9 place-items-center rounded-md border">
                <X className="size-4" />
              </button>
            </div>

            <div className="grid gap-4 p-5 md:grid-cols-2">
              {resource.fields.map((field) => {
                const galleryType = String(form.gallery_type || "product");
                if (resource.key === "product-gallery" && field.name === "product_id" && galleryType === "sub-product") {
                  return null;
                }
                if (resource.key === "product-gallery" && field.name === "sub_product_id" && galleryType !== "sub-product") {
                  return null;
                }

                return (
                  <AdminField
                    key={field.name}
                    field={field}
                    options={
                      field.optionsKey
                        ? resource.key === "product-gallery" &&
                          (field.name === "product_id" || field.name === "sub_product_id") &&
                          form.service_id
                          ? (relationOptions[field.optionsKey] ?? []).filter(
                              (option) => String(option.service_id ?? "") === String(form.service_id),
                            )
                          : relationOptions[field.optionsKey] ?? []
                        : []
                    }
                    value={form[field.name]}
                    onChange={(value) => updateField(field, value)}
                    onUpload={(file) => uploadImage(field, file)}
                  />
                );
              })}
            </div>

            <div className="flex justify-end gap-3 border-t px-5 py-4">
              <button type="button" onClick={closeForm} className="inline-flex h-10 items-center gap-2 rounded-md border px-4 text-sm font-bold">
                <X className="size-4" />
                Cancel
              </button>
              <button
                className="inline-flex h-10 items-center gap-2 rounded-md bg-brand-red px-4 text-sm font-bold text-white shadow-brand disabled:opacity-60"
                disabled={saving}
              >
                <Save className="size-4" />
                {saving ? "Saving..." : "Save"}
              </button>
            </div>
          </form>
        </div>
      ) : null}
    </div>
  );
}

function AdminField({
  field,
  options,
  value,
  onChange,
  onUpload,
}: {
  field: Field;
  options?: AdminRecord[];
  value: AdminRecord[string];
  onChange: (value: string | boolean) => void;
  onUpload: (file?: File) => Promise<void>;
}) {
  if (field.type === "checkbox") {
    return (
      <label className="flex h-11 min-w-0 items-center gap-3 rounded-md border px-3 text-sm font-bold">
        <input checked={Boolean(value)} onChange={(event) => onChange(event.target.checked)} type="checkbox" />
        {field.label}
      </label>
    );
  }

  if (field.type === "textarea") {
    return (
      <label className="grid min-w-0 gap-2 text-sm font-bold md:col-span-2">
        {field.label}
        <textarea
          className="min-h-28 w-full min-w-0 rounded-md border px-3 py-2 font-normal outline-none focus:ring-2 focus:ring-brand-red"
          value={toInputValue(value)}
          onChange={(event) => onChange(event.target.value)}
          required={field.required}
          placeholder={field.placeholder}
        />
      </label>
    );
  }

  if (field.type === "select") {
    const selectOptions = field.options ?? (options ?? []).map((option) => ({
      label: optionLabel(option),
      value: String(option.id),
    }));

    return (
      <label className="grid min-w-0 gap-2 text-sm font-bold">
        {field.label}
        <select
          className="h-10 w-full min-w-0 rounded-md border bg-white px-3 text-sm font-normal outline-none focus:ring-2 focus:ring-brand-red"
          value={toInputValue(value)}
          onChange={(event) => onChange(event.target.value)}
          required={field.required}
        >
          <option value="">Select {field.label}</option>
          {selectOptions.map((option) => (
            <option key={option.value} value={String(option.value)}>
              {option.label}
            </option>
          ))}
        </select>
      </label>
    );
  }

  if (field.type === "image") {
    return (
      <label className="grid min-w-0 gap-2 text-sm font-bold">
        {field.label}
        <div className="grid min-w-0 gap-2">
          <input
            className="h-10 w-full min-w-0 rounded-md border px-3 text-sm font-normal outline-none focus:ring-2 focus:ring-brand-red"
            value={toInputValue(value)}
            onChange={(event) => onChange(event.target.value)}
            required={field.required}
            placeholder="/uploads/image.jpg"
          />
          <label className="inline-flex h-10 cursor-pointer items-center justify-center gap-2 rounded-md border bg-muted px-3 text-sm font-bold">
            <Upload className="size-4" />
            Upload Image
            <input className="hidden" type="file" accept="image/*" onChange={(event) => onUpload(event.target.files?.[0])} />
          </label>
        </div>
      </label>
    );
  }

  return (
      <label className="grid min-w-0 gap-2 text-sm font-bold">
      {field.label}
      <input
        className="h-10 w-full min-w-0 rounded-md border px-3 text-sm font-normal outline-none focus:ring-2 focus:ring-brand-red"
        value={toInputValue(value)}
        onChange={(event) => onChange(event.target.value)}
        required={field.required}
        placeholder={field.placeholder}
        type={field.type === "number" ? "number" : field.type === "datetime" ? "datetime-local" : "text"}
      />
    </label>
  );
}

function defaultForm(resource: ResourceConfig): AdminRecord {
  return Object.fromEntries(
    resource.fields.map((field) => {
      if (resource.key === "product-gallery" && field.name === "gallery_type") return [field.name, "product"];
      if (field.type === "checkbox") return [field.name, field.name.includes("active") ? true : false];
      if (field.type === "number") return [field.name, field.name === "rating" ? 5 : 0];
      return [field.name, ""];
    }),
  );
}

function cleanPayload(form: AdminRecord, resource: ResourceConfig) {
  const payload: AdminRecord = {};

  for (const field of resource.fields) {
    const value = form[field.name];
    if (field.type === "checkbox") {
      payload[field.name] = value ? 1 : 0;
      continue;
    }

    if (value === "" || value === undefined) continue;
    payload[field.name] = value;
  }

  if (resource.key === "product-gallery") {
    payload.gallery_type = payload.gallery_type || "product";
    if (payload.gallery_type === "sub-product") {
      payload.product_id = null;
    } else {
      payload.sub_product_id = null;
    }
  }

  return payload;
}

function renderCell(value: AdminRecord[string], column?: string) {
  const isBooleanColumn = column?.startsWith("is_") || column === "status";
  if (typeof value === "boolean") return value ? "Yes" : "No";
  if (isBooleanColumn && value === 1) return "Yes";
  if (isBooleanColumn && value === 0) return "No";
  if (!value) return "-";

  if (column?.includes("image") || column?.includes("logo")) {
    return (
      <img
        src={assetUrl(String(value))}
        alt=""
        className="h-12 w-20 rounded border bg-white object-contain p-1"
      />
    );
  }

  return String(value);
}

export function AdminPage({ pathname, navigate }: AdminPath) {
  useEffect(() => {
    document.title = "Admin Panel - Shivrudra Graphics";
  }, []);

  if (pathname === `${ADMIN_BASE_PATH}/login`) {
    if (getToken()) navigate(`${ADMIN_BASE_PATH}/dashboard`);
    return <AdminLoginPage pathname={pathname} navigate={navigate} />;
  }

  if (!getToken()) {
    navigate(`${ADMIN_BASE_PATH}/login`);
    return null;
  }

  const resourceKey = pathname.slice(ADMIN_BASE_PATH.length).split("/").filter(Boolean)[0] || "dashboard";
  const resource = resources.find((item) => item.key === resourceKey);

  return (
    <AdminShell pathname={pathname} navigate={navigate}>
      {resourceKey === "dashboard" ? (
        <AdminDashboard pathname={pathname} navigate={navigate} />
      ) : resource ? (
        <AdminResourcePage resource={resource} />
      ) : (
        <AdminDashboard pathname={pathname} navigate={navigate} />
      )}
    </AdminShell>
  );
}
