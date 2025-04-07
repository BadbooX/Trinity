import { FastifyInstance, FastifyPluginAsync, FastifyRequest } from 'fastify';
import { FromSchema } from 'json-schema-to-ts';
import { Role } from '@prisma/client';

import { getAll, modifyMyUser, getMyUser, deleteMyUser, createUser, updateUser, deleteUser, DeleteUserData } from '../controllers/users';
import { authenticate, authorizeRole } from '../decorators/auth';
import { registerAuth } from '../controllers/auth';
import { RegisterAuthData, registerAuthSchema } from './auth';
const userSchema = {
  type: 'object',
  required: ['id', 'name', 'email'],
  properties: {
    id: { type: 'number' },
    name: { type: 'string' },
    email: { type: 'string', format: 'email' },
  },
} as const;

// const deleteUserSchema = {
//   type: 'object',
//   properties: {
//     id: { type: 'number' },
//   },
//   required: [],
// } as const;

// const createUserSchema = {
//   type: 'object',
//   required: ['firstName', 'lastName', 'email', 'phone', 'role'],
//   properties: {
//     firstName: { type: 'string' },
//     lastName: { type: 'string' },
//     email: { type: 'string', format: 'email' },
//     phone: { type: 'string' },
//     role: {
//       type: 'array',
//       items: { type: 'string', enum: Object.values(Role) }, // Validation des rôles
//     },
//     address: {
//       type: 'object',
//       required: ['country', 'city', 'postalCode', 'streetNumber', 'streetType'],
//       properties: {
//         country: { type: 'string' },
//         city: { type: 'string' },
//         postalCode: { type: 'number' },
//         streetNumber: { type: 'string' },
//         streetType: { type: 'string' },
//       },
//     },
//   },
// } as const;

const updateUserSchema = {
  type: 'object',
  properties: {
    firstName: { type: ['string', 'null'] },
    lastName: { type: ['string', 'null'] },
    email: { type: ['string', 'null'], format: 'email' },
    phone: { type: ['string', 'null'] },
    role: {
      type: ['array', 'null'],
      items: { type: 'string', enum: Object.values(Role) },
    },
    address: {
      type: ['object', 'null'],
      properties: {
        id: { type: 'number' },
        country: { type: ['string', 'null'] },
        city: { type: ['string', 'null'] },
        postalCode: { type: ['number', 'null'] },
        streetNumber: { type: ['string', 'null'] },
        streetType: { type: ['string', 'null'] },
      },
    },
  },
  required: [],
} as const;

// export type CreateUserData = FromSchema<typeof createUserSchema>;
export type UpdateUserData = FromSchema<typeof updateUserSchema>;

const userRoutes: FastifyPluginAsync = async (fastify: FastifyInstance) => {
  fastify.decorate('authenticate', authenticate);
  fastify.decorate('authorizeRole', authorizeRole);

  fastify.get('/users', {
    schema: {
      description: 'Retrieve all users',
      tags: ['Users'],
      security: [{ BearerAuth: [] }],
      response: {
        200: {
          type: 'array',
          items: userSchema,
        },
      },
    },
    preHandler: [authenticate, authorizeRole([Role.ADMIN])],
  }, async (request, reply) => getAll(request, reply, fastify));

  fastify.post<{ Body: RegisterAuthData }>('/users', {
    schema: {
      body: registerAuthSchema,
      tags: ['Users'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate, authorizeRole([Role.ADMIN])],
  }, async (request: FastifyRequest<{ Body: RegisterAuthData }>, reply) => {
    return registerAuth(request, reply, fastify);
  });

  
  fastify.put<{ Params: { userId: number }, Body: UpdateUserData }>('/users/:id', {
    schema: {
      params: { type: 'object', properties: { id: { type: 'number' } }, required: ['id'] },
      body: updateUserSchema,
      tags: ['Users'],
      security: [{ BearerAuth: [] }],
    },
  preHandler: [authenticate, authorizeRole([Role.ADMIN])],
},  async (request: FastifyRequest<{ Params: { userId: number }, Body: UpdateUserData }>, reply) => {
  return updateUser(request, reply, fastify);
});


fastify.delete<{ Params: { id: number } }>('/users/:id', {
  schema: {
    params: { type: 'object', properties: { id: { type: 'number' } }, required: ['id'] },
    tags: ['Users'],
    security: [{ BearerAuth: [] }],
  },
  preHandler: [authenticate, authorizeRole([Role.ADMIN])],
}, async (request: FastifyRequest<{ Params: { id: number } }>, reply) => {
  return deleteUser({
    ...request,
    params: { userId: request.params.id }, 
  }, reply, fastify);
});

  // USER MY
  fastify.get('/users/my', {
    schema: {
      tags: ['Users'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate],
  }, async (request, reply) => getMyUser(request, reply, fastify));

  fastify.put<{ Body: UpdateUserData }>('/users/my', {
    schema: {
      body: updateUserSchema,
      tags: ['Users'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate],
  }, async (request, reply) => modifyMyUser(request, reply, fastify));

  fastify.delete('/users/my', {
    schema: {
      tags: ['Users'],
      security: [{ BearerAuth: [] }],
    },
    preHandler: [authenticate],
  }, async (request, reply) => deleteMyUser(request, reply, fastify));
};

export default userRoutes;