import { FastifyRequest, FastifyReply, FastifyInstance } from 'fastify';
import jwt, { JwtPayload } from 'jsonwebtoken';
import { User, Role } from '@prisma/client';

interface Jwt extends JwtPayload {
  id: number;
  token: string;
}

declare module 'fastify' {
  interface FastifyRequest {
    jwt?: Jwt;
    user?: User;
  }
}

let JWT_SECRET: string;

// On import, check if needed environment variables are set
if (!process.env.JWT_SECRET) {
  throw new Error('JWT_SECRET env variable is not set');
} else {
  JWT_SECRET = process.env.JWT_SECRET;
}

// Authentication middleware
export async function authenticate(request: FastifyRequest, reply: FastifyReply) {
  try {
    const token = request.headers.authorization;
    if (!token) {
      reply.status(401).send({ error: 'Unauthorized' });
      throw new Error('No token provided');
    }
    const decoded = jwt.verify(token.split(' ')[1], JWT_SECRET) as Jwt; // Bearer <token>
    request.jwt = decoded;
    // Check if in db
    const jwtRecord = await request.server.prisma.jwt.findUnique({
      where: {
        idUser_token: {
            idUser: decoded.id, // id user
            token: decoded.token
        }
      }
    });
    if (!jwtRecord) {
      reply.status(401).send({ error: 'Unauthorized' });
      throw new Error('Invalid token');
      return false;
    }

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
  } catch (err) {
    reply.status(401).send({ error: 'Unauthorized' });
    return false;
  }

  return true;
}

// Role check middleware
export function authorizeRole(rolesNeeded: Role[], needAll: boolean = false) {
  return async function (request: FastifyRequest, reply: FastifyReply) {
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
    const userRoles = request.user.roles;

    if (needAll) {
      if (!rolesNeeded.every(role => userRoles.includes(role))) {
        reply.status(403).send({ error: 'Forbidden' });
        return false;
      }
    } else if (!request.user.roles.some(role => rolesNeeded.includes(role))) {
      reply.status(403).send({ error: 'Forbidden' });
      return false;
    }

    return true;
  }
}