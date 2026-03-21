/**
 * Browser-agnostic abstraction of key-value web storage.
 *
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const IMPL_MEMORY = 0;
export const IMPL_HUB_STORAGE = 1;

type StorageImplementation = typeof IMPL_MEMORY | typeof IMPL_HUB_STORAGE;

const KEY_NAME = 'azure';

type StorageBackend = {
  impl: StorageImplementation;
  get(key: string): Promise<any>;
  set(key: string, value: any): Promise<void>;
  remove(key: string): Promise<void>;
  clear(): Promise<void>;
};

const testGeneric = (testFn: () => boolean) => (): boolean => {
  try {
    return Boolean(testFn());
  } catch (error) {
    console.error('Storage backend test failed:', error);
    return false;
  }
};

const testHubStorage = testGeneric(() => {
  const exists = !!window.hubStorage;
  const hasGetter = !!window.hubStorage?.getItem;
  const hasSetter = !!window.hubStorage?.setItem;

  console.log('[storage] hubStorage exists:', exists);
  console.log('[storage] hubStorage has getItem:', hasGetter);
  console.log('[storage] hubStorage has setItem:', hasSetter);

  return exists && hasGetter && hasSetter;
});

class MemoryBackend implements StorageBackend {
  private store: Record<string, any>;
  public impl: StorageImplementation;

  constructor() {
    this.impl = IMPL_MEMORY;
    this.store = {};
  }

  async get(key: string): Promise<any> {
    const value = this.store[key];
    console.log('[storage:memory] get', key, value);
    return value;
  }

  async set(key: string, value: any): Promise<void> {
    console.log('[storage:memory] set', key, value);
    this.store[key] = value;
  }

  async remove(key: string): Promise<void> {
    console.log('[storage:memory] remove', key);
    this.store[key] = undefined;
  }

  async clear(): Promise<void> {
    console.log('[storage:memory] clear');
    this.store = {};
  }
}

class HubStorageBackend implements StorageBackend {
  public impl: StorageImplementation;

  constructor() {
    this.impl = IMPL_HUB_STORAGE;
  }

  async get(key: string): Promise<any> {
    const fullKey = `${KEY_NAME}-${key}`;
    try {
      const value = await window.hubStorage.getItem(fullKey);
      console.log('[storage:hub] raw get', fullKey, value);

      if (typeof value === 'string') {
        try {
          const parsed = JSON.parse(value);
          console.log('[storage:hub] parsed get', fullKey, parsed);
          return parsed;
        } catch (error) {
          console.error('[storage:hub] failed to parse JSON for', fullKey, value, error);
          return undefined;
        }
      }

      return undefined;
    } catch (error) {
      console.error('[storage:hub] get failed for', fullKey, error);
      return undefined;
    }
  }

  async set(key: string, value: any): Promise<void> {
    const fullKey = `${KEY_NAME}-${key}`;
    try {
      const serialized = JSON.stringify(value);
      console.log('[storage:hub] set', fullKey, value);
      await window.hubStorage.setItem(fullKey, serialized);
    } catch (error) {
      console.error('[storage:hub] set failed for', fullKey, value, error);
    }
  }

  async remove(key: string): Promise<void> {
    const fullKey = `${KEY_NAME}-${key}`;
    try {
      console.log('[storage:hub] remove', fullKey);
      await window.hubStorage.removeItem(fullKey);
    } catch (error) {
      console.error('[storage:hub] remove failed for', fullKey, error);
    }
  }

  async clear(): Promise<void> {
    try {
      console.log('[storage:hub] clear');
      await window.hubStorage.clear();
    } catch (error) {
      console.error('[storage:hub] clear failed', error);
    }
  }
}

/**
 * Web Storage Proxy object, which selects the best backend available
 * depending on the environment.
 */
class StorageProxy implements StorageBackend {
  private backendPromise: Promise<StorageBackend>;
  public impl: StorageImplementation = IMPL_MEMORY;

  constructor() {
    this.backendPromise = (async () => {
      if (testHubStorage()) {
        this.impl = IMPL_HUB_STORAGE;
        console.log('[storage] Selected backend: HUB_STORAGE');
        return new HubStorageBackend();
      }

      this.impl = IMPL_MEMORY;
      console.warn(
        '[storage] No supported storage backend found. Using in-memory storage.',
      );
      return new MemoryBackend();
    })();
  }

  async get(key: string): Promise<any> {
    const backend = await this.backendPromise;
    return backend.get(key);
  }

  async set(key: string, value: any): Promise<void> {
    const backend = await this.backendPromise;
    return backend.set(key, value);
  }

  async remove(key: string): Promise<void> {
    const backend = await this.backendPromise;
    return backend.remove(key);
  }

  async clear(): Promise<void> {
    const backend = await this.backendPromise;
    return backend.clear();
  }
}

export const storage = new StorageProxy();
