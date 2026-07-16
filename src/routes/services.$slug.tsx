import { PageHero } from "@/components/PageHero";
import { ArrowRight, PackageCheck, Phone } from "lucide-react";
import { Link } from "@/components/AppLink";
import { WhatsAppIcon } from "@/components/WhatsAppIcon";
import { assetUrl } from "@/lib/api";
import { usePublicContact, usePublicServices } from "@/hooks/use-public-data";

export function ServiceNotFound() {
  return (
    <div className="container-page py-24 text-center">
      <h1 className="font-display font-black text-3xl">Service not found</h1>
      <Link to="/services" className="text-brand-red mt-4 inline-block">
        Back to services
      </Link>
    </div>
  );
}

export function ServiceDetail({ slug }: { slug: string }) {
  const services = usePublicServices();
  const contact = usePublicContact();

  const svc = services.find((s) => s.slug === slug);
  if (!svc) return <ServiceNotFound />;

  const others = services.filter((s) => s.slug !== svc.slug).slice(0, 6);
  const productCards = svc.products?.length
    ? svc.products
    : (svc.subs ?? []).map((name, index) => ({
        id: index,
        name,
        slug: "",
        service_id: svc.id ?? 0,
        short_description: "",
        main_image_url: "",
      }));

  return (
    <div>
      <PageHero
        title={svc.name}
        subtitle={svc.blurb || svc.short_description || ""}
        breadcrumb={[{ label: "Services", to: "/services" }, { label: svc.name }]}
      />

      <section className="container-page py-16">
        <div>
          <h2 className="font-display font-black text-2xl md:text-3xl">
            What we offer in {svc.name}
          </h2>
          <p className="mt-3 text-muted-foreground">
            Explore our full range of {svc.name.toLowerCase()} solutions. Each product is crafted
            with premium materials and delivered on time.
          </p>
          <div className="mt-8 grid gap-6 sm:grid-cols-2 lg:grid-cols-3 2xl:grid-cols-4">
            {productCards.map((product) => {
              const message = `Hi, I want to enquire about ${product.name} in ${svc.name}.`;

              return (
                <article
                  key={`${product.id}-${product.name}`}
                  className="group flex h-full flex-col overflow-hidden rounded-xl border border-border bg-white p-4 shadow-soft transition hover:-translate-y-1 hover:border-brand-red hover:shadow-xl"
                >
                  <div className="relative aspect-[6/5] overflow-hidden rounded-lg border border-border bg-brand-light">
                    {product.main_image_url ? (
                      <img
                        src={assetUrl(product.main_image_url)}
                        alt={product.name}
                        className="h-full w-full object-cover transition duration-700 group-hover:scale-105"
                        loading="lazy"
                      />
                    ) : (
                      <div className="grid h-full place-items-center bg-gradient-to-br from-white via-[#f7f7f7] to-[#ffe9e9] text-brand-red">
                        <PackageCheck className="h-12 w-12" />
                      </div>
                    )}
                  </div>
                  <div className="flex flex-1 flex-col px-1 pb-1 pt-5">
                    <div className="min-h-[3.25rem]">
                      <h3 className="font-display text-xl font-extrabold leading-tight text-brand-dark sm:text-2xl lg:text-xl xl:text-[1.35rem]">
                        {product.name}
                      </h3>
                    </div>
                    <a
                      href={`https://wa.me/${contact.whatsapp}?text=${encodeURIComponent(message)}`}
                      target="_blank"
                      rel="noreferrer"
                      className="mt-6 inline-flex w-full items-center justify-center gap-2 rounded-lg border border-brand-red/15 bg-brand-red px-5 py-3 text-sm font-black text-white shadow-brand transition hover:scale-[1.02] hover:bg-brand-maroon"
                    >
                      Enquire Now
                      <span className="grid h-5 w-5 place-items-center rounded-full bg-white/18">
                        <WhatsAppIcon className="h-3.5 w-3.5" />
                      </span>
                    </a>
                  </div>
                </article>
              );
            })}
          </div>
        </div>

        <aside className="mt-12 grid items-start gap-4 lg:grid-cols-[0.9fr_1.1fr]">
          <div className="rounded-2xl gradient-brand p-6 text-white shadow-brand sm:p-8">
            <div className="font-display text-2xl font-black sm:text-3xl">Need a quote?</div>
            <p className="mt-3 text-base font-medium leading-7 text-white/90">
              Get a tailored quote for your {svc.name.toLowerCase()} requirement.
            </p>
            <div className="mt-5 flex flex-wrap gap-3">
              <a
                href={`https://wa.me/${contact.whatsapp}?text=Hi,%20I%20need%20a%20quote%20for%20${encodeURIComponent(svc.name)}`}
                className="inline-flex items-center gap-2 rounded-full bg-white px-5 py-3 text-base font-black text-brand-red"
              >
                <WhatsAppIcon className="h-4 w-4" /> WhatsApp Quote
              </a>
              <a
                href={`tel:${(contact.phones[0] || "").replace(/\s/g, "")}`}
                className="inline-flex items-center gap-2 rounded-full bg-brand-yellow px-5 py-3 text-base font-black text-brand-dark"
              >
                <Phone className="h-4 w-4" /> Call Now
              </a>
            </div>
          </div>

          <div className="p-6 rounded-2xl bg-white border border-border">
            <div className="font-display font-bold">Other Services</div>
            <div className="mt-3 space-y-1">
              {others.map((o) => (
                <Link
                  key={o.slug}
                  to="/services/$slug"
                  params={{ slug: o.slug }}
                  className="flex items-center justify-between py-2 px-3 rounded hover:bg-brand-light text-sm"
                >
                  <span>{o.name}</span>
                  <ArrowRight className="h-4 w-4 text-brand-red" />
                </Link>
              ))}
            </div>
          </div>
        </aside>
      </section>
    </div>
  );
}
