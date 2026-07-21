import { ArrowRight } from "lucide-react";
import { useEffect, useMemo, useState } from "react";

import { PageHero } from "@/components/PageHero";
import { Link } from "@/components/AppLink";
import { usePublicServices } from "@/hooks/use-public-data";
import { assetUrl } from "@/lib/api";
import { fetchPublicLogoDesigns, fetchPublicProductGallery, type PublicLogoDesign } from "@/lib/public-content";

export const LOGO_TYPES = [
  {
    name: "Minimal Logos",
    colors: "from-white via-[#f7f7f7] to-[#ffe9e9]",
    mark: "M",
  },
  {
    name: "Typography Logos",
    colors: "from-[#fff7d1] via-white to-[#ffe2df]",
    mark: "Aa",
  },
  {
    name: "3D Logos",
    colors: "from-[#fff0c2] via-[#ffe6d1] to-[#ffd6d1]",
    mark: "3D",
  },
  {
    name: "Lettermark Logos",
    colors: "from-white via-[#eef4ff] to-[#ffe8e2]",
    mark: "SG",
  },
  {
    name: "Mascot Logos",
    colors: "from-[#fff3cf] via-white to-[#e9f7ee]",
    mark: "MC",
  },
  {
    name: "Emblem Logos",
    colors: "from-[#f7f7f7] via-white to-[#ffecc4]",
    mark: "EM",
  },
  {
    name: "Icon Logos",
    colors: "from-white via-[#fff5d9] to-[#ffdede]",
    mark: "IC",
  },
  {
    name: "Calligraphy Logos",
    colors: "from-[#fff8df] via-white to-[#f7e7ff]",
    mark: "CA",
  },
];

const FALLBACK_LOGOS: PublicLogoDesign[] = [
  { title: "Bank of India", image_url: "/images/clients/01-bank-of-india.png" },
  { title: "Indian Oil", image_url: "/images/clients/02-indian-oil.png" },
  { title: "HP Petrol", image_url: "/images/clients/03-hp-petrol.png" },
  { title: "Dexgreen", image_url: "/images/clients/04-dexgreen.png" },
  { title: "Sunteck", image_url: "/images/clients/05-sunteck.png" },
  { title: "Pirajees", image_url: "/images/clients/06-pirajees.png" },
  { title: "Sahuwala", image_url: "/images/clients/07-sahuwala.png" },
  { title: "Agrovan", image_url: "/images/clients/08-agrovan.png" },
  { title: "Cherise", image_url: "/images/clients/09-cherise.png" },
  { title: "Sarvadnya", image_url: "/images/clients/10-sarvadnya.png" },
  { title: "Sadhu Vaswani Gurukul", image_url: "/images/clients/11-sadhu-vaswani-gurukul.png" },
  { title: "Bharat School", image_url: "/images/clients/12-bharat-school.png" },
  { title: "Acute", image_url: "/images/clients/14-acute.png" },
  { title: "Caramellas", image_url: "/images/clients/15-caramellas.png" },
  { title: "Autopeepal", image_url: "/images/clients/24-autopeepal.png" },
  { title: "Apollo", image_url: "/images/clients/30-apollo.png" },
];

function titleFromSlug(slug: string) {
  return slug
    .replace(/-/g, " ")
    .replace(/\b\w/g, (letter) => letter.toUpperCase())
    .replace(/\bCnc\b/g, "CNC")
    .replace(/\bUv\b/g, "UV");
}

function normalizeProductSlug(serviceSlug: string, productSlug: string) {
  if (serviceSlug === "designing" && productSlug === "logo") return "logo-design";
  return productSlug;
}

