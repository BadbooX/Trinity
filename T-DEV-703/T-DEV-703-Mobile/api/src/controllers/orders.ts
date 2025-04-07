import { FastifyRequest, FastifyReply, FastifyInstance } from 'fastify';

import { Order, OrderStatus } from '@prisma/client';

import { CreateOrderData, UpdateOrderStateData } from '../routes/orders';


export async function getMyOrders(
  request: FastifyRequest, 
  reply: FastifyReply, 
  fastify: FastifyInstance) {

  if (!request.user) {
    reply.code(401).send({ message: 'Unauthorized' });
    return;
  }

  let userId = request.user.id;

  let orders = await fastify.prisma.order.findMany({
    where: {
      userId: userId
    },
    include: {
      user: {
        select: {
          id: true,
          email: true,
          firstName: true,
          lastName: true,
          phoneNumber: true
        }
      },
      orderProducts: {
        include: {
          product: true,
        }
      },
      OrderShops: {
        include: {
          shop: true
        }
      }
    }
  });

  return orders;
}

export async function getShopOrders(
  request: FastifyRequest<{ Params: { shopId: number }}>,
  reply: FastifyReply, 
  fastify: FastifyInstance) {

  let shopId = Number(request.params.shopId)
  let orders = await fastify.prisma.orderShop.findMany({
    where: {
      shopId: Number(request.params.shopId)
    },
    include: {
      order: {
        include: {
          orderProducts: {
            where: {
              shopId: shopId
            },
            include: {
              product: true
            }
          }
        }
      }
    }
  });

  return orders;
}

type shopOrderData = {
  [key: number]: {
    priceHT: number,
    priceTVA: number,
    priceTTC: number,

    shopcity: string,
    shopcountry: string,
    shoppostalCode: number,
    shopstreet: string
  }
};

export async function getAllOrders(
  request: FastifyRequest,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let orders = await fastify.prisma.order.findMany({
    include: {
      OrderShops: {
        include: {
          shop: true
        }
      },
      orderProducts: {
        include: {
          product: true
        }
      }
    }
  });

  return orders;
}

export async function getIdOrder(
  request: FastifyRequest<{ Params: { orderId: number }}>,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let orderId = Number(request.params.orderId);
  let order = await fastify.prisma.order.findUnique({
    where: {
      id: Number(orderId)
    },
    include: {
      OrderShops: {
        include: {
          shop: true
        }
      },
      orderProducts: {
        include: {
          product: true
        }
      }
    }
  });

  if (!order) {
    reply.code(404).send({ message: 'Order not found' });
    return;
  }

  return order;
}

