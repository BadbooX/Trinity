//product owner

import { FastifyRequest, FastifyReply, FastifyInstance } from 'fastify';
import jwt, { JwtPayload } from 'jsonwebtoken';
import { User, Role, Product, Shop } from '@prisma/client';

declare module 'fastify' {
  interface FastifyRequest {
    user?: User;
    product?: Product;
    shop?: Shop;
  }
}

export async function productOwner(request: FastifyRequest, reply: FastifyReply) {
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

  const params = request.params as { productId: number };

  if (!params.productId) {
    reply.status(404).send({ error: 'No product id provided' });
    return false;
  }

  const product = await request.server.prisma.product.findUnique({
    where: {
      id: params.productId
    },
    include: {
      Shop: true
    }
  });

  if (!product) {
    reply.status(404).send({ error: 'Product not found' });
    return false;
  }

  request.product = product;
  request.shop = product.Shop;

  if (request.user.roles.some(role => role === Role.ADMIN)) {
    return true;
  }

  if (product.Shop.idUser !== request.user.id) {
    reply.status(403).send({ error: 'Forbidden' });
    return false;
  }
}