export function LogoDesignPage({
  serviceSlug = "designing",
  productSlug = "logo",
}: {
  serviceSlug?: string;
  productSlug?: string;
}) {
  const services = usePublicServices();
  const normalizedProductSlug = normalizeProductSlug(serviceSlug, productSlug);
  const isLogoGallery = serviceSlug === "designing" && normalizedProductSlug === "logo-design";
  const serviceFromData = useMemo(() => services.find((service) => service.slug === serviceSlug), [serviceSlug, services]);
  const productFromData = useMemo(
    () => serviceFromData?.products?.find((product) => product.slug === normalizedProductSlug),
    [normalizedProductSlug, serviceFromData],
  );
  const fallbackItems = useMemo(() => (isLogoGallery ? FALLBACK_LOGOS : []), [isLogoGallery]);
  const [logoDesigns, setLogoDesigns] = useState<PublicLogoDesign[]>(fallbackItems);
  const [productName, setProductName] = useState(productFromData?.name || (isLogoGallery ? "Logo Design" : titleFromSlug(normalizedProductSlug)));
  const [serviceName, setServiceName] = useState(serviceFromData?.name || titleFromSlug(serviceSlug));

  useEffect(() => {
    setLogoDesigns(fallbackItems);
    setProductName(productFromData?.name || (isLogoGallery ? "Logo Design" : titleFromSlug(normalizedProductSlug)));
    setServiceName(serviceFromData?.name || titleFromSlug(serviceSlug));

    fetchPublicProductGallery(serviceSlug, productSlug)
      .then((data) => {
        setProductName(data.product.name || titleFromSlug(normalizedProductSlug));
        setServiceName(data.product.service_name || titleFromSlug(serviceSlug));
        const activeItems = data.items.filter((item) => item.image_url);
        setLogoDesigns(activeItems.length ? activeItems : fallbackItems);
      })
      .catch(() => {
        if (isLogoGallery) {
          fetchPublicLogoDesigns()
            .then((items) => {
              const activeItems = items.filter((item) => item.image_url);
              if (activeItems.length) setLogoDesigns(activeItems);
            })
            .catch(() => {});
        }
      });
  }, [fallbackItems, isLogoGallery, normalizedProductSlug, productFromData, productSlug, serviceFromData, serviceSlug]);

  const logoCount = useMemo(() => logoDesigns.filter((item) => item.image_url).length, [logoDesigns]);
  const itemLabel = logoCount === 1 ? "Gallery Image" : "Gallery Images";

  return (
    <div>
      <PageHero
        title={productName}
        subtitle={`Product gallery for ${productName}.`}
        breadcrumb={[
          { label: "Services", to: "/services" },
          { label: serviceName, to: `/services/${serviceSlug}` },
          { label: productName },
        ]}
      />

      <section className="container-page py-14 md:py-18">
        <div className="flex flex-col gap-5 md:flex-row md:items-end md:justify-between">
          <div>
            <p className="text-xs font-black uppercase tracking-[0.22em] text-brand-red">
              {logoCount} {itemLabel}
            </p>
            <h2 className="mt-2 font-display text-3xl font-black leading-tight text-brand-dark sm:text-4xl md:text-5xl">
              Product Gallery
            </h2>
          </div>
          <Link
            to="/contact"
            className="inline-flex w-fit shrink-0 items-center gap-3 rounded-lg border border-border bg-white px-5 py-3 font-bold text-brand-dark shadow-soft transition hover:border-brand-red hover:text-brand-red"
          >
            Order Details <ArrowRight className="h-5 w-5" />
          </Link>
        </div>

        <div className="mt-10 grid grid-cols-1 gap-x-7 gap-y-10 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
          {logoDesigns.map((item, index) => {
            const title = item.title?.trim() || "";

            return (
              <figure
                key={item.id ?? `${item.image_url}-${index}`}
                className="group"
              >
                <div className="relative aspect-square w-full overflow-hidden rounded-lg bg-white">
                  <img
                    src={assetUrl(item.image_url)}
                    alt={item.alt_text || title || "Logo design"}
                    className="h-full w-full object-contain transition duration-700 group-hover:scale-105"
                    loading="lazy"
                  />
                </div>

                {title ? (
                  <figcaption className="mt-4 text-center font-display text-lg font-black leading-tight text-brand-dark sm:text-xl">
                    {title}
                  </figcaption>
                ) : null}
              </figure>
            );
          })}
        </div>
        {!logoDesigns.length ? (
          <div className="mt-10 rounded-lg border border-dashed border-border bg-white p-8 text-center shadow-soft">
            <h3 className="font-display text-2xl font-black text-brand-dark">No gallery images added yet</h3>
            <p className="mt-2 text-sm font-semibold text-muted-foreground">
              Images for {productName} can be added from Product Gallery in the admin panel.
            </p>
          </div>
        ) : null}
      </section>
    </div>
  );
}
