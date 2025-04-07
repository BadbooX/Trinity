import { FastifyRequest, FastifyReply, FastifyInstance } from 'fastify';
import { CreateProductData, UpdateProductData } from '../routes/products';


export async function getProducts(request: FastifyRequest, reply: FastifyReply, fastify: FastifyInstance) {
  let products = await fastify.prisma.product.findMany();

  return products;
}


export async function getProductsByShop(
  request: FastifyRequest<{ Params: { shopId: number }}>,
  reply: FastifyReply, 
  fastify: FastifyInstance
) {
  let products = await fastify.prisma.product.findMany({
    where: {
      idShop: request.params.shopId
    }
  });

  return products;
}


export async function getProductById(
  request: FastifyRequest<{ Params: { productId: number }}>,
  reply: FastifyReply, 
  fastify: FastifyInstance
) {
  let product = await fastify.prisma.product.findUnique({
    where: {
      id: request.params.productId
    }
  });

  if (!product) {
    reply.code(404).send({ message: 'Product not found' });
    return
  }

  return product;
}


export async function addProduct(
  request: FastifyRequest<{ Params: { shopId: number }, Body: CreateProductData }>,
  reply: FastifyReply, 
  fastify: FastifyInstance
) {
  let data = request.body;

  let product = await fastify.prisma.product.create({
    data: {
      idShop: request.params.shopId,
      barCode: data.barCode,

      name: data.name,
      price: data.price,
      quantity: data.quantity,
    }
  });

  reply.code(201).send({ 
    message: 'Product created', 
    product: product 
  });
}


export async function updateProduct(
  request: FastifyRequest<{ Params: { productId: number }, Body: UpdateProductData }>,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let data = request.body;

  const product = await fastify.prisma.product.update({
    where: {
      id: request.params.productId
    },
    data: {
      barCode: data.barCode ?? undefined,

      name: data.name ?? undefined,
      price: data.price ?? undefined,
      quantity: data.quantity ?? undefined,
    }
  });

  reply.send({ 
    message: 'Product updated', 
    product: product 
  });
}


export async function deleteProduct(
  request: FastifyRequest<{ Params: { productId: number }}>,
  reply: FastifyReply, 
  fastify: FastifyInstance
) {
  const product = await fastify.prisma.product.findUnique({
    where: {
      id: request.params.productId
    }
  });

  if (!product) {
    reply.code(404).send({ message: 'Product not found' });
    return;
  }

  await fastify.prisma.product.delete({
    where: {
      id: request.params.productId
    }
  });

  reply.code(204).send({ 
    message: 'Product deleted', 
    product: product 
  });
}