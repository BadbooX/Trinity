import { FastifyInstance, FastifyPluginAsync } from 'fastify';

import { getOrders, addInvoice, updateOrder, deleteOrder, getShopOrders } from "../controllers/orders";

const authRoutes: FastifyPluginAsync = async (fastify: FastifyInstance) => {
    fastify.get('/orders', async (request, reply) => {
        return getOrders(request, reply, fastify);
    });

    fastify.post('/orders', async (request, reply) => {
        return addInvoice(request, reply, fastify);
    });

    fastify.put('/orders/:id', async (request, reply) => {
        return updateOrder(request, reply, fastify);
    });

    fastify.delete('/orders/:id', async (request, reply) => {
        return deleteOrder(request, reply, fastify);
    });

    fastify.get('/:shopId/orders', async (request, reply) => {
        return getShopOrders(request, reply, fastify);
    });
}

export default authRoutes;