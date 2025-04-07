import { FastifyRequest, FastifyReply, FastifyInstance } from "fastify";
import { CreateProductData, UpdateProductData } from "../routes/products";

export async function getProducts(
  request: FastifyRequest,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let products = await fastify.prisma.product.findMany({
    select: {
      id: true,
      barCode: true,
      name: true,
      priceHT: true,
      priceTVA: true,
      priceTTC: true,
      stock: true,
      Shop: {
        select: {
          id: true,
          name: true,
        },
      },
    },
  });

  return products;
}

export async function getProductsByShop(
  request: FastifyRequest<{ Params: { shopId: number } }>,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let products = await fastify.prisma.product.findMany({
    where: {
      idShop: request.params.shopId,
    },
    select: {
      id: true,
      barCode: true,
      name: true,
      priceHT: true,
      priceTVA: true,
      priceTTC: true,
      stock: true,
      Shop: {
        select: {
          id: true,
          name: true,
        },
      },
    },
  });

  return products;
}

export async function getProductById(
  request: FastifyRequest<{ Params: { productId: number } }>,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let product = await fastify.prisma.product.findUnique({
    where: {
      id: request.params.productId,
    },
    select: {
      id: true,
      barCode: true,
      name: true,
      priceHT: true,
      priceTVA: true,
      priceTTC: true,
      stock: true,
      Shop: {
        select: {
          id: true,
          name: true,
        },
      },
    },
  });

  if (!product) {
    reply.code(404).send({ message: "Product not found" });
    return;
  }

  return product;
}

export async function getProductByBarCode(
  request: FastifyRequest<{ Params: { barCode: string }}>,
  reply: FastifyReply, 
  fastify: FastifyInstance
) {

  if (isNaN(Number(request.params.barCode))) {
    return reply.code(400).send({ message: 'barcode is not a number'});
  }

  let products = await fastify.prisma.product.findMany({
    where: {
      barCode: request.params.barCode
    },
    select: {
      id: true,
      barCode: true,
      name: true,
      priceHT: true,
      priceTVA: true,
      priceTTC: true,
      stock: true,
      Shop: {
        select: {
          id: true,
          name: true,
        },
      }
    }
  });

  if (products.length == 0) {
    return reply.code(404).send({ message: 'Product not found' });

  }

  return reply.send(products);
}


export async function addProduct(
  request: FastifyRequest<{
    Params: { shopId: number };
    Body: CreateProductData;
  }>,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let data = request.body;

  let product = await fastify.prisma.product.create({
    data: {
      idShop: request.params.shopId,
      barCode: data.barCode,

      name: data.name,
      priceHT: data.priceHT,
      priceTVA: data.priceTVA,
      priceTTC: data.priceTTC,
      stock: data.stock,
    },
  });

  reply.code(201).send({
    message: "Product created",
    product: product,
  });
}

export async function updateProduct(
  request: FastifyRequest<{
    Params: { productId: number };
    Body: UpdateProductData;
  }>,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  let data = request.body;

  const product = await fastify.prisma.product.update({
    where: {
      id: request.params.productId,
    },
    data: {
      barCode: data.barCode ?? undefined,

      name: data.name ?? undefined,
      stock: data.stock ?? undefined,
      priceHT: data.priceHT ?? undefined,
      priceTVA: data.priceTVA ?? undefined,
      priceTTC: data.priceTTC ?? undefined,
    },
  });

  reply.send({
    message: "Product updated",
    product: product,
  });
}

export async function deleteProduct(
  request: FastifyRequest<{ Params: { productId: number } }>,
  reply: FastifyReply,
  fastify: FastifyInstance
) {
  const product = await fastify.prisma.product.findUnique({
    where: {
      id: request.params.productId,
    },
  });

  if (!product) {
    reply.code(404).send({ message: "Product not found" });
    return;
  }

  await fastify.prisma.product.delete({
    where: {
      id: request.params.productId,
    },
  });

  reply.code(204).send({
    message: "Product deleted",
    product: product,
  });
}
