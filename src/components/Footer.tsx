import {
  Phone,
  Mail,
  MapPin,
  BadgeCheck,
  Facebook,
  Instagram,
  Youtube,
} from "lucide-react";
import { SITE_TAGLINE } from "@/data/site";
import logoUrl from "@/assets/logo.png";
import { WhatsAppIcon } from "@/components/WhatsAppIcon";
import { usePublicContact } from "@/hooks/use-public-data";

const SOCIAL_LINKS = [
  {
    label: "Facebook",
    href: "https://www.facebook.com/share/1cJ29VxfuT/",
    icon: Facebook,
  },
  {
    label: "Instagram",
    href: "https://www.instagram.com/_shivrudra_graphics_pvt_ltd?igsh=cHoxN3cyNzNoa3Y1",
    icon: Instagram,
  },
  {
    label: "YouTube",
    href: "https://youtube.com/@shivrudragraphics-v1p?si=AhbSkn1alUbWg7QC",
    icon: Youtube,
  },
];

export function Footer() {
  const contact = usePublicContact();

  return (
    <footer className="mt-20 bg-brand-dark text-white">
      <div className="container-page grid gap-10 py-12 md:grid-cols-[minmax(0,1.15fr)_minmax(280px,0.85fr)] md:items-start lg:gap-16">
        <div className="max-w-xl">
          <div className="flex items-center gap-3 mb-4">
            <img
              src={logoUrl}
              alt="Shivrudra Graphics Pvt Ltd logo"
              className="h-12 w-12 shrink-0 rounded-xl bg-white object-contain p-1"
            />
            <div>
              <div className="font-display font-extrabold">Shivrudra Graphics</div>
              <div className="text-xs text-white/70">Pvt Ltd</div>
            </div>
          </div>
          <p className="text-sm text-white/70 leading-relaxed mb-4">{SITE_TAGLINE}.</p>
          <div className="inline-flex items-center gap-2 rounded-full bg-white/10 px-3 py-1.5 text-xs font-semibold">
            <BadgeCheck className="h-4 w-4 text-brand-yellow" /> ISO 9001:2015 Certified
          </div>
        </div>

        <div className="max-w-lg md:justify-self-end">
          <h4 className="font-display font-bold mb-4 text-brand-yellow">Contact</h4>
          <ul className="space-y-3 text-sm text-white/80">
            <li className="flex items-start gap-2">
              <MapPin className="h-4 w-4 mt-0.5 text-brand-red shrink-0" />
              {contact.address}
            </li>
            {contact.phones.map((p) => (
              <li key={p} className="flex items-center gap-2">
                <Phone className="h-4 w-4 text-brand-red shrink-0" />
                <a href={`tel:${p.replace(/\s/g, "")}`} className="hover:text-brand-yellow">
                  {p}
                </a>
              </li>
            ))}
            <li className="flex items-center gap-2">
              <Mail className="h-4 w-4 text-brand-red shrink-0" />
              <a href={`mailto:${contact.email}`} className="hover:text-brand-yellow">
                {contact.email}
              </a>
            </li>
          </ul>
          <div className="mt-4 flex gap-3">
            <a
              href={`https://wa.me/${contact.whatsapp}`}
              aria-label="WhatsApp"
              className="grid h-9 w-9 place-items-center rounded-full bg-white/10 transition hover:bg-[#25D366]"
            >
              <WhatsAppIcon className="h-4 w-4" />
            </a>
            {SOCIAL_LINKS.map(({ label, href, icon: Icon }) => (
              <a
                key={label}
                href={href}
                aria-label={label}
                target="_blank"
                rel="noreferrer"
                className="grid h-9 w-9 place-items-center rounded-full bg-white/10 hover:bg-brand-red transition"
              >
                <Icon className="h-4 w-4" />
              </a>
            ))}
          </div>
        </div>
      </div>

      <div className="border-t border-white/10">
        <div className="container-page py-5 text-center text-xs text-white/60">
          <span>© 2026 All Rights Reserved By Shivrudra Graphics Pvt Ltd. & Developed By </span>
          <a
            href="https://webakoof.com"
            target="_blank"
            rel="noreferrer"
            className="font-semibold text-white hover:text-brand-yellow"
          >
            Webakoof
          </a>
        </div>
      </div>
    </footer>
  );
}
