import { PrismaClient, Role, OrderStatus } from '@prisma/client';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {

  // Hash des mots de passe
  // 'password123'
  const password1 = await bcrypt.hash('password123', 10);
  // 'password456'
  const password2 = await bcrypt.hash('password456', 10);

  // Créer des utilisateurs
  const user1 = await prisma.user.create({
    data: {
      email: 'john.doe@example.com',
      password: password1,
      firstName: 'John',
      lastName: 'Doe',
      phoneNumber: '1234567890',
      roles: [Role.CUSTOMER],
    },
  });

  const user2 = await prisma.user.create({
    data: {
      email: 'jane.smith@example.com',
      password: password2,
      firstName: 'Jane',
      lastName: 'Smith',
      phoneNumber: '0987654321',
      roles: [Role.VENDOR],
    },
  });

  // Créer une adresse
  const address1 = await prisma.address.create({
    data: {
      country: 'France',
      city: 'Paris',
      postalCode: 75001,
      street: '123 Rue Lafayette',
      UserId: user1.id,
    },
  });

  // Créer un shop
  const shop1 = await prisma.shop.create({
    data: {
      idPaypal: '12345',
      name: 'Shop 1',
      phoneNumber: '0123456789',
      email: 'shop1@example.com',
      idAddress: address1.id,
      idUser: user2.id,
    },
  });

  // Créer un produit
  const product1 = await prisma.product.create({
    data: {
      barCode: '1111111111',
      name: 'Product A',
      priceHT: 1500,
      priceTVA: 300,
      priceTTC: 1800,
      stock: 50,
      idShop: shop1.id,
    },
  });

  // Créer une commande
  const order1 = await prisma.order.create({
    data: {
      userId: user1.id,
      adminId: null,
      priceHT: 1500,
      priceTVA: 300,
      priceTTC: 1800,
      status: OrderStatus.PENDING,
      deliverycountry: 'France',
      deliverycity: 'Paris',
      deliverypostalCode: 75001,
      deliverystreet: '123 Rue Lafayette',
      billingcountry: 'France',
      billingcity: 'Paris',
      billingpostalCode: 75001,
      billingstreet: '123 Rue Lafayette',
    },
  });

  // Associer la commande au shop
  await prisma.orderShop.create({
    data: {
      orderId: order1.id,
      shopId: shop1.id,
      shopcountry: address1.country,
      shopcity: address1.city,
      shoppostalCode: address1.postalCode,
      shopstreet: address1.street,
      priceHT: 1500,
      priceTVA: 300,
      priceTTC: 1800,
      status: OrderStatus.PENDING,
    },
  });

  // Associer un produit à la commande
  await prisma.orderProduct.create({
    data: {
      orderId: order1.id,
      productId: product1.id,
      shopId: shop1.id,
      name: product1.name,
      barCode: product1.barCode,
      priceHT: product1.priceHT,
      priceTVA: product1.priceTVA,
      priceTTC: product1.priceTTC,
      priceTotalHT: product1.priceHT,
      priceTotalTVA: product1.priceTVA,
      priceTotalTTC: product1.priceTTC,
      stock: 1,
    },
  });

  console.log('Base de données remplie avec succès !');
}

main()
  .catch((e) => {
    console.error(e);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
