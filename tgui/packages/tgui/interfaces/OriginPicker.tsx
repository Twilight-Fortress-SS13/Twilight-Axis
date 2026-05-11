import { CSSProperties, ReactNode, useEffect, useMemo, useState } from 'react';
import { Button, Section, Stack } from 'tgui-core/components';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Origin = {
  name: string;
  display_name: string;
  origin_name: string;
  type: string;
  desc: string;
  origin_desc: string;
  selected: boolean;
  available: boolean;
  required_races_text?: string | null;
  language_text?: string | null;
  trait_text?: string | null;
  state_id: string;
  state_name: string;
  subgroup_name?: string | null;
  item_order?: number;
};

type MapState = {
  id: string;
  name: string;
  on_map: boolean;
  x: number;
  y: number;
  selected: boolean;
  origins: Origin[];
};

type ListEntry = {
  id: string;
  name: string;
  selected: boolean;
  items: Origin[];
};

type Group = {
  name: string;
  is_off_map: boolean;
  entries: ListEntry[];
};

type Data = {
  groups: Group[];
  map_states: MapState[];
  current_origin_type: string | null;
  current_species_name: string;
};

const MARKER_SIZE = 12;

const markerStyle = (
  isFocused: boolean,
  isSelected: boolean,
  isAvailable: boolean,
): CSSProperties => ({
  position: 'absolute',
  width: `${MARKER_SIZE}px`,
  height: `${MARKER_SIZE}px`,
  minWidth: `${MARKER_SIZE}px`,
  minHeight: `${MARKER_SIZE}px`,
  padding: 0,
  margin: 0,
  borderRadius: '50%',
  border: `1px solid ${isSelected ? '#111111' : isFocused ? '#d2c3ff' : isAvailable ? '#2d2d2d' : '#555555'}`,
  backgroundColor: isSelected
    ? '#d4af37'
    : !isAvailable
      ? '#666666'
      : isFocused
        ? '#b88cff'
        : '#6a55af',
  boxShadow: isFocused ? '0 0 8px rgba(184, 140, 255, 0.75)' : 'none',
  cursor: 'pointer',
  opacity: isAvailable ? 1 : 0.82,
  transform: 'translate(-50%, -50%)',
  appearance: 'none',
  outline: 'none',
  display: 'block',
  lineHeight: 0,
  fontSize: 0,
});

const listButtonStyle = (isAvailable: boolean): CSSProperties | undefined =>
  !isAvailable
    ? {
        background: 'rgba(110, 110, 110, 0.22)',
        color: '#c8c8c8',
        borderColor: 'rgba(255,255,255,0.08)',
        opacity: 0.95,
      }
    : undefined;

const renderOriginButtonContent = (origin: Origin, label?: string) => (
  <div
    style={{
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'flex-start',
      gap: '0.15rem',
      whiteSpace: 'normal',
    }}>
    <div>{label || origin.display_name}</div>
    {!origin.available && origin.required_races_text && (
      <div style={{ fontSize: '0.74rem', opacity: 0.9, lineHeight: 1.25 }}>
        Нужны расы: {origin.required_races_text}
      </div>
    )}
  </div>
);

const renderHtmlNode = (node: ChildNode, key: string): ReactNode => {
  if (node.nodeType === Node.TEXT_NODE) {
    return node.textContent;
  }

  if (node.nodeType !== Node.ELEMENT_NODE) {
    return null;
  }

  const element = node as HTMLElement;
  const tag = element.tagName.toLowerCase();
  const children = Array.from(element.childNodes).map((child, index) =>
    renderHtmlNode(child, `${key}-${index}`),
  );

  switch (tag) {
    case 'br':
      return <br key={key} />;
    case 'b':
    case 'strong':
      return <b key={key}>{children}</b>;
    case 'i':
    case 'em':
      return <i key={key}>{children}</i>;
    case 'u':
      return <u key={key}>{children}</u>;
    case 'a': {
      const href = element.getAttribute('href') || '#';
      return (
        <a key={key} href={href} target="_blank" rel="noreferrer">
          {children}
        </a>
      );
    }
    default:
      return <span key={key}>{children}</span>;
  }
};

