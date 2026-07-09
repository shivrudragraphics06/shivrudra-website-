import {
  BadgeCheck,
  ArrowRight,
  Sparkles,
  Award,
  Truck,
  Users,
  CheckCircle2,
  Printer,
  Factory,
  Signpost,
  Star,
  Search,
  FileText,
  Palette,
  Wrench,
  MessageCircle,
} from "lucide-react";
import {
  PROCESS_STEPS,
  SERVICES,
  WHY_CHOOSE,
  TIMELINE,
  CONTACT,
  SITE_TAGLINE,
} from "@/data/site";
import { useEffect, useState } from "react";
import { Link } from "@/components/AppLink";
import { IndustriesGrid } from "@/components/IndustriesGrid";
import { ProductGallerySection } from "@/components/ProductGallerySection";
import heroMotionVideo from "@/assets/moving LEDdot pattern.mp4";
import { WhatsAppIcon } from "@/components/WhatsAppIcon";
import {
  fetchPublicServices,
  fetchPublicTestimonials,
  type PublicService,
  type PublicTestimonial,
} from "@/lib/public-content";

const TESTIMONIALS = [
  {
    name: "Rahul Jadhav",
    role: "Retail Store Owner",
    text: "Shivrudra Graphics delivered our store branding on time with excellent print quality. The team understood the requirement clearly and handled the installation neatly.",
  },
  {
    name: "Priya Kulkarni",
    role: "Marketing Manager",
    text: "We regularly work with them for banners, labels and signage. Their finishing, color output and response time have been very dependable.",
  },
  {
    name: "Amit Patil",
    role: "Business Owner",
    text: "From design to final print, the experience was smooth. The team suggested practical options and the final signage looked premium.",
  },
];

const PROCESS_ICONS = [
  Users,
  Search,
  FileText,
  Palette,
  Printer,
  Factory,
  Wrench,
  Truck,
  Signpost,
  MessageCircle,
];

const PROCESS_STRIP_POINTS = [
  { left: "5%", top: "36px" },
  { left: "15%", top: "52px" },
  { left: "25%", top: "48px" },
  { left: "35%", top: "36px" },
  { left: "45%", top: "51px" },
  { left: "55%", top: "78px" },
  { left: "65%", top: "71px" },
  { left: "75%", top: "42px" },
  { left: "85%", top: "33px" },
  { left: "95%", top: "18px" },
];

