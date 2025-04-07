
import { FastifyRequest, FastifyReply, FastifyInstance } from 'fastify';

import { CreateShopData, UpdateShopData } from '../routes/shops';
import { Role } from '@prisma/client';

export async function getShops(request: FastifyRequest, reply: FastifyReply, fastify: FastifyInstance) {
  let shops = await fastify.prisma.shop.findMany({
    select: {
      id: true,
      name: true,
      phoneNumber: true,
      email: true,

      idPaypal: false,
      idUser: false,
      idAddress: false,      
      address: {
        select: {
          country: true,
          city: true,
          postalCode: true,
          street: true
        }
      }
    }
  });

  return shops;
}

export async function crateShop(
  request: FastifyRequest<{ Body: CreateShopData }>,
  reply: FastifyReply,
  fastify: FastifyInstance) {
  let data = request.body;

  //get seller user
  let seller = await fastify.prisma.user.findUnique({
    where: {
      id: data.sellerId
    }
  });

  if (!seller) {
    reply.code(404).send({ message: 'Seller not found' });
    return
  }

  if (!seller.roles.some(role => role === Role.VENDOR)) {
    let actualRoles = seller.roles;
    actualRoles.push(Role.VENDOR);
    await fastify.prisma.user.update({
      where: {
        id: seller.id
      },
      data: {
        roles: actualRoles
      }
    });
  }

  // Create address
  let address = await fastify.prisma.address.create({
    data: {
      country: data.address.country,
      city: data.address.city,
      postalCode: data.address.postalCode,
      street: data.address.street,
    }
  });

  // create shop
  let shop = await fastify.prisma.shop.create({
    data: {
      idUser: data.sellerId,
      name: data.name,
      phoneNumber: data.phoneNumber,
      email: data.email,
      idPaypal: data.idPaypal,
      idAddress: address.id
    }
  });

  reply.code(201).send({ message: 'Shop created' });
}

export async function updateShop(
  request: FastifyRequest<{ Params: { shopId: number }, Body: UpdateShopData }>,
  reply: FastifyReply, 
  fastify: FastifyInstance) {
  let data = request.body;

  if (data.address) {
    let shop = request.shop ?? await fastify.prisma.shop.findUnique({
      where: {
        id: request.params.shopId
      }
    });

    if (!shop) {
      reply.code(404).send({ message: 'Shop not found' });
      return
    }

    // update address
    await fastify.prisma.address.update({
      where: {
        id: shop.idAddress
      },
      data: {
        country: data.address.country ?? undefined,
        city: data.address.city ?? undefined,
        postalCode: data.address.postalCode ?? undefined,
        street: data.address.street ?? undefined,
      }
    });
  }

  // update shop
  await fastify.prisma.shop.update({
    where: {
      id: request.params.shopId
    },
    data: {
      name: data.name ?? undefined,
      phoneNumber: data.phoneNumber ?? undefined,
      email: data.email ?? undefined,
      idPaypal: data.idPaypal ?? undefined
    }
  });

  reply.code(200).send({ message: 'Shop updated' });
}

export async function deleteShop(
  request: FastifyRequest<{ Params: { shopId: number } }>,
  reply: FastifyReply,
  fastify: FastifyInstance) {

  let shop = await fastify.prisma.shop.delete({
    where: {
      id: request.params.shopId
    }
  });

  if (!shop) {
    reply.code(404).send({ message: 'Shop not found' });
    return
  }

  //delete address
  await fastify.prisma.address.delete({
    where: {
      id: shop.idAddress
    }
  });

  reply.code(200).send({ message: 'Shop deleted'});
}

export async function getMyShops(request: FastifyRequest, reply: FastifyReply, fastify: FastifyInstance) {
  if (!request.user) {
    reply.code(401).send({ message: 'Unauthorized' });
    return
  }

  let shops = await fastify.prisma.shop.findMany({
    where: {
      idUser: request.user.id
    }
  });

  return shops;
}