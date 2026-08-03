import { useEffect, useMemo, useRef, useState } from 'react';
import { Box, Button, ByondUi, Input, Section, Stack } from 'tgui-core/components';

import type { CharacterPreviewData, Data } from '../types';
import { CompactRow } from './shared';

const LeftQuickEdit = (props: {
  data: Data;
  onEditPreference: (preference: string) => void;
  onOpenGenderMenu: () => void;
}) => (
  <Box mt={0.6}>
    <CompactRow label="Имя" labelBasis="92px" value={props.data.identity.real_name} onClick={() => props.onEditPreference('name')} />
    <CompactRow label="Раса" labelBasis="92px" value={`${props.data.appearance.species} / ${props.data.appearance.subspecies}`} onClick={() => props.onEditPreference('species')} />
    <CompactRow label="Пол" labelBasis="92px" value={props.data.appearance.gender_label} onClick={props.onOpenGenderMenu} />
  </Box>
);

const getPreviewZoom = (gridSize: number) => Math.max(
  0.25,
  (320 * (window.devicePixelRatio || 1)) / (gridSize * 32),
);

const CharacterPreview = (props: {
  preview?: CharacterPreviewData;
  hidden?: boolean;
  act: (action: string, payload?: Record<string, unknown>) => void;
}) => {
  const gridSize = props.preview?.grid_size || 3;
  const previewMapId = props.preview?.map_id;
  const actRef = useRef(props.act);
  actRef.current = props.act;
  const previewParams = useMemo(() => ({
    id: previewMapId || '',
    type: 'map' as const,
    'background-color': '#000000',
  }), [previewMapId]);

  useEffect(() => {
    if (!previewMapId) {
      return;
    }

    Byond.winset(previewMapId, {
      'is-visible': !props.hidden,
    });
  }, [previewMapId, props.hidden]);

  useEffect(() => {
    if (!previewMapId) {
      return;
    }

    Byond.winset(previewMapId, {
      zoom: getPreviewZoom(gridSize),
      'zoom-mode': 'distort',
      letterbox: false,
      'saved-params': '',
    });
  }, [previewMapId, gridSize]);

  useEffect(() => {
    if (!previewMapId) {
      return;
    }

    const syncTimer = setTimeout(() => {
      actRef.current('sync_preview_control');
    }, 650);

    return () => clearTimeout(syncTimer);
  }, [previewMapId]);

  return (
    <Box>
      <Box
        color="label"
        style={{
          width: '320px',
          height: '320px',
          margin: '0 auto',
          position: 'relative',
          overflow: 'hidden',
          background: 'rgba(0, 0, 0, 0.12)',
          border: '2px solid currentColor',
          boxShadow: '0 0 0 1px rgba(0, 0, 0, 0.65)',
          boxSizing: 'border-box',
        }}
      >
        {previewMapId ? (
          <div
            style={{
              position: 'absolute',
              inset: 0,
              width: '100%',
              height: '100%',
            }}
          >
            <ByondUi
              key={previewMapId}
              params={previewParams}
              style={{
                width: '100%',
                height: '100%',
              }}
            />
          </div>
        ) : props.hidden ? null : (
          <Box
            color="label"
            style={{
              position: 'absolute',
              inset: 0,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
            }}
          >
            Загрузка персонажа…
          </Box>
        )}
      </Box>
      <Stack mt={0.5} justify="center">
        <Stack.Item>
          <Button
            icon="undo"
            tooltip="Повернуть против часовой стрелки"
            tooltipPosition="bottom"
            onClick={() => props.act('rotate_preview', { direction: 'left' })}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="redo"
            tooltip="Повернуть по часовой стрелке"
            tooltipPosition="bottom"
            onClick={() => props.act('rotate_preview', { direction: 'right' })}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="border-all"
            tooltip={`Сетка ${gridSize}×${gridSize}`}
            tooltipPosition="bottom"
            onClick={() => props.act('cycle_preview_grid')}
          />
        </Stack.Item>
      </Stack>
    </Box>
  );
};

