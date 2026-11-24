import { useState } from 'react';

const setWindowBox = (width: number, height: number, expanded: boolean) => {
  const scale = window.devicePixelRatio || 1;
  const screenWidth = Math.floor(window.screen.availWidth * scale);
  const screenHeight = Math.floor(window.screen.availHeight * scale);
  const boxWidth = expanded ? screenWidth : Math.min(width, screenWidth);
  const boxHeight = expanded ? screenHeight : Math.min(height, screenHeight);
  const x = Math.max(Math.floor((screenWidth - boxWidth) / 2), 0);
  const y = Math.max(Math.floor((screenHeight - boxHeight) / 2), 0);

  Byond.winset(Byond.windowId, {
    pos: `${x},${y}`,
    size: `${boxWidth}x${boxHeight}`,
  });
};

export const useWindowExpand = (width: number, height: number) => {
  const [expanded, setExpanded] = useState(false);

  const toggle = () => {
    setWindowBox(width, height, !expanded);
    setExpanded(!expanded);
  };

  return [expanded, toggle] as const;
};
