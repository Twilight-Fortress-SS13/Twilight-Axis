import type {
  RenderRequest,
  RenderResponse,
} from 'tgui-webworkers/types/renderer_worker';

const getImage = async (url: string): Promise<ImageBitmap> => {
  const res = await fetch(url);
  const blob = await res.blob();
  return await self.createImageBitmap(blob);
};

const loadedImages: Record<string, ImageBitmap> = {};
const getImageRetry = async (
  url: string,
  retries: number,
): Promise<ImageBitmap> => {
  if (url in loadedImages) {
    return loadedImages[url];
  }

  try {
    const image = await getImage(url);
    loadedImages[url] = image;
    return image;
  } catch (e) {
    if (retries > 0) {
      return await getImageRetry(url, retries - 1);
    }
    throw e;
  }
};

const normalizeImageSize = (value: unknown): number => {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return 1;
  }

  return Math.max(1, Math.min(4096, Math.floor(value)));
};

const normalizeOffsetX = (value: unknown): number => {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return 16;
  }

  return value;
};

const makeFallbackBlob = async (): Promise<Blob> => {
  const canvas = new OffscreenCanvas(1, 1);
  return await canvas.convertToBlob({ type: 'image/webp', quality: 1.0 });
};

self.onmessage = async (e: MessageEvent<RenderRequest>) => {
  const id = typeof e.data?.id === 'string' ? e.data.id : '';

  try {
    const imageSize = normalizeImageSize(e.data?.imageSize);
    const offsetX = normalizeOffsetX(e.data?.offsetX);
    const iconRef = typeof e.data?.iconRef === 'string' ? e.data.iconRef : '';
    const iconStates = Array.isArray(e.data?.iconStates)
      ? e.data.iconStates.filter((state): state is string => typeof state === 'string')
      : [];

    const canvas = new OffscreenCanvas(imageSize, imageSize);
    const ctx = canvas.getContext('2d', { alpha: true })!;
    // Pixel art please
    ctx.imageSmoothingEnabled = false;

    // Load and smash all states in order
    for (const state of iconStates) {
      let image: ImageBitmap;
      try {
        image = await getImageRetry(`${iconRef}?state=${state}&dir=2&frame=1`, 3);
      } catch (e) {
        ctx.fillStyle = '#ff0000';
        ctx.fillRect(0, 0, imageSize, imageSize);
        break;
      }

      // calculating new offset via centerline
      const aspectRatio = image.width / image.height;
      // we cannot use image.width because our resize caps based on height,
      // and we allow width to exceed bounds
      const resizeRatio = imageSize / image.height;

      // Step 1: offsetX moves centerline to x = 16 (because world.icon_size = 32)
      // so to move it to zero, we have to subtract 16
      const originalToZero = offsetX - 16;
      // Step 2: To move our resized box's centerline to 0, we have to scale
      // originalToZero by the resize ratio
      const resizedtoZero = originalToZero * resizeRatio;
      // Step 3: Our target centerline is always imageSize / 2, so we just add
      // that back in to transform our centerline-zero image to the correct location
      const offsetToUse = resizedtoZero + imageSize / 2;

      // Draw the image to the canvas
      ctx.drawImage(image, offsetToUse, 0, imageSize * aspectRatio, imageSize);
    }

    const blob = await canvas.convertToBlob({ type: 'image/webp', quality: 1.0 });
    const res: RenderResponse = { id, blob };
    self.postMessage(res);
  } catch (e) {
    const blob = await makeFallbackBlob();
    const res: RenderResponse = { id, blob };
    self.postMessage(res);
  }
};
