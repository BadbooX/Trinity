import { FastifyRequest, FastifyReply, FastifyInstance } from 'fastify';
import bcrypt from 'bcrypt';
import crypto from 'crypto';
import jwt, { JwtPayload } from 'jsonwebtoken';
import { RegisterAuthData, LoginAuthData } from '../routes/auth';
import { Role } from '@prisma/client';

let JWT_SECRET: string;

// On import, check if needed environment variables are set
if (!process.env.JWT_SECRET) {
    throw new Error('JWT_SECRET env variable is not set');
} else
    JWT_SECRET = process.env.JWT_SECRET;


export async function loginAuth(
  request: FastifyRequest< { Body: LoginAuthData } >,
  reply: FastifyReply, 
  fastify: FastifyInstance) {
  let data = request.body;

  // get user by email
  const user = await fastify.prisma.user.findUnique({
    where: {
      email: data.email
    }
  });

  if (!user) {
    reply.code(401).send({ message: 'Invalid email or password' });
    return
  }

  // check password
  const passwordMatch = bcrypt.compare(data.password, user.password);

  if (!passwordMatch) {
    reply.code(401).send({ message: 'Invalid email or password' });
    return
  }

  const token = crypto.randomBytes(128).toString('hex');

  // save token in db
  await fastify.prisma.jwt.create({
    data: {
      token: token,
      user: {
        connect: {
          id: user.id
        }
      }
    }
  });

  // generate token 
  const newJwt = jwt.sign({ 
    id: user.id, 
    token: token 
  }, JWT_SECRET,{ expiresIn: '60d' });

  reply.code(201).send({ message: 'Logged in', token: newJwt });
}

export async function registerAuth(
  request: FastifyRequest< { Body: RegisterAuthData } >,
  reply: FastifyReply,
  fastify: FastifyInstance
) {



  let data = request.body;
  // check if email is already used and if create user if not
  const user = await fastify.prisma.user.findUnique({
    where: {
      email: data.email
    },    
  });

  if (user) {
    reply.code(409).send({ message: 'Email already used' });
    return
  }

  // password hashing
  data.password = await bcrypt.hash(data.password, 10);

  // create user
  const newUser = await fastify.prisma.user.create({
    data: {
      firstName: data.firstName,
      lastName: data.lastName,
      email: data.email,
      phoneNumber: data.phone,
      password: data.password,
      roles: [Role.CUSTOMER]
    }
  });

  reply.code(201).send({ message: 'User created' });
}

function validatePassword(password: string): boolean {
  // Password must be at least 8 characters long and contain at least one number, minu one uppercase letter and one lowercase letter and one special character
  return /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}$/.test(password);
}