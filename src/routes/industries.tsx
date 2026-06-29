import { PageHero } from "@/components/PageHero";
import industriesBoard from "@/assets/industries1.png";
import industriesBoardTwo from "@/assets/industries2.png";

export function IndustriesPage() {
  return (
    <div className="bg-white">
      <PageHero
        title="Industries We Serve"
        subtitle="A creative partner trusted across sectors for branding, printing and signage solutions."
        breadcrumb={[{ label: "Industries" }]}
      />
      <section className="px-4 py-6 sm:py-8">
        <div className="mx-auto flex max-w-[1180px] flex-col items-center gap-6">
          <img
            src={industriesBoard}
            alt="Industries We Serve"
            className="block w-full object-contain"
          />
          <img
            src={industriesBoardTwo}
            alt="More industries we serve"
            className="block w-[94.88%] max-w-[1120px] object-contain"
          />
        </div>
      </section>
    </div>
  );
}
