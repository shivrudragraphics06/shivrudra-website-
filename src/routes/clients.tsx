import { PageHero } from "@/components/PageHero";
import clientLogosBoard from "@/assets/client-logos-board.png";

export function ClientsPage() {
  return (
    <div className="bg-white">
      <PageHero
        title="Our Clients"
        subtitle="Trusted by leading businesses, institutions and growing brands."
        breadcrumb={[{ label: "Clients" }]}
      />
      <section className="py-8 sm:py-10">
        <div className="container-page max-w-[1180px]">
          <img
            src={clientLogosBoard}
            alt="Shivrudra Graphics client logos"
            className="mx-auto block w-full max-w-[1120px] object-contain"
          />
        </div>
      </section>
    </div>
  );
}
