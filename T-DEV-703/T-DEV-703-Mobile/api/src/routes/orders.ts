import { FastifyInstance, FastifyPluginAsync, FastifyRequest } from 'fastify';
import { FromSchema } from 'json-schema-to-ts';

import { Role } from '@prisma/client';

import { getMyOrders, getAllOrders, getIdOrder, updateOrderState, getShopOrders, addOrder } from "../controllers/orders";
import { authenticate, authorizeRole } from '../decorators/auth';
import { shopOwner, shopOwnerFromOrder } from '../decorators/shops';



const createOrderProductSchema = {
  type: 'object',
  properties: {
    productId: { type: 'number' },
    quantity: { type: 'number' },
  },
  required: ['productId', 'quantity']
} as const;

const createOrderSchema = {
  type: 'object',
  properties: {
    products: { type: 'array', items: createOrderProductSchema },
    deliveryAddressId: { type: 'number' },
    billingAddressId: { type: 'number' }
  },
  required: ['products', 'deliveryAddressId', 'billingAddressId']

} as const;

const createOrderAdminSchema = { 
  ...createOrderSchema, 
  properties: {
    ...createOrderSchema.properties,
    userId: { type: 'number' },
    AdminId: { type: 'number' },
  },
} as const;

const updateOrderStateSchema = {
  type: 'object',
  properties: {
    state: { type: 'string' }
  },
  required: ['state']
} as const;


export type CreateOrderData = FromSchema<typeof createOrderSchema>;
export type CreateOrderAdminData = FromSchema<typeof createOrderAdminSchema>;
export type CreateOrderProductData = FromSchema<typeof createOrderProductSchema>;
export type UpdateOrderStateData = FromSchema<typeof updateOrderStateSchema>;

const orderRoutes: FastifyPluginAsync = async (fastify: FastifyInstance) => {
  fastify.decorate('authenticate', authenticate);
  fastify.decorate('authorizeRole', authorizeRole);
  fastify.decorate('shopOwner', shopOwner);
  fastify.decorate('shopOwnerFromOrder', shopOwnerFromOrder);
  

  fastify.get('/orders/my', {
    schema: {
      tags: ['orders'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate]
  }, async (request, reply) => {
    return getMyOrders(request, reply, fastify);
  });

  fastify.get('/orders/all', {
    schema: {
      tags: ['orders'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate, authorizeRole([Role.ADMIN])]
  }, async (request, reply) => {
    return getAllOrders(request, reply, fastify);
  });

  fastify.get('/orders/:orderId/', {
    schema: {
      tags: ['orders'],
      params: {
        orderId: { type: 'number' }
      },
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate, authorizeRole([Role.ADMIN])]
  }, async (
    request: FastifyRequest<{ Params: { orderId: number }}>, 
    reply
  ) => {
    return getIdOrder(request, reply, fastify);
  });

  fastify.get('/orders/shop/:shopId', {
    schema: {
      tags: ['orders'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate, shopOwner]
  }, async (
    request: FastifyRequest<{ Params: { shopId: number }}>, 
    reply
  ) => {
    return getShopOrders(request, reply, fastify);
  });


  fastify.post('/orders', {
    schema: {
      tags: ['orders'],
      body: createOrderSchema,
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate, authorizeRole([Role.CUSTOMER])]
  }, async (
    request: FastifyRequest<{ Body: CreateOrderData }>,
    reply
  ) => {
    return addOrder(request, reply, fastify);
  });

  fastify.put('/orders/:orderId', {
    schema: {
      tags: ['orders'],
      params: {
        orderId: { type: 'number' }
      },
      body: updateOrderStateSchema,
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate, shopOwnerFromOrder]
  }, async (
    request: FastifyRequest<{ Params: { orderId: number }, Body: UpdateOrderStateData }>,
    reply
  ) => {
    return updateOrderState(request, reply, fastify);
  }
  )

  // fastify.put('/orders/:id', async (request, reply) => {
  //     return updateOrder(request, reply, fastify);
  // });

  // fastify.delete('/orders/:id', async (request, reply) => {
  //     return deleteOrder(request, reply, fastify);
  // });

  // fastify.get('/:shopId/orders', async (request, reply) => {
  //     return getShopOrders(request, reply, fastify);
  // });
}

export default orderRoutes;