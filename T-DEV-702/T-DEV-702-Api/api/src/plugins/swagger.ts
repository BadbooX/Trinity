import { FastifyInstance, FastifyPluginAsync } from 'fastify';

import fastifySwaggerUi from '@fastify/swagger-ui';

const swagger: FastifyPluginAsync = async (fastify: FastifyInstance) => {
  fastify.register(fastifySwaggerUi, {
    routePrefix: '/api/docs',
    uiConfig: {
      docExpansion: 'full',
      deepLinking: false,
    },
    uiHooks: {
        onRequest: function (request, reply, next) { next() },
        preHandler: function (request, reply, next) { next() }
    },
    staticCSP: true,
    transformStaticCSP: (header) => header,
    transformSpecification: (swaggerObject, request, reply) => { return swaggerObject },
    transformSpecificationClone: true,
  });
}

export default swagger;