export const LeftPane = (props: {
  data: Data;
  act: (action: string, payload?: Record<string, unknown>) => void;
  onOpenPlayerQuality: () => void;
  onOpenTriumphs: () => void;
  onEditPreference: (preference: string) => void;
  onOpenGenderMenu: () => void;
  previewHidden?: boolean;
}) => {
  const [slotMenuOpen, setSlotMenuOpen] = useState(false);
  const [slotSearch, setSlotSearch] = useState('');
  const slotMenuRef = useRef<HTMLDivElement>(null);
  const slots = props.data.slot_summaries || [];
  const currentSlot = slots.find((slot) => slot.current);
  const selectedCharacterName = currentSlot?.name || props.data.identity.real_name || `Слот ${props.data.loaded_slot}`;
  const filteredSlots = useMemo(
    () => slots.filter((slot) => `${slot.index} ${slot.name} ${slot.occupied_class || ''}`.toLowerCase().includes(slotSearch.toLowerCase())),
    [slots, slotSearch],
  );

  useEffect(() => {
    if (!slotMenuOpen) {
      return;
    }

    const closeSlotMenu = (event: MouseEvent) => {
      if (!slotMenuRef.current?.contains(event.target as Node)) {
        setSlotMenuOpen(false);
      }
    };

    document.addEventListener('mousedown', closeSlotMenu, true);
    return () => document.removeEventListener('mousedown', closeSlotMenu, true);
  }, [slotMenuOpen]);

  return (
    <Stack vertical fill>
      <Stack.Item>
        <div ref={slotMenuRef} style={{ position: 'relative' }}>
          <Section
            title={(
              <Box
                style={{
                  display: 'inline-flex',
                  alignItems: 'center',
                  gap: '8px',
                  maxWidth: '100%',
                  cursor: 'pointer',
                }}
                onClick={() => setSlotMenuOpen((open) => !open)}
              >
                <Box
                  as="span"
                  color="label"
                  style={{
                    maxWidth: '310px',
                    overflow: 'hidden',
                    textOverflow: 'ellipsis',
                    whiteSpace: 'nowrap',
                    fontWeight: 400,
                  }}
                >
                  {selectedCharacterName}
                </Box>
                <Box
                  as="span"
                  color="label"
                  style={{
                    fontSize: '0.75em',
                    transform: slotMenuOpen ? 'rotate(180deg)' : undefined,
                    transition: 'transform 0.12s ease',
                  }}
                >
                  ▼
                </Box>
              </Box>
            )}
            fitted
          >
            <Box
              p={0.5}
              style={{
                overflow: 'hidden',
              }}
            >
              <CharacterPreview preview={props.data.character_preview} hidden={props.previewHidden || slotMenuOpen} act={props.act} />
            </Box>
            <LeftQuickEdit data={props.data} onEditPreference={props.onEditPreference} onOpenGenderMenu={props.onOpenGenderMenu} />
          </Section>
          {slotMenuOpen ? (
            <Box
              p={0.75}
              style={{
                position: 'absolute',
                top: '31px',
                left: '8px',
                right: '8px',
                zIndex: 40,
                border: '1px solid var(--color-border, rgba(255,255,255,0.2))',
                background: 'var(--color-base, rgba(20,20,20,0.98))',
                boxShadow: '0 12px 30px rgba(0,0,0,0.55)',
              }}
            >
              <Stack align="center" mb={0.6}>
                <Stack.Item grow>
                  <Box bold>{selectedCharacterName}</Box>
                  <Box color="label">
                    Слот {props.data.loaded_slot} из {props.data.max_save_slots}
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Button icon="times" compact onClick={() => setSlotMenuOpen(false)} />
                </Stack.Item>
              </Stack>
              <Input
                fluid
                mb={0.6}
                placeholder="Найти персонажа или слот..."
                value={slotSearch}
                onChange={setSlotSearch}
              />
              <Box style={{ maxHeight: '350px', overflowY: 'auto' }}>
                {filteredSlots.map((slot) => (
                  <Box key={slot.index} mb={0.35}>
                    <Button
                      fluid
                      selected={slot.current}
                      disabled={slot.current}
                      onClick={() => {
                        props.act('load_slot', { slot: slot.index });
                        setSlotMenuOpen(false);
                        setSlotSearch('');
                      }}
                    >
                      <Stack align="center">
                        <Stack.Item basis="42px" shrink={0}>
                          <Box bold>#{slot.index}</Box>
                        </Stack.Item>
                        <Stack.Item grow>
                          <Box bold={slot.current}>{slot.empty ? 'Пустой слот' : slot.name}</Box>
                          <Box color="label">
                            {slot.current ? 'Выбранный персонаж' : (slot.occupied_class || (slot.empty ? 'Создать персонажа' : 'Без выбранного класса'))}
                          </Box>
                        </Stack.Item>
                      </Stack>
                    </Button>
                  </Box>
                ))}
                {!filteredSlots.length ? (
                  <Box py={1.5} textAlign="center" color="label">
                    Ничего не найдено
                  </Box>
                ) : null}
              </Box>
            </Box>
          ) : null}
        </div>
      </Stack.Item>
      <Stack.Item grow>
        <Section title="Сводка" fill scrollable>
          <Stack vertical>
            <Stack.Item>
              <Button fluid onClick={props.onOpenPlayerQuality}>
                PQ:{' '}
                <Box as="span" style={{ color: props.data.player_quality_color || undefined }}>
                  {props.data.player_quality}
                </Box>
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button fluid onClick={props.onOpenTriumphs}>
                Триумфы: {(props.data.triumphs === '' || props.data.triumphs === null || props.data.triumphs === undefined || props.data.triumphs === '—') ? 0 : props.data.triumphs}
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item>
            <Button icon="undo" onClick={() => props.act('undo_setup')}>Откатить</Button>
          </Stack.Item>
          <Stack.Item>
            <Button icon="save" onClick={() => props.act('save_setup')}>Сохранить</Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
