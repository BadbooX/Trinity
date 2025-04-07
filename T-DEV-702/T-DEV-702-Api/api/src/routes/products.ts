import { FastifyInstance, FastifyPluginAsync, FastifyRequest } from 'fastify';
import { FromSchema } from 'json-schema-to-ts';

import { 
  getProducts, getProductsByShop, getProductById, 
  addProduct, updateProduct, deleteProduct 
} from "../controllers/products";
import { shopIdSchema } from './shops';
import { authenticate, authorizeRole } from '../decorators/auth';
import { shopOwner } from '../decorators/shops';
import { productOwner } from '../decorators/product';

export const productIdSchema = {
  type: 'object',
  properties: {
    productId: { type: 'number' }
  },
  required: ['productId']
} as const;

const createProductData = {
  type: 'object',
  properties: {
    barCode: { type: 'string' },

    name: { type: 'string' },
    price: { type: 'number' },
    quantity: { type: 'number' },
  },
  required: ['barCode', 'name', 'price', 'quantity']
} as const;

const updateProductData = {
  type: 'object',
  properties: {
    barCode: { type: 'string' },

    name: { type: 'string' },
    price: { type: 'number' },
    quantity: { type: 'number' },
  },
  required: []
} as const;

export type CreateProductData = FromSchema<typeof createProductData>;
export type UpdateProductData = FromSchema<typeof updateProductData>;

const productRoutes: FastifyPluginAsync = async (fastify: FastifyInstance) => {
  fastify.decorate('authenticate', authenticate);
  fastify.decorate('authorizeRole', authorizeRole);
  fastify.decorate('shopOwner', shopOwner);
  fastify.decorate('productOwner', productOwner);

  fastify.get('/products', {
    schema: {
      tags: ['products'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate],
  }, async (
    request: FastifyRequest<{ Params: { shopId: number }}>,
    reply
  ) => getProducts(request, reply, fastify));

  fastify.get('/products/shops/:shopId', {
    schema: {
      params: shopIdSchema,
      tags: ['products', 'shops'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate],
  }, async (
    request: FastifyRequest<{ Params: { shopId: number }}>,
    reply
  ) => getProductsByShop(request, reply, fastify));

  fastify.get('/products/:productId', {
    schema: {
      params: productIdSchema,
      tags: ['products'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate],
  }, async (
    request: FastifyRequest<{ Params: { productId: number }}>,
    reply
  ) => getProductById(request, reply, fastify));

  fastify.post('/products/shops/:shopId', {
    schema: {
      params: shopIdSchema,
      body: createProductData,
      tags: ['products'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate, shopOwner],
  }, async (
    request: FastifyRequest<{ Params: { shopId: number }, Body: CreateProductData }>,
    reply
  ) => addProduct(request, reply, fastify));

  fastify.put('/products/:productId', {
    schema: {
      params: productIdSchema,
      body: updateProductData,
      tags: ['products'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate, productOwner],
  }, async (
    request: FastifyRequest<{ Params: { productId: number }, Body: UpdateProductData }>,
    reply
  ) => updateProduct(request, reply, fastify));

  fastify.delete('/products/:productId', {
    schema: {
      params: productIdSchema,
      tags: ['products'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate, productOwner],
  }, async (
    request: FastifyRequest<{ Params: { productId: number }}>,
    reply
  ) => deleteProduct(request, reply, fastify));
}

export default productRoutes;