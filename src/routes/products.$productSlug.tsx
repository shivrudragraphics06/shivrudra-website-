import { ArrowRight, PackageCheck } from "lucide-react";
import { PageHero } from "@/components/PageHero";
import { assetUrl } from "@/lib/api";
import { findProductBySlug } from "@/lib/products";
import { Link } from "@/components/AppLink";
import { WhatsAppIcon } from "@/components/WhatsAppIcon";
import { useEffect, useState } from "react";
import { fetchPublicProduct, type PublicProductVariant } from "@/lib/public-content";
import { usePublicContact } from "@/hooks/use-public-data";

export function ProductNotFound() {
  return (
    <div className="container-page py-24 text-center">
      <h1 className="font-display text-3xl font-black">Product not found</h1>
      <Link to="/services" className="mt-4 inline-block font-bold text-brand-red">
        Back to services
      </Link>
    </div>
  );
}

export function ProductDetailPage({ productSlug }: { productSlug: string }) {
  const contact = usePublicContact();
  const [product, setProduct] = useState(() => findProductBySlug(productSlug));
  const [productDescription, setProductDescription] = useState("");
  const [mainImageUrl, setMainImageUrl] = useState("");
  const [variants, setVariants] = useState<PublicProductVariant[]>([]);
  const [detailImages, setDetailImages] = useState<{ image_url?: string; alt_text?: string; id?: number }[]>([]);
  const [failedDetailImages, setFailedDetailImages] = useState<Set<string>>(new Set());
  const [failedVariantImages, setFailedVariantImages] = useState<Set<string>>(new Set());

  useEffect(() => {
    const fallbackProduct = findProductBySlug(productSlug);
    setProduct(fallbackProduct);
    setProductDescription("");
    setMainImageUrl("");
    setVariants([]);
    setDetailImages([]);
    setFailedDetailImages(new Set());
    setFailedVariantImages(new Set());
    fetchPublicProduct(productSlug)
      .then((item) => {
        setProduct({
          slug: item.slug,
          name: item.name,
          serviceSlug: item.serviceSlug || "",
          serviceName: item.serviceName || "Services",
        });
        setProductDescription(item.description || item.short_description || "");
        setMainImageUrl(item.main_image_url || "");
        setDetailImages(item.images || []);
        setVariants(item.variants || []);
      })
      .catch(() => {});
  }, [productSlug]);

  if (!product) return <ProductNotFound />;

  return (
    <div>
      <PageHero
        title={product.name}
        subtitle={productDescription || "Product details and images are managed from the admin panel."}
        breadcrumb={[
          { label: "Services", to: "/services" },
          { label: product.serviceName, to: `/services/${product.serviceSlug}` },
          { label: product.name },
        ]}
      />

      <section className="container-page py-14 md:py-18">
        <div className="flex flex-col gap-5 md:flex-row md:items-start md:justify-between">
          <div className="max-w-4xl">
            <h2 className="font-display text-3xl font-black leading-tight text-brand-dark sm:text-4xl md:text-5xl lg:text-6xl">
              {product.name}
            </h2>
            {productDescription ? (
              <p className="mt-4 max-w-2xl text-base leading-7 text-muted-foreground">
                {productDescription}
              </p>
            ) : null}
          </div>
          <Link
            to="/contact"
            className="inline-flex w-fit shrink-0 items-center gap-3 rounded-lg border border-border bg-white px-5 py-3 font-bold text-brand-dark shadow-soft transition hover:border-brand-red hover:text-brand-red"
          >
            Order Details <ArrowRight className="h-5 w-5" />
          </Link>
        </div>

        {mainImageUrl ? (
          <div className="mt-10 overflow-hidden rounded-lg border border-border bg-white shadow-soft">
            <img src={assetUrl(mainImageUrl)} alt={product.name} className="h-auto w-full object-cover" />
          </div>
        ) : null}

        {detailImages.filter((image) => image.image_url && !failedDetailImages.has(image.image_url)).length ? (
          <div className="mt-10 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {detailImages
              .filter((image) => image.image_url && !failedDetailImages.has(image.image_url))
              .map((image, index) => (
                <div
                  key={image.id ?? `${image.image_url}-${index}`}
                  className="overflow-hidden rounded-lg border border-border bg-white shadow-soft"
                >
                  <img
                    src={assetUrl(image.image_url)}
                    alt={image.alt_text || product.name}
                    className="aspect-[4/3] w-full object-cover transition duration-700 hover:scale-105"
                    loading="lazy"
                    onError={() => {
                      if (!image.image_url) return;
                      setFailedDetailImages((current) => new Set(current).add(image.image_url || ""));
                    }}
                  />
                </div>
              ))}
          </div>
        ) : null}

        {variants.length ? (
          <div className="mt-12 grid gap-8 sm:grid-cols-2 lg:grid-cols-4">
          {variants.map((variant) => {
            const title = `${variant.label} ${product.name}`;
            const message = `Hi, I want to enquire about ${title}.`;

            return (
              <article
                key={variant.label}
                className="group flex h-full flex-col overflow-hidden rounded-xl border border-border bg-white p-3 shadow-soft transition hover:-translate-y-1 hover:border-brand-red hover:shadow-xl"
              >
                <div
                  className={`relative aspect-[1.08] overflow-hidden rounded-lg border border-border bg-gradient-to-br ${variant.colors}`}
                >
                  {variant.image_url && !failedVariantImages.has(variant.image_url) ? (
                    <img
                      src={assetUrl(variant.image_url)}
                      alt={variant.label}
                      className="absolute inset-0 h-full w-full object-cover transition duration-700 group-hover:scale-105"
                      onError={() => {
                        if (!variant.image_url) return;
                        setFailedVariantImages((current) => new Set(current).add(variant.image_url || ""));
                      }}
                    />
                  ) : (
                    <>
                      <div className="absolute left-6 top-6 h-14 w-14 rounded-full bg-brand-yellow/70 blur-2xl" />
                      <div className="absolute bottom-0 right-0 h-28 w-28 rounded-tl-full bg-brand-red/10" />
                      <div className="absolute inset-6 flex flex-col items-center justify-center rounded-lg border border-white/80 bg-white/55 p-5 text-center">
                        <div className="grid h-20 w-20 place-items-center rounded-2xl gradient-brand text-white shadow-brand transition group-hover:scale-105">
                          <PackageCheck className="h-9 w-9" />
                        </div>
                        <div className="mt-4 font-display text-xl font-black text-brand-dark">
                          {variant.label}
                        </div>
                        <p className="mt-2 text-xs font-medium text-muted-foreground">
                          {variant.detail}
                        </p>
                      </div>
                    </>
                  )}
                </div>

                <div className="flex flex-1 flex-col px-1 pb-1 pt-4">
                  <div className="min-h-[3.25rem] min-w-0">
                    <h3 className="break-words font-display text-lg font-extrabold leading-snug text-brand-dark sm:text-xl">
                      {variant.label}
                    </h3>
                  </div>
                  <a
                    href={`https://wa.me/${contact.whatsapp}?text=${encodeURIComponent(message)}`}
                    className="mt-auto inline-flex w-full items-center justify-center gap-2 rounded-lg gradient-brand px-4 py-2.5 text-sm font-bold text-white shadow-brand transition hover:scale-[1.02]"
                  >
                    Enquire <WhatsAppIcon className="h-4 w-4" />
                  </a>
                </div>
              </article>
            );
          })}
          </div>
        ) : null}
      </section>
    </div>
  );
}