export function HomePage() {
  const [services, setServices] = useState<PublicService[]>(SERVICES);
  const [testimonials, setTestimonials] = useState<PublicTestimonial[]>(TESTIMONIALS);

  useEffect(() => {
    fetchPublicServices()
      .then((items) => {
        if (items.length) setServices(items);
      })
      .catch(() => {});

    fetchPublicTestimonials()
      .then((items) => {
        if (items.length) setTestimonials(items);
      })
      .catch(() => {});
  }, []);

  return (
    <div>
      {/* HERO */}
      <section className="relative overflow-hidden bg-[#fff4d5]">
        <div className="relative min-h-[620px] md:min-h-[560px] xl:min-h-[640px]">
          <video
            className="absolute inset-0 h-full w-full object-cover object-left"
            autoPlay
            muted
            loop
            playsInline
            preload="metadata"
          >
            <source src={heroMotionVideo} type="video/mp4" />
          </video>

          <div className="relative flex min-h-[620px] w-full items-center justify-center px-4 py-14 sm:px-8 md:min-h-[560px] md:px-7 md:py-16 lg:px-8 xl:min-h-[640px] xl:px-10 2xl:px-12">
            <div className="w-full max-w-5xl animate-fade-up text-center">
              <div className="flex flex-wrap items-center justify-center gap-3 text-2xl font-bold sm:text-3xl md:text-4xl">
                <span className="text-brand-red">Designing</span>
                <span className="text-brand-dark/40">|</span>
                <span className="text-brand-red">Printing</span>
                <span className="text-brand-dark/40">|</span>
                <span className="text-brand-red">Branding</span>
              </div>
              <p className="mx-auto mt-5 max-w-5xl text-xl font-medium leading-relaxed text-brand-dark/80 md:text-2xl">
                {SITE_TAGLINE}.
              </p>
              <div className="mt-8 flex flex-wrap justify-center gap-3">
                <Link
                  to="/services"
                  className="inline-flex items-center gap-2 rounded-full gradient-brand px-7 py-4 text-lg font-semibold text-white shadow-brand transition hover:scale-105"
                >
                  Explore Services <ArrowRight className="h-5 w-5" />
                </Link>
                <a
                  href={`https://wa.me/${CONTACT.whatsapp}`}
                  className="inline-flex items-center gap-2 rounded-full bg-[#25D366] px-7 py-4 text-lg font-semibold text-white shadow-soft transition hover:scale-105"
                >
                  <WhatsAppIcon className="h-5 w-5" /> Get Quote
                </a>
              </div>
            </div>
          </div>
        </div>
        {/* Marquee */}
        <div className="border-y border-border bg-brand-dark text-white py-3 overflow-hidden">
          <div className="flex gap-12 animate-marquee whitespace-nowrap">
            {[...Array(2)].map((_, i) => (
              <div key={i} className="flex gap-12 shrink-0">
                {[
                  "Commercial Printing",
                  "LED Sign Boards",
                  "Vehicle Branding",
                  "Corporate Gifts",
                  "Industrial Name Plates",
                  "Safety Signages",
                  "Offset Printing",
                  "UV Printing",
                  "Vinyl Branding",
                ].map((t) => (
                  <span key={t} className="flex items-center gap-2 text-sm font-semibold">
                    <Sparkles className="h-4 w-4 text-brand-yellow" /> {t}
                  </span>
                ))}
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* SERVICES */}
      <section className="relative overflow-hidden bg-white py-14 md:py-16">
        <div className="container-page relative">
          <div className="flex flex-col gap-6 md:flex-row md:items-end md:justify-between">
            <div className="max-w-2xl">
              <div className="text-xs font-bold uppercase tracking-widest text-brand-red">
                All Services
              </div>
              <h2 className="mt-2 font-display text-3xl font-black text-brand-dark md:text-4xl">
                Our Complete Service Range
              </h2>
              <p className="mt-3 leading-relaxed text-muted-foreground">
                Professional printing, signage, branding and industrial solutions for every
                business need.
              </p>
            </div>
            <Link
              to="/services"
              className="inline-flex w-fit items-center gap-2 rounded-full gradient-brand px-5 py-3 text-sm font-bold text-white shadow-brand transition hover:scale-105"
            >
              View service page <ArrowRight className="h-4 w-4" />
            </Link>
          </div>

          <div className="mt-9 overflow-hidden rounded-2xl border border-border bg-brand-light/70">
            <div className="grid divide-y divide-border md:grid-cols-3 md:divide-x md:divide-y-0">
              {[
                services.filter((_, index) => index % 3 === 0),
                services.filter((_, index) => index % 3 === 1),
                services.filter((_, index) => index % 3 === 2),
              ].map((column, columnIndex) => (
                <div key={columnIndex} className="divide-y divide-border">
                  {column.map((service) => {
                    const index = services.findIndex((item) => item.slug === service.slug);

                    return (
                      <Link
                        key={service.slug}
                        to="/services/$slug"
                        params={{ slug: service.slug }}
                        className="group flex min-h-16 items-center gap-3 bg-white/70 px-4 py-3.5 transition hover:bg-white"
                      >
                        <span className="text-xs font-black text-brand-red/70">
                          {String(index + 1).padStart(2, "0")}
                        </span>
                        <h3 className="min-w-0 flex-1 font-display text-[15px] font-extrabold leading-snug text-brand-dark transition group-hover:text-brand-red">
                          {service.name}
                        </h3>
                        <ArrowRight className="h-4 w-4 shrink-0 text-brand-red opacity-60 transition group-hover:translate-x-1 group-hover:opacity-100" />
                      </Link>
                    );
                  })}
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* ABOUT */}
      <section className="py-20 bg-brand-light">
        <div className="container-page grid lg:grid-cols-2 gap-12 items-center">
          <div>
            <div className="text-xs font-bold tracking-widest text-brand-red uppercase">
              About Shivrudra
            </div>
            <h2 className="mt-2 font-display font-black text-3xl md:text-4xl">
              A printing & signage partner you can trust
            </h2>
            <p className="mt-5 text-muted-foreground leading-relaxed">
              Shivrudra Graphics Pvt Ltd was originally founded in 2014 at Kesnand & Kolwadi and is
              now situated in Pune, Maharashtra. The company specializes in {SITE_TAGLINE},
              Designing, Printing, Branding and In-Shop Branding Solutions.
            </p>
            <p className="mt-3 text-muted-foreground leading-relaxed">
              We provide complete signage solutions from concept and design to manufacturing and
              installation — with optimum quality, competitive pricing and total customer
              satisfaction.
            </p>
            <div className="mt-6 inline-flex items-center gap-2 rounded-full bg-brand-yellow/40 border border-brand-yellow px-4 py-2 text-sm font-bold">
              <BadgeCheck className="h-4 w-4 text-brand-red" /> ISO 9001:2015 Certified Company
            </div>

            <div className="mt-6 grid grid-cols-2 gap-3">
              {[
                { n: "Aadesh C. Nimbalkar", r: "Director" },
                { n: "Akshay N. Kalbhor", r: "Director" },
              ].map((d) => (
                <div key={d.n} className="p-4 rounded-xl bg-white border border-border">
                  <div className="text-xs text-brand-red font-bold">{d.r}</div>
                  <div className="font-display font-bold mt-1">{d.n}</div>
                </div>
              ))}
            </div>
            <Link
              to="/about"
              className="mt-6 inline-flex items-center gap-2 font-semibold text-brand-red"
            >
              Read more about us <ArrowRight className="h-4 w-4" />
            </Link>
          </div>

          <div className="grid grid-cols-2 gap-4">
            {[
              { i: Users, t: "Skilled Team", d: "Experienced professionals" },
              { i: Award, t: "Premium Quality", d: "Best in class output" },
              { i: Truck, t: "On-Time Delivery", d: "Reliable timelines" },
              { i: Sparkles, t: "Creative Edge", d: "Unique design approach" },
            ].map((b) => (
              <div
                key={b.t}
                className="p-6 rounded-2xl bg-white border border-border shadow-soft hover:border-brand-red transition"
              >
                <div className="grid h-12 w-12 place-items-center rounded-xl gradient-accent">
                  <b.i className="h-5 w-5 text-brand-dark" />
                </div>
                <div className="mt-4 font-display font-bold">{b.t}</div>
                <div className="text-xs text-muted-foreground mt-1">{b.d}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* VISION MISSION VALUES */}
      <section className="py-20">
        <div className="container-page">
          <SectionHeader eyebrow="Our Principles" title="Vision, Mission & Values" />
          <div className="mt-12 grid md:grid-cols-3 gap-6">
            {[
              {
                t: "Vision",
                d: "To provide all types of graphics solutions to increase the growth of clients and build inclusive partnerships based on trust and mutual respect.",
              },
              {
                t: "Mission",
                d: "To become the most valued business partner for clients and help them grow their business.",
              },
              {
                t: "Values",
                d: "Integrity, Innovation, Teamwork, Environment-Friendly Approach, Respect for People.",
              },
            ].map((v, i) => (
              <div
                key={v.t}
                className="group relative overflow-hidden rounded-2xl border border-border bg-white p-8 shadow-soft transition hover:border-transparent hover:gradient-brand hover:text-white"
              >
                <div className="text-xs font-bold tracking-widest text-brand-red uppercase transition group-hover:text-brand-yellow">
                  0{i + 1}
                </div>
                <h3 className="mt-2 font-display font-black text-2xl">{v.t}</h3>
                <p className="mt-4 text-sm leading-relaxed text-muted-foreground transition group-hover:text-white/90">
                  {v.d}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* TIMELINE */}
      <section className="py-20 bg-brand-dark text-white relative overflow-hidden">
        <div className="absolute top-0 right-0 h-96 w-96 bg-brand-red/20 blur-3xl rounded-full" />
        <div className="container-page relative">
          <SectionHeader
            eyebrow="Our Journey"
            title="From a passion project to a Pvt Ltd company"
            light
          />
          <div className="mt-14 grid md:grid-cols-4 gap-6 relative">
            {TIMELINE.map((t, i) => (
              <div key={t.year} className="relative">
                <div className="text-brand-yellow font-display font-black text-4xl">{t.year}</div>
                <div className="my-3 h-1 w-12 bg-brand-red rounded-full" />
                <div className="font-display font-bold text-lg">{t.title}</div>
                <p className="mt-2 text-sm text-white/70">{t.desc}</p>
                {i < TIMELINE.length - 1 && (
                  <svg
                    className="pointer-events-none absolute left-[7.5rem] top-4 hidden h-8 w-[calc(100%+1.5rem-8.5rem)] text-white md:block"
                    viewBox="0 0 260 32"
                    preserveAspectRatio="none"
                    aria-hidden="true"
                  >
                    <path
                      d="M2 17 C38 17 42 9 76 16 S126 17 156 13 S204 18 258 15"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="4"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeDasharray="10 16"
                    />
                  </svg>
                )}
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* WHY CHOOSE */}
      <section className="py-20">
        <div className="container-page">
          <SectionHeader
            eyebrow="Why Shivrudra"
            title="Why clients choose us as their trusted partner"
          />
          <div className="mt-12 grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {WHY_CHOOSE.map((w, i) => (
              <div
                key={w}
                className="flex items-start gap-3 p-5 rounded-xl bg-white border border-border hover:border-brand-red hover:shadow-soft transition"
              >
                <div className="grid h-9 w-9 shrink-0 place-items-center rounded-full gradient-brand text-white text-sm font-bold">
                  {i + 1}
                </div>
                <div className="font-semibold text-sm">{w}</div>
                <CheckCircle2 className="ml-auto h-5 w-5 text-brand-red shrink-0" />
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* PROCESS */}
      <section className="relative overflow-hidden bg-brand-light pb-10 pt-20">
        <div className="absolute left-0 top-20 h-72 w-72 -translate-x-1/2 rounded-full bg-brand-yellow/20 blur-3xl" />
        <div className="absolute bottom-10 right-0 h-80 w-80 translate-x-1/3 rounded-full bg-brand-red/10 blur-3xl" />
        <div className="container-page relative">
          <SectionHeader
            eyebrow="Work Process"
            title="A streamlined 10-step journey"
            desc="From the first call to final installation, here's how we deliver."
          />

          <div className="relative left-1/2 mt-14 hidden w-screen -translate-x-1/2 overflow-x-auto overflow-y-hidden md:block">
            <div className="relative min-w-[1280px] px-6 pb-2 pt-4 lg:px-10">
              <div className="absolute left-0 top-6 h-36 w-36 rounded-full bg-brand-yellow/15 blur-3xl" />
              <div className="absolute bottom-4 right-0 h-40 w-40 rounded-full bg-brand-red/10 blur-3xl" />
              <div className="relative mx-auto h-[270px] max-w-[1800px]">
                <svg
                  className="pointer-events-none absolute inset-x-0 top-2 h-32 w-full text-brand-red/40"
                  viewBox="0 0 1200 140"
                  preserveAspectRatio="none"
                  aria-hidden="true"
                >
                  <path
                    d="M0 42 C95 62 165 78 260 72 S418 36 545 73 S710 117 840 76 S1030 72 1200 18"
                    fill="none"
                    stroke="currentColor"
                    strokeWidth="6"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeDasharray="8 18"
                  />
                </svg>

                {PROCESS_STEPS.map((s, i) => {
                  const Icon = PROCESS_ICONS[i];

                  return (
                    <div
                      key={s}
                      className="absolute w-[7.25rem] -translate-x-1/2 text-center"
                      style={PROCESS_STRIP_POINTS[i]}
                    >
                      <div className="mx-auto grid h-11 w-11 place-items-center rounded-full border-4 border-white gradient-brand text-white shadow-brand">
                        <Icon className="h-4 w-4" />
                      </div>
                      <div className="mt-5 rounded-xl border border-border bg-white px-3 py-4 text-brand-dark shadow-soft">
                        <div className="font-display text-2xl font-black text-brand-red">
                          {String(i + 1).padStart(2, "0")}
                        </div>
                        <div className="mt-1 text-sm font-bold">{s}</div>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          </div>

          <div className="mt-12 grid gap-4 sm:grid-cols-2 md:hidden">
            {PROCESS_STEPS.map((s, i) => (
              <div
                key={s}
                className="relative flex items-center gap-4 rounded-xl border border-border bg-white p-4 shadow-soft"
              >
                <div className="grid h-12 w-12 shrink-0 place-items-center rounded-full gradient-accent text-brand-dark">
                  {(() => {
                    const Icon = PROCESS_ICONS[i];
                    return <Icon className="h-5 w-5" />;
                  })()}
                </div>
                <div>
                  <div className="font-display text-lg font-black text-brand-red">
                    {String(i + 1).padStart(2, "0")}
                  </div>
                  <div className="font-semibold text-sm">{s}</div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* INDUSTRIES */}
      <section className="relative overflow-hidden bg-white pb-10 pt-12">
        <div className="container-page">
          <SectionHeader
            eyebrow="Industries We Serve"
            title="Trusted by brands across industries"
            desc="A creative partner trusted across sectors."
          />
          <div className="mt-12">
            <IndustriesGrid />
          </div>
          <div className="text-center mt-8">
            <Link
              to="/industries"
              className="font-semibold text-brand-red inline-flex items-center gap-2"
            >
              See full list <ArrowRight className="h-4 w-4" />
            </Link>
          </div>
        </div>
      </section>

      <ProductGallerySection limit={8} compactTop />

      {/* TESTIMONIALS */}
      <section className="bg-brand-light py-16">
        <div className="container-page">
          <SectionHeader
            eyebrow="Testimonials"
            title="What our clients say"
            desc="Feedback from businesses who trust us for printing, branding and signage."
          />
          <div className="mt-10 grid gap-5 md:grid-cols-3">
            {testimonials.map((item) => (
              <div
                key={item.id ?? item.name ?? item.client_name}
                className="rounded-2xl border border-border bg-white p-6 shadow-soft transition hover:-translate-y-1 hover:border-brand-red"
              >
                <div className="flex gap-1 text-brand-yellow">
                  {[...Array(item.rating || 5)].map((_, index) => (
                    <Star key={index} className="h-4 w-4 fill-current" />
                  ))}
                </div>
                <p className="mt-5 text-sm leading-relaxed text-muted-foreground">
                  "{item.text || item.message}"
                </p>
                <div className="mt-6 border-t border-border pt-4">
                  <div className="font-display font-bold text-brand-dark">
                    {item.name || item.client_name}
                  </div>
                  <div className="mt-1 text-xs font-semibold uppercase tracking-wider text-brand-red">
                    {item.role || item.client_role || item.company}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="py-6 sm:py-8">
        <div className="container-page">
          <div className="relative overflow-hidden rounded-3xl gradient-brand text-white p-8 md:p-12 text-center shadow-brand">
            <div
              className="absolute top-0 left-0 h-full w-full opacity-10"
              style={{
                backgroundImage: "radial-gradient(circle, white 1px, transparent 1px)",
                backgroundSize: "30px 30px",
              }}
            />
            <div className="relative">
              <div className="inline-flex items-center gap-2 rounded-full bg-white/20 px-3 py-1.5 text-xs font-bold mb-5">
                <BadgeCheck className="h-4 w-4 text-brand-yellow" /> ISO 9001:2015 Certified
              </div>
              <h2 className="font-display font-black text-3xl md:text-5xl max-w-3xl mx-auto">
                Let's create something great
              </h2>
              <p className="mt-4 text-white/90 max-w-xl mx-auto">
                Tell us about your project - our team will connect with you to bring your ideas to
                print.
              </p>
              <div className="mt-8 flex flex-wrap justify-center gap-3">
                <Link
                  to="/contact"
                  className="inline-flex items-center gap-2 rounded-full bg-white text-brand-red px-6 py-3.5 font-bold shadow-soft hover:scale-105 transition"
                >
                  Get a Quote <ArrowRight className="h-4 w-4" />
                </Link>
                <a
                  href={`https://wa.me/${CONTACT.whatsapp}`}
                  className="inline-flex items-center gap-2 rounded-full bg-brand-yellow text-brand-dark px-6 py-3.5 font-bold shadow-soft hover:scale-105 transition"
                >
                  <WhatsAppIcon className="h-4 w-4" /> Chat on WhatsApp
                </a>
              </div>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}

function SectionHeader({
  eyebrow,
  title,
  desc,
  light,
}: {
  eyebrow: string;
  title: string;
  desc?: string;
  light?: boolean;
}) {
  return (
    <div className="text-center max-w-2xl mx-auto">
      <div
        className={`text-xs font-bold tracking-widest uppercase ${light ? "text-brand-yellow" : "text-brand-red"}`}
      >
        {eyebrow}
      </div>
      <h2
        className={`mt-2 font-display font-black text-3xl md:text-4xl ${light ? "text-white" : "text-brand-dark"}`}
      >
        {title}
      </h2>
      {desc && (
        <p className={`mt-3 ${light ? "text-white/70" : "text-muted-foreground"}`}>{desc}</p>
      )}
    </div>
  );
}
