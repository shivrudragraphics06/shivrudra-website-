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
  const serviceImage = svc.image_url || svc.main_image_url;
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

      <section className="py-16 container-page grid lg:grid-cols-[1.5fr_1fr] gap-10">
        <div>
          {serviceImage ? (
            <div className="mb-8 overflow-hidden rounded-2xl border border-border bg-brand-light shadow-soft">
              <img
                src={assetUrl(serviceImage)}
                alt={svc.name}
                className="aspect-[4/3] w-full object-cover"
              />
            </div>
          ) : null}
          <h2 className="font-display font-black text-2xl md:text-3xl">
            What we offer in {svc.name}
          </h2>
          <p className="mt-3 text-muted-foreground">
            Explore our full range of {svc.name.toLowerCase()} solutions. Each product is crafted
            with premium materials and delivered on time.
          </p>
          <div className="mt-8 grid gap-5 sm:grid-cols-2">
            {productCards.map((product) => {
              const message = `Hi, I want to enquire about ${product.name} in ${svc.name}.`;

              return (
                <article
                  key={`${product.id}-${product.name}`}
                  className="group overflow-hidden rounded-xl border border-border bg-white p-3 shadow-soft transition hover:-translate-y-1 hover:border-brand-red hover:shadow-xl"
                >
                  <div className="relative aspect-[4/3] overflow-hidden rounded-lg border border-border bg-brand-light">
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
                  <div className="space-y-3 px-1 pb-1 pt-4">
                    <div>
                      <h3 className="font-display text-lg font-extrabold leading-snug text-brand-dark sm:text-xl">
                        {product.name}
                      </h3>
                      {product.short_description ? (
                        <p className="mt-1 text-sm leading-6 text-muted-foreground">
                          {product.short_description}
                        </p>
                      ) : null}
                    </div>
                    <a
                      href={`https://wa.me/${contact.whatsapp}?text=${encodeURIComponent(message)}`}
                      target="_blank"
                      rel="noreferrer"
                      className="inline-flex w-full items-center justify-center gap-2 rounded-lg gradient-brand px-4 py-2.5 text-sm font-bold text-white shadow-brand transition hover:scale-[1.02]"
                    >
                      Enquire <WhatsAppIcon className="h-4 w-4" />
                    </a>
                  </div>
                </article>
              );
            })}
          </div>
        </div>

        <aside className="space-y-4">
          <div className="p-6 rounded-2xl gradient-brand text-white shadow-brand">
            <div className="font-display font-black text-xl">Need a quote?</div>
            <p className="mt-2 text-sm text-white/85">
              Get a tailored quote for your {svc.name.toLowerCase()} requirement.
            </p>
            <a
              href={`https://wa.me/${contact.whatsapp}?text=Hi,%20I%20need%20a%20quote%20for%20${encodeURIComponent(svc.name)}`}
              className="mt-4 inline-flex items-center gap-2 rounded-full bg-white text-brand-red px-4 py-2.5 font-bold text-sm"
            >
              <WhatsAppIcon className="h-4 w-4" /> WhatsApp Quote
            </a>
            <a
              href={`tel:${(contact.phones[0] || "").replace(/\s/g, "")}`}
              className="mt-2 inline-flex items-center gap-2 rounded-full bg-brand-yellow text-brand-dark px-4 py-2.5 font-bold text-sm ml-2"
            >
              <Phone className="h-4 w-4" /> Call Now
            </a>
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
