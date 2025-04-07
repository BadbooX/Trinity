
export interface Shop {
    name: string;
    id: string;
    sellerId: string;
    idPaypal: string;
    phoneNumber? : string;
    address: {
        country: string;
        city: string;
        postalCode: string;
        street: string;
    };
}