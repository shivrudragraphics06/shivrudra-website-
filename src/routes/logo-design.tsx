import { ArrowRight, Maximize2, X } from "lucide-react";
import { useEffect, useMemo, useState } from "react";

import { PageHero } from "@/components/PageHero";
import { Link } from "@/components/AppLink";
import { WhatsAppIcon } from "@/components/WhatsAppIcon";
import { usePublicContact, usePublicServices } from "@/hooks/use-public-data";
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
  const contact = usePublicContact();
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
  const [selectedLogo, setSelectedLogo] = useState<PublicLogoDesign | null>(null);

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

        <div className="mt-10 grid grid-cols-2 gap-4 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5">
          {logoDesigns.map((item, index) => {
            const title = item.title?.trim() || "";
            const message = `Hi, I want to enquire about ${title || productName}.`;

            return (
              <article
                key={item.id ?? `${item.image_url}-${index}`}
                className="group flex h-full flex-col overflow-hidden rounded-lg border border-border bg-white p-3 shadow-soft transition hover:-translate-y-1 hover:border-brand-red hover:shadow-xl"
              >
                <button
                  type="button"
                  onClick={() => setSelectedLogo(item)}
                  className="relative aspect-square overflow-hidden rounded-md border border-border bg-white"
                  aria-label={title ? `Preview ${title}` : "Preview logo"}
                >
                  <img
                    src={assetUrl(item.image_url)}
                    alt={item.alt_text || title || "Logo design"}
                    className="h-full w-full object-contain p-4 transition duration-700 group-hover:scale-105"
                    loading="lazy"
                  />
                  <span className="absolute right-2 top-2 grid h-8 w-8 scale-90 place-items-center rounded-full bg-white text-brand-red opacity-0 shadow-soft transition group-hover:scale-100 group-hover:opacity-100">
                    <Maximize2 className="h-4 w-4" />
                  </span>
                </button>

                <div className="flex flex-1 flex-col pt-3">
                  {title ? (
                    <h3 className="min-h-[2.5rem] text-center font-display text-sm font-black leading-snug text-brand-dark">
                      {title}
                    </h3>
                  ) : (
                    <div className="min-h-[2.5rem]" />
                  )}
                  <a
                    href={`https://wa.me/${contact.whatsapp}?text=${encodeURIComponent(message)}`}
                    target="_blank"
                    rel="noreferrer"
                    className="mt-auto inline-flex h-10 w-full items-center justify-center gap-2 rounded-lg bg-brand-red px-3 text-sm font-black text-white shadow-brand transition hover:bg-brand-maroon"
                  >
                    Enquire <WhatsAppIcon className="h-4 w-4" />
                  </a>
                </div>
              </article>
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

      {selectedLogo ? (
        <div
          className="fixed inset-0 z-[80] grid place-items-center bg-black/80 p-4"
          role="dialog"
          aria-modal="true"
          onClick={() => setSelectedLogo(null)}
        >
          <div
            className="relative flex max-h-[92vh] w-full max-w-4xl flex-col overflow-hidden rounded-xl bg-white"
            onClick={(event) => event.stopPropagation()}
          >
            <button
              type="button"
              onClick={() => setSelectedLogo(null)}
              className="absolute right-3 top-3 z-10 grid h-10 w-10 place-items-center rounded-full bg-white text-brand-dark shadow-soft transition hover:text-brand-red"
              aria-label="Close logo preview"
            >
              <X className="h-5 w-5" />
            </button>
            <div className="grid min-h-0 flex-1 place-items-center bg-neutral-100 p-4 sm:p-8">
              <img
                src={assetUrl(selectedLogo.image_url)}
                alt={selectedLogo.alt_text || selectedLogo.title || "Logo design"}
                className="mx-auto max-h-[72vh] max-w-full rounded-lg bg-white object-contain p-6"
              />
            </div>
            {selectedLogo.title ? (
              <div className="border-t border-border p-4 text-center font-display text-xl font-black text-brand-dark">
                {selectedLogo.title}
              </div>
            ) : null}
          </div>
        </div>
      ) : null}
    </div>
  );
}
