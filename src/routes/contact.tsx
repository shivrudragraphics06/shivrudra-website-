import { useState } from "react";
import { PageHero } from "@/components/PageHero";
import { Phone, Mail, MapPin, Send, Upload, CheckCircle2 } from "lucide-react";
import { WhatsAppIcon } from "@/components/WhatsAppIcon";
import { usePublicContact, usePublicServices } from "@/hooks/use-public-data";
import { submitPublicInquiry } from "@/lib/public-content";

export function ContactPage() {
  const [sent, setSent] = useState(false);
  const [error, setError] = useState("");
  const services = usePublicServices();
  const contact = usePublicContact();
  const mapSrc = `https://www.google.com/maps?q=${encodeURIComponent(contact.address)}&output=embed`;
  const [form, setForm] = useState({
    name: "",
    mobile: "",
    email: "",
    business: "",
    service: "",
    message: "",
  });

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError("");

    try {
      await submitPublicInquiry(form);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Could not save your inquiry. Please try again.");
      return;
    }

    const text = encodeURIComponent(
      `Name: ${form.name}\nMobile: ${form.mobile}\nEmail: ${form.email}\nBusiness: ${form.business}\nService: ${form.service}\nMessage: ${form.message}`,
    );
    window.open(`https://wa.me/${contact.whatsapp}?text=${text}`, "_blank");
    setSent(true);
  }

  return (
    <div>
      <PageHero
        title="Let's work together"
        subtitle="Tell us about your project - our team will connect with you to bring your ideas to print."
        breadcrumb={[{ label: "Contact" }]}
      />
      <section className="py-16 container-page grid lg:grid-cols-[1.3fr_1fr] gap-10">
        <div className="p-6 md:p-10 rounded-3xl bg-white border border-border shadow-soft">
          <h2 className="font-display font-black text-2xl">Request a quote</h2>
          <p className="text-sm text-muted-foreground mt-1">
            Fill out the form — we'll respond on WhatsApp or email.
          </p>

          {sent ? (
            <div className="mt-6 p-6 rounded-2xl bg-brand-light flex items-center gap-3">
              <CheckCircle2 className="h-6 w-6 text-brand-red" />
              <div>
                <div className="font-display font-bold">Thanks! Opening WhatsApp…</div>
                <div className="text-xs text-muted-foreground">
                  Your details are being shared with our team.
                </div>
              </div>
            </div>
          ) : (
            <form className="mt-6 grid sm:grid-cols-2 gap-4" onSubmit={handleSubmit}>
              {error && (
                <div className="sm:col-span-2 rounded-xl border border-brand-red/30 bg-brand-red/5 px-4 py-3 text-sm font-semibold text-brand-red">
                  {error}
                </div>
              )}
              <Field
                label="Name"
                value={form.name}
                onChange={(v) => setForm({ ...form, name: v })}
                required
              />
              <Field
                label="Mobile Number"
                type="tel"
                value={form.mobile}
                onChange={(v) => setForm({ ...form, mobile: v })}
                required
              />
              <Field
                label="Email"
                type="email"
                value={form.email}
                onChange={(v) => setForm({ ...form, email: v })}
              />
              <Field
                label="Business Name"
                value={form.business}
                onChange={(v) => setForm({ ...form, business: v })}
              />
              <div className="sm:col-span-2">
                <label className="text-xs font-bold text-brand-dark uppercase tracking-wider">
                  Service Required
                </label>
                <select
                  value={form.service}
                  onChange={(e) => setForm({ ...form, service: e.target.value })}
                  className="mt-1.5 w-full px-4 py-3 rounded-xl border border-border bg-white focus:border-brand-red outline-none transition"
                >
                  <option value="">Select a service…</option>
                  {services.map((s) => (
                    <option key={s.slug} value={s.name}>
                      {s.name}
                    </option>
                  ))}
                </select>
              </div>
              <div className="sm:col-span-2">
                <label className="text-xs font-bold text-brand-dark uppercase tracking-wider">
                  Message
                </label>
                <textarea
                  value={form.message}
                  onChange={(e) => setForm({ ...form, message: e.target.value })}
                  rows={4}
                  className="mt-1.5 w-full px-4 py-3 rounded-xl border border-border bg-white focus:border-brand-red outline-none transition"
                  placeholder="Tell us about your requirement…"
                />
              </div>
              <div className="sm:col-span-2">
                <label className="flex items-center gap-2 px-4 py-3 rounded-xl border border-dashed border-border hover:border-brand-red cursor-pointer text-sm text-muted-foreground">
                  <Upload className="h-4 w-4" /> Upload reference file (optional)
                  <input type="file" className="hidden" />
                </label>
              </div>
              <button
                type="submit"
                className="sm:col-span-2 inline-flex items-center justify-center gap-2 rounded-full gradient-brand text-white px-6 py-3.5 font-bold shadow-brand hover:scale-[1.02] transition"
              >
                <Send className="h-4 w-4" /> Submit & Open WhatsApp
              </button>
            </form>
          )}
        </div>

        <div className="space-y-4">
          <div className="p-6 rounded-2xl bg-brand-dark text-white">
            <div className="font-display font-black text-xl">Contact Info</div>
            <div className="mt-4 space-y-3 text-sm">
              <a
                href={`tel:${(contact.phones[0] || "").replace(/\s/g, "")}`}
                className="flex items-start gap-3 hover:text-brand-yellow"
              >
                <Phone className="h-4 w-4 mt-0.5 text-brand-red" />
                <div>
                  {contact.phones.map((p) => (
                    <div key={p}>{p}</div>
                  ))}
                </div>
              </a>
              <a
                href={`mailto:${contact.email}`}
                className="flex items-center gap-3 hover:text-brand-yellow"
              >
                <Mail className="h-4 w-4 text-brand-red" /> {contact.email}
              </a>
              <div className="flex items-start gap-3">
                <MapPin className="h-4 w-4 mt-0.5 text-brand-red" /> {contact.address}
              </div>
            </div>
            <a
              href={`https://wa.me/${contact.whatsapp}`}
              className="mt-5 inline-flex w-full items-center justify-center gap-2 rounded-full bg-[#25D366] px-4 py-2.5 font-semibold"
            >
              <WhatsAppIcon className="h-4 w-4" /> WhatsApp Us
            </a>
          </div>

          <div className="overflow-hidden rounded-2xl border border-border bg-white">
            <iframe
              title="Shivrudra location"
              src={mapSrc}
              className="w-full h-64 border-0"
              loading="lazy"
            />
            <div className="p-4 text-sm">
              <div className="font-display font-bold">Visit us</div>
              <div className="text-muted-foreground text-xs mt-1">{contact.address}</div>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}

function Field({
  label,
  value,
  onChange,
  type = "text",
  required,
}: {
  label: string;
  value: string;
  onChange: (v: string) => void;
  type?: string;
  required?: boolean;
}) {
  return (
    <div>
      <label className="text-xs font-bold text-brand-dark uppercase tracking-wider">
        {label}
        {required && <span className="text-brand-red"> *</span>}
      </label>
      <input
        type={type}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        required={required}
        className="mt-1.5 w-full px-4 py-3 rounded-xl border border-border bg-white focus:border-brand-red outline-none transition"
      />
    </div>
  );
}