export async function addOrder(
  request: FastifyRequest<{ Body: CreateOrderData }>,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let data = request.body;
  let products = data.products;

  if (!request.user) {
    reply.code(401).send({ message: 'Unauthorized' });
    return;
  }

  let userId = request.user.id;

  let orderData = {
    shops: {} as shopOrderData,
    userId: userId,
    priceHT: 0,
    riceTVA: 0,
    priceTTC: 0,
    orderProducts: Array(),
    status: 'PENDING' as OrderStatus,

    deliverycountry: "" as string,
    deliverycity: "" as string,
    deliverypostalCode: 0 as number,
    deliverystreet: "" as string,

    billingcountry: "" as string,
    billingcity: "" as string,
    billingpostalCode: 0 as number,
    billingstreet: "" as string,
  };

  // check if address exists and belongs to user
  let addresses = await fastify.prisma.address.findMany({
    where: {
      id: {
        in: [data.deliveryAddressId, data.billingAddressId]
      },
      UserId: userId
    }
  });

  if (
    ( data.billingAddressId != data.deliveryAddressId && addresses.length != 2)
    || ( data.billingAddressId == data.deliveryAddressId && addresses.length != 1)) {
    reply.code(400).send({ message: 'Invalid addresses' });
    return;
  }

  //set addresses
  for (let i = 0; i < addresses.length; i++) {
    let address = addresses[i];
    if (address.id === data.deliveryAddressId) {
      orderData.deliverycountry = address.country;
      orderData.deliverycity = address.city;
      orderData.deliverypostalCode = address.postalCode;
      orderData.deliverystreet = address.street;
    }
    if (address.id === data.billingAddressId) {
      orderData.billingcountry = address.country;
      orderData.billingcity = address.city;
      orderData.billingpostalCode = address.postalCode;
      orderData.billingstreet = address.street;
    }
  }

  // get products from database
  let productIds = products
    .map(p => p.productId ?? -1)
    .filter(id => id !== -1);
  let productsDB = await fastify.prisma.product.findMany({
    where: {
      id: {
        in: productIds
      }
    }
  });

  // calculate prices
  for (let i = 0; i < products.length; i++) {
    let productDB = productsDB.find(p => p.id === products[i].productId);
    if (!productDB) {
      reply.code(404).send({ message: 'Product not found', productId: products[i] });
      return; // Ensure return after sending reply
    }

    let shopDB = await fastify.prisma.shop.findUnique({
      where: {
        id: productDB.idShop
      },
      include: {
        address: true
      }
    });

    if (!shopDB) {
      reply.code(404).send({ message: 'Shop not found', productId: products[i] });
      return; // Ensure return after sending reply
    }

    //set shop address


    if (products[i].quantity < 0) {
      reply.code(400).send({ message: 'Quantity must be positive' });
      return; // Ensure return after sending reply
    }

    // add shopId to orderData if not already in
    if (!orderData.shops[productDB.idShop]) {
      orderData.shops[productDB.idShop] = {
        priceHT: 0,
        priceTVA: 0,
        priceTTC: 0,

        shopcity: shopDB.address.city,
        shopcountry: shopDB.address.country,
        shoppostalCode: shopDB.address.postalCode,
        shopstreet: shopDB.address.street
      };
    }

    // add product prices to shop prices
    orderData.shops[productDB.idShop].priceHT += productDB.priceHT * products[i].quantity;
    orderData.shops[productDB.idShop].priceTVA += productDB.priceTVA * products[i].quantity;
    orderData.shops[productDB.idShop].priceTTC += productDB.priceTTC * products[i].quantity;

    orderData.priceHT += productDB.priceHT * products[i].quantity;
    orderData.riceTVA += productDB.priceTVA * products[i].quantity;
    orderData.priceTTC += productDB.priceTTC * products[i].quantity;

    orderData.orderProducts.push({
      productId: products[i].productId,
      shopId: productDB.idShop,
      name: productDB.name,
      stock: products[i].quantity,
      barCode: productDB.barCode,
      priceHT: productDB.priceHT,
      priceTVA: productDB.priceTVA,
      priceTTC: productDB.priceTTC,
      priceTotalHT: productDB.priceHT * products[i].quantity,
      priceTotalTVA: productDB.priceTVA * products[i].quantity,
      priceTotalTTC: productDB.priceTTC * products[i].quantity,
    });
  }

  // save order
  let orderDB = await fastify.prisma.order.create({
    data: {
      userId: orderData.userId,
      priceHT: orderData.priceHT,
      priceTVA: orderData.riceTVA,
      priceTTC: orderData.priceTTC,
      status: orderData.status,

      deliverycountry: orderData.deliverycountry,
      deliverycity: orderData.deliverycity,
      deliverypostalCode: orderData.deliverypostalCode,
      deliverystreet: orderData.deliverystreet,

      billingcountry: orderData.billingcountry,
      billingcity: orderData.billingcity,
      billingpostalCode: orderData.billingpostalCode,
      billingstreet: orderData.billingstreet,

      orderProducts: {
        createMany: {
          data: orderData.orderProducts
        }
      },

      OrderShops: {
        createMany: {
          skipDuplicates: true,
          data: Object.keys(orderData.shops).map(shopIdString => {
            let shopId = Number(shopIdString);
            return {
              shopId: shopId,
              priceHT: orderData.shops[shopId].priceHT,
              priceTVA: orderData.shops[shopId].priceTVA,
              priceTTC: orderData.shops[shopId].priceTTC,

              shopcity: orderData.shops[shopId].shopcity,
              shopcountry: orderData.shops[shopId].shopcountry,
              shoppostalCode: orderData.shops[shopId].shoppostalCode,
              shopstreet: orderData.shops[shopId].shopstreet,
            };
          })
        }
      }
    },

    include: {
      orderProducts: true,
    }
  });

  return reply.code(201).send({ message: 'Order created', order: orderDB });
}

export async function updateOrderState(
  request: FastifyRequest<{ Params: { orderId: number }, Body: UpdateOrderStateData }>,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let orderId = Number(request.params.orderId);
  if (!request.body.state) {
    reply.code(400).send({ message: 'State must be provided' });
    return;
  }

  //check if status is valid
  let status = request.body.state as OrderStatus;
  if (!Object.values(OrderStatus).includes(status)) { // not good normaly need to be check in dataValidation lifecycle but take time to implement
    reply.code(400).send({ message: 'Invalid status' });
    return;
  }

  let order = await fastify.prisma.order.update({
    where: {
      id: orderId
    },
    data: {
      status: request.body.state as OrderStatus
    }
  });

  return { message: 'Order state updated', order };
}

export function addInvoice(request: FastifyRequest, reply: FastifyReply, fastify: FastifyInstance) {
  return new Promise((resolve, reject) => { resolve(null) });
}

export function updateOrder(request: FastifyRequest, reply: FastifyReply, fastify: FastifyInstance) {
  return new Promise((resolve, reject) => { resolve(null) });
}

export function deleteOrder(request: FastifyRequest, reply: FastifyReply, fastify: FastifyInstance) {
  return new Promise((resolve, reject) => { resolve(null) });
}