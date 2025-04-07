'use strict'

import path from 'path';

import Fastify from 'fastify'
import { JsonSchemaToTsProvider } from '@fastify/type-provider-json-schema-to-ts'

import cors from '@fastify/cors'

import swagger from '@fastify/swagger';
import autoload from '@fastify/autoload';

import Ajv from 'ajv';

import { genCertDev, showServerUrls } from './server-utils';

async function createServer(): Promise<void> { // needed for better lisibility

  const cert = await genCertDev(); // generate certificate (dev) or use real certificate (prod)

  const fastify = Fastify({
    trustProxy: true,
    logger: true,
    http2: true,
    https: {
      // allowHTTP1: true, // fallback support for HTTP1
      key: cert.key,
      cert: cert.cert
    },
  }).withTypeProvider<JsonSchemaToTsProvider<{}>>()

  const ajv = new Ajv({
    removeAdditional: true,
    useDefaults: true,
    coerceTypes: true,
    allErrors: true,
    strict: false
  });

  fastify.setValidatorCompiler(({ schema }) => ajv.compile(schema));

  fastify.register(cors, {
    origin: '*',
    methods: ['GET', 'HEAD', 'PUT', 'PATCH', 'POST', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true,
    hideOptionsRoute: true
  });

  await fastify.register(swagger, {
    refResolver: {
      buildLocalReference(json, baseUri, fragment, i) {
        return (json.$id || `my-fragment-${i}`).toString();
      }
    },
    openapi: {
      openapi: '3.0.0',
      info: {
        title: 'API Documentation',
        version: '1.0.0'
      },
      components: {
        securitySchemes: {
          BearerAuth: {
            type: 'http',
            scheme: 'bearer',
            bearerFormat: 'JWT'
          }
        }
      },
      // security: [{ BearerAuth: [] }]
    }
  });

  // Load plugins
  await fastify.register(autoload, {
    dir: path.join(__dirname, 'plugins'),
    options: { }, 
  });

  // Load validators
  await fastify.register(autoload, {
    dir: path.join(__dirname, 'validators'),
    encapsulate: false,
    options: { }, 
  });

  // Load decorators
  await fastify.register(autoload, {
    dir: path.join(__dirname, 'decorators'),
    encapsulate: false,
    options: { }, 
  });
  
  // Load routes
  await fastify.register(autoload, {
    dir: path.join(__dirname, 'routes'),
    options: { prefix: '/api' }, 
  });

  /**
   * Run the server
   */
  const start = async () => {
    try {
      await fastify.ready() // all plugin loaded

      await fastify.listen({ port: 3000, host: "::" }); // start server ('::' ipv6 and ipv4)

      showServerUrls();
    } catch (err) {
      console.error(err);
      fastify.log.error(err);
      process.exit(1);
    }
  }

  start();
}

createServer();