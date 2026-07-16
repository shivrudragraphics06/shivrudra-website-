import { publicApi } from "@/lib/api";

export type PublicService = {
  id?: number;
  slug: string;
  name: string;
  serviceName?: string;
  serviceSlug?: string;
  image_url?: string;
  main_image_url?: string;
  short_description?: string;
  description?: string;
  blurb?: string;
  subs?: string[];
  products?: { id: number; name: string; slug: string; service_id: number }[];
};

export type PublicCategory = {
  id?: number;
  slug: string;
  name: string;
  icon?: string;
  description?: string;
  image_url?: string;
};

export type PublicGalleryItem = {
  id?: number;
  cat?: string;
  category?: string;
  title: string;
  img?: string;
  image_url?: string;
  alt_text?: string;
};

export type PublicProductVariant = {
  id?: number;
  product_id?: number | null;
  label: string;
  detail?: string;
  image_url?: string;
  colors?: string;
  sort_order?: number;
};

export type PublicIndustry = {
  id?: number;
  name: string;
  slug?: string;
  icon_url?: string;
  image_url?: string;
};

export type PublicClient = {
  id?: number;
  name: string;
  logo_url?: string;
  website_url?: string;
};

export type PublicTestimonial = {
  id?: number;
  name?: string;
  role?: string;
  text?: string;
  client_name?: string;
  client_role?: string;
  company?: string;
  message?: string;
  rating?: number;
};

export type PublicContact = {
  phones: string[];
  email: string;
  website: string;
  whatsapp: string;
  address: string;
};

export type PublicInquiry = {
  name: string;
  mobile: string;
  email?: string;
  business?: string;
  service?: string;
  message?: string;
  source?: string;
};

export const fetchPublicServices = () => publicApi<PublicService[]>("/services");
export const fetchPublicCategories = () => publicApi<PublicCategory[]>("/categories");
export const fetchPublicGallery = () => publicApi<PublicGalleryItem[]>("/gallery");
export const fetchPublicIndustries = () => publicApi<PublicIndustry[]>("/industries");
export const fetchPublicClients = () => publicApi<PublicClient[]>("/clients");
export const fetchPublicTestimonials = () => publicApi<PublicTestimonial[]>("/testimonials");
export const fetchPublicContact = () => publicApi<Partial<PublicContact>>("/contact");
export const fetchPublicProduct = (slug: string) =>
  publicApi<PublicService & { images?: PublicGalleryItem[]; variants?: PublicProductVariant[] }>(`/products/${slug}`);

export async function submitPublicInquiry(inquiry: PublicInquiry) {
  const response = await fetch(`${import.meta.env.VITE_API_URL || "http://localhost:5000"}/api/public/inquiries`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ ...inquiry, source: inquiry.source || "website" }),
  });

  if (!response.ok) {
    const data = await response.json().catch(() => ({}));
    throw new Error(data.message || "Inquiry could not be saved");
  }

  return response.json() as Promise<{ id: number; message: string }>;
}
