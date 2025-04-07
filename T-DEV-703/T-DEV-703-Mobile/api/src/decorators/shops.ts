import { FastifyRequest, FastifyReply, FastifyInstance } from 'fastify';
import { User, Role, Shop } from '@prisma/client';

declare module 'fastify' {
  interface FastifyRequest {
    shop?: Shop;
  }
}

export async function shopOwner(request: FastifyRequest, reply: FastifyReply) {
  if (request.jwt && !request.user) {
    const user = await request.server.prisma.user.findUnique({
      where: {
        id: request.jwt.id
      }
    });
    request.user = user ?? undefined;
  }

  if (!request.user) {
    reply.status(401).send({ error: 'Unauthorized' });
    return false;
  }

  if (!request.user.roles.some(role => role === Role.VENDOR)) {
    reply.status(403).send({ error: 'Forbidden' });
    return false;
  }

  const params = request.params as { shopId: number };
  if (!params.shopId) {
    reply.status(404).send({ error: 'No shop id provided' });
    return false;
  }

  const shop = await request.server.prisma.shop.findUnique({
    where: {
      id: Number(params.shopId)
    }
  });

  if (!shop) {
    reply.status(404).send({ error: 'Shop not found' });
    return false;
  }

  request.shop = shop;

  if (request.user.roles.some(role => role === Role.ADMIN)) {
    return true;
  }

  if (shop.idUser !== request.user.id) {
    reply.status(403).send({ error: 'Forbidden' });
    return false;
  }

  return true;
}


export async function shopOwnerFromOrder(request: FastifyRequest, reply: FastifyReply) {
  if (request.jwt && !request.user) {
    const user = await request.server.prisma.user.findUnique({
      where: {
        id: request.jwt.id
      }
    });
    request.user = user ?? undefined;
  }

  if (!request.user) {
    reply.status(401).send({ error: 'Unauthorized' });
    return false;
  }

  if (!request.user.roles.some(role => role === Role.VENDOR)) {
    reply.status(403).send({ error: 'Forbidden' });
    return false;
  }

  const params = request.params as { orderId: number };
  if (!params.orderId) {
    reply.status(404).send({ error: 'No order id provided' });
    return false;
  }

  const order = await request.server.prisma.order.findUnique({
    where: {
      id: Number(params.orderId)
    },
    include: {
      OrderShops: {
        include: {
          shop: true
        }
      }
    }
  });

  if (!order) {
    reply.status(404).send({ error: 'Order not found' });
    return false;
  }

  if (request.user.roles.some(role => role === Role.ADMIN)) {
    return true;
  }

  if (!request.user || order.OrderShops.some(orderShop => orderShop.shop.idUser !== request.user!.id)) {
    reply.status(403).send({ error: 'Forbidden' });
    return false;
  }

  return true;
}