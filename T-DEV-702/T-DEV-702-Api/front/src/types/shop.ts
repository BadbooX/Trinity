import type { Address } from "./address";

export interface Shop {
    name: string;
    id: string;
    owner: string;
    paypal: string;
    phone? : string;
    address: Address;
}