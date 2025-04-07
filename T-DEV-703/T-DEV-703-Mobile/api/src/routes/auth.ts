import { FastifyPluginAsync, FastifyRequest } from 'fastify';
import { FromSchema } from 'json-schema-to-ts';

import { loginAuth, registerAuth } from '../controllers/auth';

import { authenticate } from '../decorators/auth';

export const schemaCreate = {201: {type: 'object', properties: {message: {type: 'string'}}}} as const;

const loginAuthSchema = {
  type: 'object',
  required: ['email', 'password'],
  properties: {
    email: { type: 'string', format: 'email' },
    password: { type: 'string' }
  }
} as const;

export const registerAuthSchema = {
  type: 'object',
  required: ['firstName', 'lastName', 'email', 'phone', 'password'],
  properties: {
    firstName: { type: 'string' },
    lastName: { type: 'string' },
    email: { type: 'string', format: 'email' },
    phone: { type: 'string', format: 'phone' },
    password: { type: 'string' }
  }
} as const;

export type LoginAuthData = FromSchema<typeof loginAuthSchema>;

export type RegisterAuthData = FromSchema<typeof registerAuthSchema>;

const authRoutes: FastifyPluginAsync = async function (fastify, _ops) {
  fastify.decorate('authenticate', authenticate);

  fastify.post('/login', {
    schema: {
      body: loginAuthSchema,
      tags: ['auth'],
      // security: [{ BearerAuth: [] }],
    }
  }, async (request: FastifyRequest<{ Body: LoginAuthData }>, reply) => {
    return loginAuth(request, reply, fastify);
  });

  fastify.post('/register', {
    schema: {
      body: registerAuthSchema,
      response: schemaCreate,
      tags: ['auth']
    }
  }, async (request: FastifyRequest<{ Body: RegisterAuthData }>, reply) => {
    return registerAuth(request, reply, fastify);
  });

  fastify.get('/testAuth', {
    schema: {
      tags: ['auth'],
      security: [{ BearerAuth: [] }]
    },
    preHandler: [authenticate],
  }, async (request, reply) => {
    return { message: 'You are authenticated' };
  });
}

export default authRoutes;