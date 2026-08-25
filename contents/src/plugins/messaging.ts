import fp from 'fastify-plugin';
import type { FastifyPluginAsync } from 'fastify';
import Pulsar from 'pulsar-client';
import { settings } from '../settings';

declare module 'fastify' {
  interface FastifyInstance {
    producer: Pulsar.Producer;
  }
}

const messagingPlugin: FastifyPluginAsync = async (fastify) => {
  const client = new Pulsar.Client({ serviceUrl: settings.messagingBrokerUrl });
  const producer = await client.createProducer({ topic: settings.messagingTopic });
  fastify.decorate('producer', producer);
  fastify.addHook('onClose', async () => {
    await producer.close();
    await client.close();
  });
};

export default fp(messagingPlugin, { name: 'messaging' });
