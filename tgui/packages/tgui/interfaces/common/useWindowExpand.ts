import { useState } from 'react';

import { useBackend } from '../../backend';
import { recallWindowGeometry } from '../../drag';

const fillScreen = () => {
  const pixelRatio = window.devicePixelRatio || 1;
  const screenWidth = Math.floor(window.screen.availWidth * pixelRatio);
  const screenHeight = Math.floor(window.screen.availHeight * pixelRatio);

  Byond.winset(Byond.windowId, {
    pos: '0,0',
    size: `${screenWidth}x${screenHeight}`,
  });
};

export const useWindowExpand = (width: number, height: number) => {
  const { config } = useBackend();
  const [expanded, setExpanded] = useState(false);

  const toggle = () => {
    if (expanded) {
      const { locked, scale } = config.window;
      recallWindowGeometry({ size: [width, height], locked, scale });
    } else {
      fillScreen();
    }
    setExpanded(!expanded);
  };

  return [expanded, toggle] as const;
};