const renderOriginDescription = (value?: string | null): ReactNode => {
  if (!value) {
    return null;
  }

  const cleaned = value
    .replace(/\r\n/g, '\n')
    .replace(/^(?:\s|<br\s*\/?>)+/gi, '')
    .trimStart();

  const normalized = cleaned.replace(/\n/g, '<br />');
  const parser = new DOMParser();
  const document = parser.parseFromString(`<div>${normalized}</div>`, 'text/html');
  const root = document.body.firstElementChild;

  if (!root) {
    return normalized;
  }

  return Array.from(root.childNodes).map((node, index) =>
    renderHtmlNode(node, `origin-desc-${index}`),
  );
};

export const OriginPicker = () => {
  const { act, data } = useBackend<Data>();
  const { groups, map_states, current_origin_type, current_species_name } = data;

  const originsByType = useMemo(() => {
    const index: Record<string, Origin> = {};
    for (const state of map_states) {
      for (const origin of state.origins) {
        index[origin.type] = origin;
      }
    }
    return index;
  }, [map_states]);

  const selectedOrigin =
    (current_origin_type && originsByType[current_origin_type]) ||
    Object.values(originsByType).find((origin) => origin.selected) ||
    Object.values(originsByType)[0];

  const [activeStateId, setActiveStateId] = useState<string | null>(
    selectedOrigin?.state_id || map_states[0]?.id || null,
  );
  const [hoveredStateId, setHoveredStateId] = useState<string | null>(null);
  const [previewOriginType, setPreviewOriginType] = useState<string | null>(
    selectedOrigin?.type || null,
  );

  useEffect(() => {
    if (!current_origin_type || hoveredStateId) {
      return;
    }

    const currentOrigin = originsByType[current_origin_type];
    if (!currentOrigin) {
      return;
    }

    setActiveStateId(currentOrigin.state_id);
    setPreviewOriginType(currentOrigin.type);
  }, [current_origin_type, hoveredStateId, originsByType]);

  const previewOrigin =
    (previewOriginType && originsByType[previewOriginType]) || selectedOrigin;
  const focusedStateId = hoveredStateId || activeStateId;
  const visibleMapStates = map_states.filter((state) => state.on_map);

  const focusOrigin = (origin: Origin) => {
    setActiveStateId(origin.state_id);
    setPreviewOriginType(origin.type);
  };

  const selectOrigin = (origin: Origin) => {
    focusOrigin(origin);
    act('select_origin', { origin_type: origin.type });
  };

  const handleOriginClick = (origin: Origin) => {
    if (origin.available) {
      selectOrigin(origin);
      return;
    }

    focusOrigin(origin);
  };

  return (
    <Window width={1480} height={920}>
      <Window.Content>
        <Stack fill>
          <Stack.Item grow basis={0}>
            <Section
              title="Карта происхождений"
              buttons={
                <div
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    gap: '0.5rem',
                  }}>
                  <div style={{ opacity: 0.9 }}>Текущая раса: {current_species_name}</div>
                </div>
              }
              fill>
              <div
                style={{
                  display: 'flex',
                  flexDirection: 'column',
                  gap: '0.75rem',
                  height: '100%',
                  minHeight: 0,
                }}>
                <div
                  style={{
                    position: 'relative',
                    width: '100%',
                    flex: 1,
                    minHeight: '640px',
                    border: '1px solid rgba(255,255,255,0.12)',
                    borderRadius: '8px',
                    overflow: 'hidden',
                    background: '#111',
                  }}>
                  <img
                    src={resolveAsset('origin_picker_map.jpg')}
                    alt="Карта происхождений"
                    style={{
                      width: '100%',
                      height: '100%',
                      objectFit: 'contain',
                      display: 'block',
                      userSelect: 'none',
                    }}
                  />
                  {visibleMapStates.map((state) => {
                    const previewableOrigin =
                      state.origins.find((origin) => origin.selected) ||
                      state.origins.find((origin) => origin.available) ||
                      state.origins[0];

                    if (!previewableOrigin) {
                      return null;
                    }

                    const isFocused = state.id === focusedStateId;
                    const isSelected = state.origins.some((origin) => origin.selected);
                    const isAvailable = state.origins.some((origin) => origin.available);

                    return (
                      <button
                        key={state.id}
                        type="button"
                        style={{
                          ...markerStyle(isFocused, isSelected, isAvailable),
                          left: `${state.x}%`,
                          top: `${state.y}%`,
                        }}
                        onMouseEnter={() => {
                          setHoveredStateId(state.id);
                          focusOrigin(previewableOrigin);
                        }}
                        onMouseLeave={() => setHoveredStateId(null)}
                        onClick={() => handleOriginClick(previewableOrigin)}
                        title={state.name}
                      />
                    );
                  })}
                </div>

                <Section title="Лор выбранного происхождения" fill scrollable>
                  {previewOrigin ? (
                    <div
                      style={{
                        display: 'flex',
                        flexDirection: 'column',
                        gap: '0.04rem',
                        minHeight: 0,
                      }}>
                      <div
                        style={{
                          display: 'flex',
                          justifyContent: 'space-between',
                          alignItems: 'flex-start',
                          gap: '0.75rem',
                          margin: 0,
                          padding: 0,
                        }}>
                        <div
                          style={{
                            fontWeight: 700,
                            fontSize: '1.1rem',
                            lineHeight: 1.02,
                            margin: 0,
                            flex: 1,
                          }}>
                          {previewOrigin.display_name}
                        </div>

                        {(previewOrigin.language_text || previewOrigin.trait_text) && (
                          <div
                            style={{
                              display: 'flex',
                              flexDirection: 'column',
                              alignItems: 'flex-end',
                              gap: '0rem',
                              color: '#d9d0ff',
                              fontSize: '0.92rem',
                              lineHeight: 1.05,
                              textAlign: 'right',
                              flexShrink: 0,
                              margin: 0,
                              padding: 0,
                            }}>
                            {previewOrigin.language_text && (
                              <div>
                                <b>Язык:</b> {previewOrigin.language_text}
                              </div>
                            )}
                            {previewOrigin.trait_text && (
                              <div>
                                <b>Трейт:</b> {previewOrigin.trait_text}
                              </div>
                            )}
                          </div>
                        )}
                      </div>

                      {!previewOrigin.available && (
                        <div
                          style={{
                            color: '#f0c674',
                            fontSize: '0.95rem',
                            lineHeight: 1.12,
                            margin: 0,
                            padding: 0,
                          }}>
                          Это происхождение недоступно для текущей расы.
                          {previewOrigin.required_races_text
                            ? ` Нужны расы: ${previewOrigin.required_races_text}.`
                            : ''}
                        </div>
                      )}

                      <div
                        style={{
                          lineHeight: 1.15,
                          whiteSpace: 'normal',
                          overflowWrap: 'anywhere',
                          margin: 0,
                          marginTop: '0.14rem',
                          padding: 0,
                        }}>
                        {renderOriginDescription(previewOrigin.origin_desc || previewOrigin.desc)}
                      </div>
                    </div>
                  ) : (
                    <div>Нет происхождений для отображения.</div>
                  )}
                </Section>
              </div>
            </Section>
          </Stack.Item>

          <Stack.Item basis="430px" grow={0}>
            <Section title="Список государств" fill scrollable>
              <div
                style={{
                  display: 'flex',
                  flexDirection: 'column',
                  gap: '0.9rem',
                }}>
                {groups.map((group) => (
                  <div key={group.name}>
                    <div
                      style={{
                        fontSize: '1rem',
                        fontWeight: 700,
                        marginBottom: '0.5rem',
                        color: group.is_off_map ? '#f0c674' : '#fff',
                      }}>
                      {group.name}
                    </div>
                    <div
                      style={{
                        display: 'flex',
                        flexDirection: 'column',
                        gap: '0.6rem',
                      }}>
                      {group.entries.map((entry) => {
                        const entryFocused = entry.items.some(
                          (item) => item.state_id === focusedStateId,
                        );
                        const entrySelected = entry.items.some((item) => item.selected);
                        const defaultItem =
                          entry.items.find((item) => item.selected) ||
                          entry.items.find((item) => item.available) ||
                          entry.items[0];
                        const subgroupMap = new Map<string, Origin[]>();
                        const plainItems: Origin[] = [];

                        for (const item of entry.items) {
                          if (item.subgroup_name) {
                            const subgroupItems = subgroupMap.get(item.subgroup_name) || [];
                            subgroupItems.push(item);
                            subgroupMap.set(item.subgroup_name, subgroupItems);
                          } else {
                            plainItems.push(item);
                          }
                        }

                        const hasNestedItems = entry.items.length > 1;
                        const useSelectableHeader =
                          plainItems.length === 1 &&
                          subgroupMap.size > 0 &&
                          plainItems[0].display_name === entry.name;

                        if (!hasNestedItems && defaultItem) {
                          return (
                            <div
                              key={entry.id}
                              onMouseEnter={() => {
                                setHoveredStateId(defaultItem.state_id);
                                focusOrigin(defaultItem);
                              }}
                              onMouseLeave={() => setHoveredStateId(null)}>
                              <Button
                                fluid
                                selected={entrySelected}
                                textAlign="left"
                                style={listButtonStyle(defaultItem.available)}
                                onClick={() => handleOriginClick(defaultItem)}>
                                {renderOriginButtonContent(defaultItem, entry.name)}
                              </Button>
                            </div>
                          );
                        }

                        return (
                          <div
                            key={entry.id}
                            onMouseEnter={() => {
                              if (!defaultItem) {
                                return;
                              }
                              setHoveredStateId(defaultItem.state_id);
                              focusOrigin(defaultItem);
                            }}
                            onMouseLeave={() => setHoveredStateId(null)}
                            style={{
                              border: `1px solid ${
                                entryFocused
                                  ? 'rgba(184, 140, 255, 0.75)'
                                  : 'rgba(255,255,255,0.08)'
                              }`,
                              borderRadius: '8px',
                              padding: '0.65rem',
                              background: entrySelected
                                ? 'rgba(127, 89, 217, 0.12)'
                                : 'rgba(255,255,255,0.02)',
                            }}>
                            {useSelectableHeader ? (
                              <div
                                onMouseEnter={() => {
                                  setHoveredStateId(plainItems[0].state_id);
                                  focusOrigin(plainItems[0]);
                                }}
                                onMouseLeave={() => setHoveredStateId(null)}>
                                <Button
                                  fluid
                                  selected={plainItems[0].selected}
                                  textAlign="left"
                                  style={listButtonStyle(plainItems[0].available)}
                                  onClick={() => handleOriginClick(plainItems[0])}>
                                  {renderOriginButtonContent(plainItems[0], entry.name)}
                                </Button>
                              </div>
                            ) : (
                              <div
                                style={{
                                  fontWeight: 700,
                                  marginBottom: '0.5rem',
                                }}>
                                {entry.name}
                              </div>
                            )}
                            <div
                              style={{
                                display: 'flex',
                                flexDirection: 'column',
                                gap: '0.35rem',
                              }}>
                              {plainItems
                                .filter((origin) => !(useSelectableHeader && origin === plainItems[0]))
                                .map((origin) => (
                                  <div
                                    key={origin.type}
                                    onMouseEnter={() => {
                                      setHoveredStateId(origin.state_id);
                                      focusOrigin(origin);
                                    }}
                                    onMouseLeave={() => setHoveredStateId(null)}>
                                    <Button
                                      fluid
                                      selected={origin.selected}
                                      textAlign="left"
                                      style={listButtonStyle(origin.available)}
                                      onClick={() => handleOriginClick(origin)}>
                                      {renderOriginButtonContent(origin)}
                                    </Button>
                                  </div>
                                ))}

                              {Array.from(subgroupMap.entries()).map(([subgroupName, subgroupItems]) => (
                                <div key={subgroupName}>
                                  <div
                                    style={{
                                      color: '#d9d0ff',
                                      fontSize: '0.9rem',
                                      fontWeight: 600,
                                      margin: '0.2rem 0 0.35rem 0',
                                    }}>
                                    {subgroupName}
                                  </div>
                                  <div
                                    style={{
                                      display: 'flex',
                                      flexDirection: 'column',
                                      gap: '0.35rem',
                                    }}>
                                    {subgroupItems.map((origin) => (
                                      <div
                                        key={origin.type}
                                        onMouseEnter={() => {
                                          setHoveredStateId(origin.state_id);
                                          focusOrigin(origin);
                                        }}
                                        onMouseLeave={() => setHoveredStateId(null)}>
                                        <Button
                                          fluid
                                          selected={origin.selected}
                                          textAlign="left"
                                          style={listButtonStyle(origin.available)}
                                          onClick={() => handleOriginClick(origin)}>
                                          {renderOriginButtonContent(origin)}
                                        </Button>
                                      </div>
                                    ))}
                                  </div>
                                </div>
                              ))}
                            </div>
                          </div>
                        );
                      })}
                    </div>
                  </div>
                ))}
              </div>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

export default OriginPicker;
