import Pulsar from 'pulsar-client';
import { settings } from '../settings';

let _client: Pulsar.Client | null = null;
let _producer: Pulsar.Producer | null = null;

export async function initResource(): Promise<void> {
  _client = new Pulsar.Client({ serviceUrl: settings.messagingBrokerUrl });
  _producer = await _client.createProducer({ topic: settings.messagingTopic });
}

export async function closeResource(): Promise<void> {
  if (_producer) {
    await _producer.close();
    _producer = null;
  }
  if (_client) {
    await _client.close();
    _client = null;
  }
}

export function getProducer(): Pulsar.Producer {
  if (!_producer) throw new Error('Messaging not initialized');
  return _producer;
}
