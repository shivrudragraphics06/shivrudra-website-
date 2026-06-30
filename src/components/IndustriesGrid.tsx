import {
  Banknote,
  BriefcaseBusiness,
  Building2,
  Car,
  ClipboardCheck,
  Cross,
  GraduationCap,
  HeartPulse,
  Hotel,
  Landmark,
  Megaphone,
  MonitorCog,
  Paintbrush,
  Plane,
  Pickaxe,
  School,
  ShieldCheck,
  ShoppingCart,
  Stethoscope,
  Tractor,
  Truck,
  Utensils,
  Wrench,
  Factory,
  Hammer,
  Home,
  Laptop,
  Leaf,
  Pill,
  Recycle,
  Signal,
  Store,
  Tent,
  Wheat,
} from "lucide-react";
import { INDUSTRIES } from "@/data/site";
import agricultureIcon from "@/assets/icons/Agriculture.png";
import educationIcon from "@/assets/icons/Education.png";
import wholesaleTradeIcon from "@/assets/icons/Wholesale Trade (1).png";
import miningIcon from "@/assets/icons/Mining.png";
import homeBuildersIcon from "@/assets/icons/Home Builders.png";
import automotiveIcon from "@/assets/icons/Automotive.png";
import retailIcon from "@/assets/icons/Retail.png";
import manufacturingIcon from "@/assets/icons/Manufacturing.png";
import constructionIcon from "@/assets/icons/Construction.png";
import foodBeverageIcon from "@/assets/icons/Food & Beverage.png";
import cosmeticsIcon from "@/assets/icons/Cosmetics.png";
import healthCareIcon from "@/assets/icons/Health Care.png";
import governmentIcon from "@/assets/icons/Government.png";
import eventIcon from "@/assets/icons/Event.png";
import wasteManagementIcon from "@/assets/icons/Waste Management.png";
import bankIcon from "@/assets/icons/Bank.png";
import infrastructureIcon from "@/assets/icons/Infrastructure.png";
import itIcon from "@/assets/icons/IT.png";
import hotelIcon from "@/assets/icons/Hotel.png";
import engineeringIcon from "@/assets/icons/Engineering.png";
import pharmaceuticalsIcon from "@/assets/icons/_Pharmaceuticals.png";
import telecomIcon from "@/assets/icons/Telecom.png";
import shippingIcon from "@/assets/icons/Shipping.png";
import insuranceIcon from "@/assets/icons/Insurance.png";
import tourismIcon from "@/assets/icons/Tourism.png";
import bakeryIcon from "@/assets/icons/Bakery.png";
import landDevelopersIcon from "@/assets/icons/Land Developers.png";
import decoratorIcon from "@/assets/icons/Decorator.png";
import advertisingMediaIcon from "@/assets/icons/Advertising & Media.png";

const INDUSTRY_ICONS = [
  Tractor,
  GraduationCap,
  ShoppingCart,
  Pickaxe,
  Home,
  Car,
  ShoppingCart,
  Factory,
  Hammer,
  Utensils,
  Paintbrush,
  HeartPulse,
  Landmark,
  ClipboardCheck,
  Recycle,
  Banknote,
  Building2,
  MonitorCog,
  Hotel,
  School,
  Wrench,
  Pill,
  Signal,
  Truck,
  ShieldCheck,
  Plane,
  Megaphone,
  Store,
  Building2,
  Tent,
];

export function IndustriesGrid({ framed = false }: { framed?: boolean }) {
  return (
    <div
      className={
        framed
          ? "mx-auto grid max-w-[700px] grid-cols-2 gap-x-4 gap-y-5 bg-white px-4 py-3 sm:grid-cols-3 md:grid-cols-6 md:gap-x-6"
          : "mx-auto grid max-w-[1280px] grid-cols-2 gap-x-6 gap-y-12 sm:grid-cols-3 lg:grid-cols-6"
      }
    >
      {INDUSTRIES.map((industry, index) => {
        const Icon = INDUSTRY_ICONS[index] ?? BriefcaseBusiness;
        const customIcon =
          industry === "Agriculture"
            ? agricultureIcon
            : industry === "Education"
              ? educationIcon
              : industry === "Wholesale Trade"
                ? wholesaleTradeIcon
                : industry === "Mining"
                  ? miningIcon
                  : industry === "Home Builders"
                    ? homeBuildersIcon
                    : industry === "Automotive"
                      ? automotiveIcon
                      : industry === "Retail"
                        ? retailIcon
                        : industry === "Manufacturing"
                          ? manufacturingIcon
                          : industry === "Construction"
                            ? constructionIcon
                            : industry === "Food & Beverage"
                              ? foodBeverageIcon
                              : industry === "Cosmetics"
                                ? cosmeticsIcon
                                : industry === "Health Care"
                                  ? healthCareIcon
                                  : industry === "Government"
                                    ? governmentIcon
                                    : industry === "Event"
                                      ? eventIcon
                                      : industry === "Waste Management"
                                        ? wasteManagementIcon
                                        : industry === "Bank"
                                          ? bankIcon
                                          : industry === "Infrastructure"
                                            ? infrastructureIcon
                                            : industry === "IT"
                                              ? itIcon
                                              : industry === "Hotel"
                                                ? hotelIcon
                                                : industry === "Engineering"
                                                  ? engineeringIcon
                                                  : industry === "Pharmaceuticals"
                                                    ? pharmaceuticalsIcon
                                                    : industry === "Telecom"
                                                      ? telecomIcon
                                                      : industry === "Shipping"
                                                        ? shippingIcon
                                                        : industry === "Insurance"
                                                          ? insuranceIcon
                                                          : industry === "Tourism"
                                                            ? tourismIcon
                                                            : industry === "Bakery"
                                                              ? bakeryIcon
                                                              : industry === "Land Developers"
                                                                ? landDevelopersIcon
                                                                : industry === "Decorator"
                                                                  ? decoratorIcon
                                                                  : industry === "Advertising & Media"
                                                                    ? advertisingMediaIcon
                                                                    : null;

        return (
          <div key={`${industry}-${index}`} className="group text-center">
            <div
              className={
                framed
                  ? "mx-auto grid h-[84px] w-[84px] place-items-center rounded-full border-2 border-[#d8d8d8] bg-white text-[#666] transition group-hover:border-brand-red group-hover:text-brand-red"
                  : "mx-auto grid h-32 w-32 place-items-center rounded-full border-[3px] border-[#d9d9d9] bg-white text-[#55565a] transition group-hover:border-brand-red group-hover:text-brand-red sm:h-36 sm:w-36 xl:h-40 xl:w-40"
              }
            >
              {customIcon ? (
                <img
                  src={customIcon}
                  alt=""
                  className={framed ? "h-14 w-14 object-contain" : "h-20 w-20 object-contain sm:h-24 sm:w-24 xl:h-28 xl:w-28"}
                />
              ) : (
                <Icon
                  className={
                    framed
                      ? "h-11 w-11 stroke-[1.45]"
                      : "h-14 w-14 stroke-[1.55] sm:h-16 sm:w-16 xl:h-20 xl:w-20"
                  }
                />
              )}
            </div>
            <div
              className={
                framed
                  ? "mt-2 text-sm font-bold leading-tight text-brand-dark"
                  : "mt-3 text-base font-bold leading-tight text-brand-dark sm:text-lg"
              }
            >
              {industry}
            </div>
          </div>
        );
      })}
    </div>
  );
}
