import { useEffect, useState } from "react";

import { CONTACT, SERVICES } from "@/data/site";
import {
  fetchPublicContact,
  fetchPublicServices,
  type PublicContact,
  type PublicService,
} from "@/lib/public-content";

export function usePublicServices() {
  const [services, setServices] = useState<PublicService[]>(SERVICES);

  useEffect(() => {
    fetchPublicServices()
      .then((items) => {
        if (items.length) setServices(items);
      })
      .catch(() => {});
  }, []);

  return services;
}

export function usePublicContact() {
  const [contact, setContact] = useState<PublicContact>(CONTACT);

  useEffect(() => {
    fetchPublicContact()
      .then((item) => {
        setContact({
          ...CONTACT,
          ...item,
          phones: item.phones?.length ? item.phones : CONTACT.phones,
        });
      })
      .catch(() => {});
  }, []);

  return contact;
}
