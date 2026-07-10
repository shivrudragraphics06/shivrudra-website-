import { PageHero } from "@/components/PageHero";
import { SERVICES, CONTACT } from "@/data/site";
import { ArrowRight, CheckCircle2, Phone } from "lucide-react";
import { toProductSlug } from "@/lib/products";
import { Link } from "@/components/AppLink";
import { WhatsAppIcon } from "@/components/WhatsAppIcon";
import { useEffect, useState } from "react";
import { fetchPublicServices, type PublicService } from "@/lib/public-content";
import { assetUrl } from "@/lib/api";

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
  const [services, setServices] = useState<PublicService[]>(SERVICES);

  useEffect(() => {
    fetchPublicServices()
      .then((items) => {
        if (items.length) setServices(items);
      })
      .catch(() => {});
  }, []);

  const svc = services.find((s) => s.slug === slug);
  if (!svc) return <ServiceNotFound />;

  const others = services.filter((s) => s.slug !== svc.slug).slice(0, 6);
  const serviceImage = svc.image_url || svc.main_image_url;

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
          <div className="mt-8 grid sm:grid-cols-2 gap-3">
            {(svc.subs ?? []).map((sub: string) => {
              const content = (
                <>
                  <CheckCircle2 className="h-5 w-5 text-brand-red mt-0.5 shrink-0" />
                  <div className="font-medium text-sm">{sub}</div>
                  <ArrowRight className="ml-auto h-4 w-4 text-brand-red" />
                </>
              );

              return sub === "Logo Design" ? (
                <Link
                  key={sub}
                  to="/logo-design"
                  className="flex items-start gap-3 p-4 rounded-xl bg-white border border-border hover:border-brand-red transition"
                >
                  {content}
                </Link>
              ) : (
                <Link
                  key={sub}
                  to="/products/$productSlug"
                  params={{
                    productSlug:
                      svc.products?.find((product) => product.name === sub)?.slug ?? toProductSlug(sub),
                  }}
                  className="flex items-start gap-3 p-4 rounded-xl bg-white border border-border hover:border-brand-red transition"
                >
                  {content}
                </Link>
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
              href={`https://wa.me/${CONTACT.whatsapp}?text=Hi,%20I%20need%20a%20quote%20for%20${encodeURIComponent(svc.name)}`}
              className="mt-4 inline-flex items-center gap-2 rounded-full bg-white text-brand-red px-4 py-2.5 font-bold text-sm"
            >
              <WhatsAppIcon className="h-4 w-4" /> WhatsApp Quote
            </a>
            <a
              href={`tel:${CONTACT.phones[0].replace(/\s/g, "")}`}
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
