export interface Product  {
    id?: number;
    barCode?: string;
    name?: string;
    code?: string;
    stock?: number;
    price?: number;
    image?: string;
    image_front_url?: string;
    brands?: string;
    ingredients_text_en?: string;
    nutrient_levels? : {
        fat: string;
        'saturated-fat': string;
        sugars: string;
        salt: string;
    };
    nutriscore_grade?: string;
    nova_group?: number;
    serving_quantity?: string;
    serving_quantity_unit?: string;
    energy_serving?: string;
    energy_unit?: string;
    allergens_from_ingredients?: string;
}