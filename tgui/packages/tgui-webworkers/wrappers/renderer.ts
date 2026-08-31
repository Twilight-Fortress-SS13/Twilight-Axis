import type { RendererWorker, TguiWorker } from 'tgui-webworkers/types';

const renderWorker = new Worker(
  new URL('tgui-webworkers/workers/renderer_worker.ts', import.meta.url),
  {
    name: 'renderer_worker',
  },
) as TguiWorker<RendererWorker.RenderRequest, RendererWorker.RenderResponse>;

const savedBlobs: Record<string, Blob> = {};
const render = async (
  id: string,
  iconRef: string,
  iconStates: string[],
  offsetX: number,
  imageSize: number,
) => {
  if (id in savedBlobs) {
    return savedBlobs[id];
  }

  const response = new Promise<Blob>((resolve, reject) => {
    const cleanup = () => {
      renderWorker.removeEventListener('message', onMessage);
      renderWorker.removeEventListener('error', onError);
    };

    const onMessage = (e: MessageEvent<RendererWorker.RenderResponse>) => {
      if (e.data.id !== id) {
        return;
      }

      cleanup();
      savedBlobs[id] = e.data.blob;
      resolve(e.data.blob);
    };

    const onError = (err: any) => {
      cleanup();
      reject(err);
    };

    renderWorker.addEventListener('message', onMessage);
    renderWorker.addEventListener('error', onError);
  });

  const req: RendererWorker.RenderRequest = {
    id,
    iconRef,
    iconStates,
    offsetX,
    imageSize,
  };

  try {
    renderWorker.postMessage(req);
  } catch (error) {
    return Promise.reject(error);
  }

  return response;
};

export const renderer = {
  render,
};
