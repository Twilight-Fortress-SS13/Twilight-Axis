import { useRef, useState, useEffect } from 'react';
import { Button, Section, Stack, Slider, ColorBox, Tooltip } from 'tgui-core/components';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

type Data = {
  canvas_name: string;
  canvas_data?: string;
};

type Layer = {
  id: number;
  name: string;
  visible: boolean;
  pixels: Record<string, string>;
};

export const CanvasPainter = (props) => {
  const { act, data } = useBackend<Data>();
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const baseImgRef = useRef<HTMLImageElement | null>(null);

  const [isDrawing, setIsDrawing] = useState(false);
  const [color, setColor] = useState('#000000');
  const [pickerColor, setPickerColor] = useState('#000000');
  const [opacity, setOpacity] = useState(100);
  const [brushSize, setBrushSize] = useState(1);
  const [tool, setTool] = useState<'brush' | 'eraser' | 'bucket'>('brush');

  const [colorHistory, setColorHistory] = useLocalState<string[]>('canvas_color_hist', ['#000000', '#ffffff', '#ff0000', '#00ff00', '#0000ff']);
  const [layers, setLayers] = useLocalState<Layer[]>('canvas_layers_v3', [{ id: Date.now(), name: 'Слой 1', visible: true, pixels: {} }]);
  const [activeLayerId, setActiveLayerId] = useLocalState<number>('canvas_active_layer', layers[0].id);

  useEffect(() => {
    if (data.canvas_data) {
      const img = new Image();
      img.src = `data:image/png;base64,${data.canvas_data}`;
      img.onload = () => { baseImgRef.current = img; renderCanvas(); };
    } else {
      baseImgRef.current = null;
      renderCanvas();
    }
  }, [data.canvas_data]);

  useEffect(() => { renderCanvas(); }, [layers]);

  const renderCanvas = () => {
    const ctx = canvasRef.current?.getContext('2d');
    if (!ctx) return;
    ctx.clearRect(0, 0, 32, 32);
    ctx.fillStyle = '#f5e8d3';
    ctx.fillRect(0, 0, 32, 32);
    if (baseImgRef.current) ctx.drawImage(baseImgRef.current, 0, 0, 32, 32);

    layers.forEach(layer => {
      if (!layer.visible) return;
      Object.entries(layer.pixels).forEach(([coord, col]) => {
        const [x, y] = coord.split(',').map(Number);
        ctx.fillStyle = col as string;
        ctx.fillRect(x - 1, 32 - y, 1, 1);
      });
    });
  };

  const getCoords = (e: React.MouseEvent) => {
    const rect = canvasRef.current!.getBoundingClientRect();
    return {
      x: Math.floor((e.clientX - rect.left) * (32 / rect.width)),
      y: Math.floor((e.clientY - rect.top) * (32 / rect.height)),
    };
  };

  const getDrawColor = () => {
    if (opacity >= 100) return color;
    const alphaHex = Math.floor((opacity / 100) * 255).toString(16).padStart(2, '0');
    return `${color}${alphaHex}`;
  };

  const handleColorChange = (newColor: string) => {
    setColor(newColor);
    setPickerColor(newColor);
    setTool('brush');
    if (!colorHistory.includes(newColor)) {
      setColorHistory([newColor, ...colorHistory].slice(0, 8));
    }
  };

  const performFill = (startX: number, startY: number) => {
    const layer = layers.find(l => l.id === activeLayerId);
    if (!layer?.visible) return;

    const targetCoord = `${startX + 1},${32 - startY}`;
    const targetColor = layer.pixels[targetCoord] || null;
    const newColor = getDrawColor();

    if (targetColor === newColor) return;

    const newPixels = { ...layer.pixels };
    const queue = [[startX, startY]];
    const visited = new Set<string>();

    while (queue.length > 0) {
      const [cx, cy] = queue.shift()!;
      if (cx < 0 || cx >= 32 || cy < 0 || cy >= 32) continue;

      const byondX = cx + 1;
      const byondY = 32 - cy;
      const key = `${byondX},${byondY}`;

      if (visited.has(key)) continue;
      visited.add(key);

      const currentColor = newPixels[key] || null;
      if (currentColor === targetColor) {
        newPixels[key] = newColor;
        queue.push([cx + 1, cy], [cx - 1, cy], [cx, cy + 1], [cx, cy - 1]);
      }
    }

    setLayers(layers.map(l => l.id === activeLayerId ? { ...l, pixels: newPixels } : l));
  };

  const applyBrush = (htmlX: number, htmlY: number) => {
    if (tool === 'bucket') return;

    const offset = Math.floor((brushSize - 1) / 2);
    const drawCol = getDrawColor();

    setLayers(layers.map(layer => {
      if (layer.id !== activeLayerId) return layer;

      const newPixels = { ...layer.pixels };

      for (let dx = -offset; dx <= offset + (brushSize % 2 === 0 ? 1 : 0); dx++) {
        for (let dy = -offset; dy <= offset + (brushSize % 2 === 0 ? 1 : 0); dy++) {
          const px = htmlX + dx;
          const py = htmlY + dy;
          if (px < 0 || px >= 32 || py < 0 || py >= 32) continue;

          const coord = `${px + 1},${32 - py}`;
          if (tool === 'eraser') delete newPixels[coord];
          else newPixels[coord] = drawCol;
        }
      }
      return { ...layer, pixels: newPixels };
    }));
  };

  const handleMouseDown = (e: React.MouseEvent) => {
    const { x, y } = getCoords(e);
    if (tool === 'bucket') {
      performFill(x, y);
    } else {
      setIsDrawing(true);
      applyBrush(x, y);
    }
  };

  const handleMouseMove = (e: React.MouseEvent) => {
    if (!isDrawing) return;
    const { x, y } = getCoords(e);
    applyBrush(x, y);
  };

  const handleMouseUp = () => setIsDrawing(false);

  const handleSave = () => {
    const canvas = canvasRef.current;
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const imgData = ctx.getImageData(0, 0, 32, 32).data;

    const palette: string[] = [];
    let pixelString = '';

    for (let y = 1; y <= 32; y++) {
      const htmlY = 32 - y;
      for (let x = 1; x <= 32; x++) {
        const htmlX = x - 1;

        const idx = (htmlY * 32 + htmlX) * 4;
        const r = imgData[idx];
        const g = imgData[idx + 1];
        const b = imgData[idx + 2];

        const colorHex = '#' + [r, g, b].map(v => v.toString(16).padStart(2, '0')).join('');

        let colorIdx = palette.indexOf(colorHex);
        if (colorIdx === -1) {
          if (palette.length < 256) {
            palette.push(colorHex);
            colorIdx = palette.length - 1;
          } else {
            colorIdx = 0;
          }
        }

        pixelString += colorIdx.toString(16).padStart(2, '0');
      }
    }

    act('save_painting', {
      palette: palette,
      pixels: pixelString
    });

    const resetId = Date.now();
    setLayers([{ id: resetId, name: 'Слой 1', visible: true, pixels: {} }]);
    setActiveLayerId(resetId);
  };

  const addLayer = () => {
    const newId = Date.now();
    setLayers([...layers, { id: newId, name: `Слой ${layers.length + 1}`, visible: true, pixels: {} }]);
    setActiveLayerId(newId);
  };

  const deleteLayer = (id: number) => {
    if (layers.length <= 1) return;
    const newLayers = layers.filter(l => l.id !== id);
    setLayers(newLayers);
    if (activeLayerId === id) setActiveLayerId(newLayers[0].id);
  };

  const toggleLayerVisibility = (id: number) => {
    setLayers(layers.map(l => l.id === id ? { ...l, visible: !l.visible } : l));
  };

  return (
    <Window width={600} height={520} title={data.canvas_name || 'Canvas Painter'}>
      <Window.Content>
        <Stack fill>
          <Stack.Item grow>
            <Stack vertical fill align="center">
              <Stack.Item mt={1}>
                <Section>
                  <canvas
                    ref={canvasRef}
                    width={32}
                    height={32}
                    onMouseDown={handleMouseDown}
                    onMouseMove={handleMouseMove}
                    onMouseUp={handleMouseUp}
                    onMouseLeave={handleMouseUp}
                    style={{ width: '320px', height: '320px', border: '2px solid rgba(0,0,0,0.5)', imageRendering: 'pixelated', cursor: 'crosshair', backgroundColor: '#f5e8d3' }}
                  />
                </Section>
              </Stack.Item>

              <Stack.Item width="100%">
                <Section>
                  <Stack align="center" justify="space-between">
                    <Stack.Item>
                      <Stack vertical>
                        <Stack.Item>
                          <Stack align="center">
                            <input type="color" value={pickerColor} onChange={(e) => setPickerColor(e.target.value)} style={{ cursor: 'pointer', height: '24px', width: '24px', padding: 0, border: 'none' }} />
                            <Button icon="check" onClick={() => handleColorChange(pickerColor)} tooltip="Применить цвет" />
                            {colorHistory.map((c, i) => (
                              <ColorBox key={i} color={c.substring(0, 7)} onClick={() => handleColorChange(c.substring(0, 7))} style={{ cursor: 'pointer', border: color === c.substring(0, 7) ? '2px solid white' : '1px solid black' }} />
                            ))}
                          </Stack>
                        </Stack.Item>
                        <Stack.Item mt={1}>
                          <Stack align="center">
                            <Button icon="paint-brush" selected={tool === 'brush'} onClick={() => setTool('brush')} tooltip="Кисть" />
                            <Button icon="fill" selected={tool === 'bucket'} onClick={() => setTool('bucket')} tooltip="Заливка" />
                            <Button icon="eraser" selected={tool === 'eraser'} onClick={() => setTool('eraser')} tooltip="Ластик" />
                          </Stack>
                        </Stack.Item>
                      </Stack>
                    </Stack.Item>

                    <Stack.Item width="150px">
                      <Stack vertical>
                        <Stack.Item>
                          <Tooltip content="Толщина кисти">
                            <Stack align="center">
                              <span style={{ fontSize: '10px', width: '20px' }}>px {brushSize}</span>
                              <Slider value={brushSize} minValue={1} maxValue={5} stepPixelSize={25} step={1} onChange={(_, v) => setBrushSize(v)} />
                            </Stack>
                          </Tooltip>
                        </Stack.Item>
                        <Stack.Item>
                          <Tooltip content="Плотность (Прозрачность)">
                            <Stack align="center">
                              <span style={{ fontSize: '10px', width: '20px' }}>% {opacity}</span>
                              <Slider value={opacity} minValue={10} maxValue={100} stepPixelSize={8} step={10} onChange={(_, v) => setOpacity(v)} />
                            </Stack>
                          </Tooltip>
                        </Stack.Item>
                      </Stack>
                    </Stack.Item>

                    <Stack.Item>
                      <Button color="good" icon="save" onClick={handleSave}>Закончить</Button>
                    </Stack.Item>
                  </Stack>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item width="160px">
            <Section title="Слои" fill buttons={<Button icon="plus" onClick={addLayer} tooltip="Новый слой" />}>
              <Stack vertical>
                {[...layers].reverse().map(layer => (
                  <Stack.Item key={layer.id}>
                    <div onClick={() => setActiveLayerId(layer.id)} style={{ padding: '4px', border: '1px solid rgba(255,255,255,0.1)', backgroundColor: activeLayerId === layer.id ? 'rgba(255, 255, 255, 0.2)' : 'transparent', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                      <Button icon={layer.visible ? 'eye' : 'eye-slash'} color="transparent" onClick={(e) => { e.stopPropagation(); toggleLayerVisibility(layer.id); }} />
                      <span style={{ flexGrow: 1, marginLeft: '8px', opacity: layer.visible ? 1 : 0.5 }}>{layer.name}</span>
                      {layers.length > 1 && <Button icon="trash" color="transparent" onClick={(e) => { e.stopPropagation(); deleteLayer(layer.id); }} />}
                    </div>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
