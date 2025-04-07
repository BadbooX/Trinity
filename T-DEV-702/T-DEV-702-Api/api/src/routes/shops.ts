import { FastifyInstance, FastifyPluginAsync, FastifyRequest } from 'fastify';
import { FromSchema } from 'json-schema-to-ts';
import { Role } from '@prisma/client';

import { authenticate, authorizeRole } from '../decorators/auth';
import { shopOwner } from '../decorators/shops';

import { getShops, crateShop, updateShop, deleteShop, getMyShops } from '../controllers/shops';

import { schemaCreate } from './auth';


const addressShopSchema = {
  type: 'object',
  required: ['country', 'city', 'postalCode', 'street'],
  properties: {
    country: { type: 'string' },
    city: { type: 'string' },
    postalCode: { type: 'number' },
    street: { type: 'string' },
  }
} as const;

const updateAddressShopSchema = {
  type: ['object', 'null'],
  properties: {
    country: { type: ['string', 'null'] },
    city: { type: ['string', 'null'] },
    postalCode: { type: ['number', 'null'] },
    street: { type: ['string', 'null'] },
  }
} as const;

const updateShopSchema = {
  type: 'object',
  properties: {
    sellerId: { type: ['number', 'null'] },
    name: { type: ['string', 'null'] },
    phoneNumber: { type: ['string', 'null'], format: 'phone' },
    email: { type: ['string', 'null'], format: 'email' },
    idPaypal: { type: ['string', 'null'] },
    address: updateAddressShopSchema,
  },
  required: []
} as const;

const createShopSchema = {
  type: 'object',
  required: ['sellerId', 'name', 'phoneNumber', 'email', 'address', 'idPaypal'],
  properties: {
    sellerId: { type: 'number' },
    name: { type: 'string' },
    phoneNumber: { type: 'string', format: 'phone' },
    email: { type: 'string', format: 'email' },
    idPaypal: { type: 'string' },
    address: addressShopSchema,
  }
} as const;

const shopSchema = {
  type: 'object',
  required: ['id', 'name', 'email', 'phoneNumber', 'address'],
  properties: {
    id: { type: 'number' },
    idPaypal: { type: 'string' },
    idUser: { type: 'number' },
    name: { type: 'string' },
    email: { type: 'string', format: 'email' },
    phoneNumber: { type: 'string', format: 'phone' },
    address: addressShopSchema,
  }
} as const;

export const shopIdSchema = {
  type: 'object',
  properties: {
    shopId: { type: 'number' }
  },
  required: ['shopId']
} as const;

export type CreateShopData = FromSchema<typeof createShopSchema>;
export type UpdateShopData = FromSchema<typeof updateShopSchema>;

const shopsRoutes: FastifyPluginAsync = async (fastify: FastifyInstance) => {
  fastify.decorate('authenticate', authenticate);
  fastify.decorate('authorizeRole', authorizeRole);
  fastify.decorate('shopOwner', shopOwner);

  fastify.get('/shops', {
    schema: {
      tags: ['shops'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate],
  }, async (
    request, 
    reply
  ) => getShops(request, reply, fastify));


  fastify.post('/shops', {
    schema: {
      body: createShopSchema,
      response: schemaCreate,
      tags: ['shops'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate, authorizeRole([Role.ADMIN])],
  }, async (
    request: FastifyRequest<{ Body: CreateShopData }>, 
    reply
  ) => crateShop(request, reply, fastify));


  fastify.put('/shops/:shopId', {
    schema: {
      params: shopIdSchema,
      body: updateShopSchema,
      tags: ['shops'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate, shopOwner],
  }, async (
    request: FastifyRequest<{ Params: { shopId: number }, Body: UpdateShopData }>, 
    reply
  ) => updateShop(request, reply, fastify));


  fastify.delete('/shops/:shopId', {
    schema: {
      params: shopIdSchema,
      tags: ['shops'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate, shopOwner],
  }, async (
    request: FastifyRequest<{ Params: { shopId: number } }>, 
    reply
  ) => deleteShop(request, reply, fastify));


  fastify.get('/shops/my', {
    schema: {
      tags: ['shops'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate, authorizeRole([Role.VENDOR])],
  }, async (
    request, 
    reply) => getMyShops(request, reply, fastify));

}

export default shopsRoutes;