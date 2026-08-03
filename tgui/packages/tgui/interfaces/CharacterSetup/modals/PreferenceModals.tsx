import { type ReactNode, useEffect, useMemo, useState } from 'react';
import { Box, Button, Dropdown, Input, Section, Stack } from 'tgui-core/components';

import type {
  ContextSelector,
  CulinaryEditorData,
  CulinaryOptionCatalog,
  Data,
  DescriptorEditorData,
  FamiliarEditorData,
  RoleplayData,
  SelectionOption,
  ViceOption,
} from '../types';
import {
  CompactRow,
  ModalShell,
  cardStyle,
  translateChoiceValue,
} from '../components/shared';

export const resolveContextSelector = (
  data: Data,
  key: string,
): ContextSelector | undefined => {
  const catalog = data.context_selector_catalog?.[key];
  const state = data.context_selectors?.[key];
  if (!catalog && !state) {
    return undefined;
  }
  return {
    title: state?.title || catalog?.title,
    current: state?.current,
    options: state?.options || catalog?.options || [],
  };
};

const GenderChoiceButton = (props: {
  label: string;
  selected?: boolean;
  onClick: () => void;
}) => (
  <Button selected={props.selected} onClick={props.onClick} style={{ minWidth: '140px' }}>
    {props.label}
  </Button>
);

const filterSelectionOptions = (options: SelectionOption[], search: string) => {
  const needle = search.trim().toLowerCase();
  if (!needle) {
    return options;
  }
  return options.filter((option) => {
    const blob = `${option.name} ${option.description || ''} ${option.meta || ''}`.toLowerCase();
    return blob.includes(needle);
  });
};

export const ContextDropdownRow = (props: {
  label: string;
  selector?: ContextSelector;
  onSelected: (value: string) => void;
  disabled?: boolean;
  auxButton?: ReactNode;
  labelBasis?: string;
  showMeta?: boolean;
}) => {
  const optionItems = (props.selector?.options || []).map((option) => ({
    displayText: props.showMeta !== false && option.meta ? `${option.name} — ${option.meta}` : option.name,
    value: option.id,
  }));

  return (
    <Box mb={0.35} p={0.35} style={cardStyle}>
      <Stack align="center">
        <Stack.Item basis={props.labelBasis || '180px'} shrink={0}>
          <Box color="label">{props.label}</Box>
        </Stack.Item>
        {props.auxButton ? (
          <Stack.Item shrink={0} mr={0.35}>
            {props.auxButton}
          </Stack.Item>
        ) : null}
        <Stack.Item grow>
          <Dropdown
            width="100%"
            options={optionItems}
            selected={props.selector?.current || (optionItems[0]?.displayText ?? 'Нет вариантов')}
            disabled={props.disabled || !optionItems.length}
            onSelected={(value) => props.onSelected(String(value))}
          />
        </Stack.Item>
      </Stack>
    </Box>
  );
};

export const SearchableSelectorModal = (props: {
  title: string;
  selector?: ContextSelector;
  onSelected: (value: string) => void;
  onClose: () => void;
}) => {
  const [search, setSearch] = useState('');
  const filtered = useMemo(
    () => filterSelectionOptions(props.selector?.options || [], search),
    [props.selector?.options, search],
  );

  return (
    <ModalShell title={props.title} width="980px" onClose={props.onClose}>
      <Box mb={0.6} p={0.6} style={cardStyle}>
        <Box color="label">Текущий вариант</Box>
        <Box bold>{props.selector?.current || 'Не выбран'}</Box>
      </Box>
      <Box mb={0.6}>
        <Input fluid placeholder="Поиск..." value={search} onChange={setSearch} />
      </Box>
      <Section title="Варианты">
        <Box style={{ maxHeight: '560px', overflowY: 'auto', paddingBottom: '10px', boxSizing: 'border-box' }}>
          {filtered.length ? filtered.map((option) => (
            <Button
              key={option.id}
              fluid
              textAlign="left"
              selected={!!option.current}
              mb={0.35}
              p={0.5}
              onClick={() => props.onSelected(option.id)}
            >
              <Box bold>{option.name}</Box>
              {option.meta ? <Box color="label">{option.meta}</Box> : null}
              {option.description ? <Box color="label" style={{ whiteSpace: 'normal' }}>{option.description}</Box> : null}
            </Button>
          )) : <Box color="label">Ничего не найдено.</Box>}
        </Box>
      </Section>
    </ModalShell>
  );
};

export const VicesModal = (props: {
  catalog: ViceOption[];
  selectedIds: string[];
  limit?: number;
  act: (action: string, payload?: Record<string, unknown>) => void;
  onClose: () => void;
}) => {
  const [search, setSearch] = useState('');
  const options = useMemo(() => {
    const selectedIds = new Set(props.selectedIds);
    return props.catalog.map((option) => ({
      ...option,
      selected: selectedIds.has(option.id),
    }));
  }, [props.catalog, props.selectedIds]);
  const selected = options.filter((option) => option.selected);
  const filtered = useMemo(() => {
    const needle = search.trim().toLowerCase();
    return options.filter((option) => {
      if (option.selected) {
        return false;
      }
      if (!needle) {
        return true;
      }
      return `${option.name} ${option.description || ''}`.toLowerCase().includes(needle);
    });
  }, [options, search]);
  const canAddMore = selected.length < (props.limit || 0);

  return (
    <ModalShell title="Пороки" width="980px" onClose={props.onClose}>
      <Box mb={0.6} p={0.6} style={cardStyle}>
        <Box color="label">Выбрано</Box>
        <Box bold>{selected.length} / {props.limit || 0}</Box>
      </Box>
      <Section title="Текущие пороки" mb={0.6}>
        <Box style={{ maxHeight: '220px', overflowY: 'auto', paddingBottom: '10px', boxSizing: 'border-box' }}>
          {selected.length ? selected.map((option) => (
            <Box key={`selected-${option.id}`} mb={0.4} p={0.5} style={cardStyle}>
              <Stack align="center">
                <Stack.Item grow>
                  <Box bold>{option.name}</Box>
                  {option.description ? <Box color="label" style={{ whiteSpace: 'normal' }}>{option.description}</Box> : null}
                </Stack.Item>
                <Stack.Item>
                  <Button compact onClick={() => props.act('remove_charflaw_type', { flaw: option.id })}>Убрать</Button>
                </Stack.Item>
              </Stack>
            </Box>
          )) : <Box color="label">Пока ничего не выбрано.</Box>}
        </Box>
      </Section>
      <Box mb={0.6}>
        <Input fluid placeholder="Поиск порока..." value={search} onChange={setSearch} />
      </Box>
      <Section title="Доступные пороки">
        <Box style={{ maxHeight: '420px', overflowY: 'auto', paddingBottom: '10px', boxSizing: 'border-box' }}>
          {filtered.map((option) => (
            <Box key={option.id} mb={0.4} p={0.5} style={cardStyle}>
              <Stack align="center">
                <Stack.Item grow>
                  <Box bold>{option.name}</Box>
                  {option.description ? <Box color="label" style={{ whiteSpace: 'normal' }}>{option.description}</Box> : null}
                </Stack.Item>
                <Stack.Item>
                  {option.selected ? (
                    <Button compact onClick={() => props.act('remove_charflaw_type', { flaw: option.id })}>Убрать</Button>
                  ) : (
                    <Button compact disabled={!canAddMore} onClick={() => props.act('add_charflaw', { flaw: option.id })}>Добавить</Button>
                  )}
                </Stack.Item>
              </Stack>
            </Box>
          ))}
          {!filtered.length ? <Box color="label">Ничего не найдено.</Box> : null}
        </Box>
      </Section>
    </ModalShell>
  );
};

export const DescriptorsModal = (props: {
  data?: DescriptorEditorData;
  act: (action: string, payload?: Record<string, unknown>) => void;
  onClose: () => void;
}) => {
  const [contentDrafts, setContentDrafts] = useState<Record<number, string>>({});

  useEffect(() => {
    const drafts: Record<number, string> = {};
    (props.data?.custom_entries || []).forEach((entry) => {
      drafts[entry.index] = entry.content || '';
    });
    setContentDrafts(drafts);
  }, [props.data]);

  return (
    <ModalShell
      title="Дескрипторы"
      width="980px"
      maxHeight="98%"
      contentMaxHeight="94vh"
      onClose={props.onClose}
    >
      <Section title="Основные дескрипторы" mb={0.6}>
        <Box style={{ maxHeight: '410px', overflowY: 'auto' }}>
          {(props.data?.entries || []).map((entry) => (
            <Box key={entry.id} mb={0.5} p={0.5} style={cardStyle}>
              <Stack align="center">
                <Stack.Item basis="220px" shrink={0}>
                  <Box color="label">{entry.name}</Box>
                  <Box bold>{entry.value}</Box>
                </Stack.Item>
                <Stack.Item grow>
                  <Dropdown
                    width="100%"
                    options={entry.options.map((option) => ({ displayText: option.name, value: option.id }))}
                    selected={entry.value}
                    onSelected={(value) => props.act('set_descriptor_choice', { choice: entry.id, descriptor: value })}
                  />
                </Stack.Item>
              </Stack>
            </Box>
          ))}
          {!(props.data?.entries || []).length ? <Box color="label">Нет доступных дескрипторов.</Box> : null}
        </Box>
      </Section>
      <Section title="Кастомные дескрипторы">
        <Box style={{ maxHeight: '390px', overflowY: 'auto' }}>
          {(props.data?.custom_entries || []).filter((entry) => entry.visible).length ? (
            (props.data?.custom_entries || []).filter((entry) => entry.visible).map((entry) => (
              <Box key={`custom-${entry.index}`} mb={0.5} p={0.5} style={cardStyle}>
                <Box bold mb={0.4}>Кастом #{entry.index}</Box>
                <Stack align="center" mb={0.4}>
                  <Stack.Item basis="220px" shrink={0}>
                    <Dropdown
                      width="100%"
                      options={entry.prefix_options.map((option) => ({ displayText: option.name, value: option.id }))}
                      selected={entry.prefix_label}
                      onSelected={(value) => props.act('set_custom_descriptor_prefix', { index: entry.index, prefix: value })}
                    />
                  </Stack.Item>
                  <Stack.Item grow>
                    <input
                      value={contentDrafts[entry.index] ?? ''}
                      onChange={(event) => setContentDrafts((current) => ({ ...current, [entry.index]: event.currentTarget.value }))}
                      style={{ width: '100%', height: '34px', background: 'rgba(255,255,255,0.06)', color: 'white', border: '1px solid rgba(255,255,255,0.18)', padding: '4px 8px' }}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button compact onClick={() => props.act('set_custom_descriptor_content', { index: entry.index, value: contentDrafts[entry.index] ?? '' })}>Сохранить</Button>
                  </Stack.Item>
                </Stack>
              </Box>
            ))
          ) : (
            <Box color="label">Для текущих дескрипторов кастомные поля не используются.</Box>
          )}
        </Box>
      </Section>
    </ModalShell>
  );
};

export const CulinaryModal = (props: {
  data?: CulinaryEditorData;
  catalog?: CulinaryOptionCatalog;
  act: (action: string, payload?: Record<string, unknown>) => void;
  onClose: () => void;
}) => {
  const entries = props.data?.entries || [];
  const [activeKey, setActiveKey] = useState<'cuisine' | 'dish' | 'drink' | ''>(entries[0]?.key || '');
  const [search, setSearch] = useState('');

  useEffect(() => {
    if (!entries.length) {
      return;
    }
    if (!activeKey || !entries.find((entry) => entry.key === activeKey)) {
      setActiveKey(entries[0].key);
    }
  }, [entries, activeKey]);

  const activeEntry = entries.find((entry) => entry.key === activeKey);
  const activeOptions = activeEntry ? (props.catalog?.[activeEntry.key] || []) : [];
  const filteredOptions = useMemo(() => filterSelectionOptions(activeOptions, search), [activeOptions, search]);

  return (
    <ModalShell title="Предпочтения в еде" width="920px" onClose={props.onClose}>
      <Stack>
        <Stack.Item basis="42%">
          <Section title="Текущие предпочтения">
            <Box style={{ maxHeight: '560px', overflowY: 'auto' }}>
              {entries.map((entry) => (
                <Button
                  key={entry.key}
                  fluid
                  selected={entry.key === activeKey}
                  textAlign="left"
                  mb={0.4}
                  p={0.55}
                  onClick={() => { setActiveKey(entry.key); setSearch(''); }}
                >
                  <Box color="label">{entry.label}</Box>
                  <Box bold>{entry.value === 'None' ? 'Нет' : entry.value}</Box>
                </Button>
              ))}
              <Box mt={0.6}>
                <Button fluid onClick={() => props.act('reset_culinary_preferences')}>Сбросить</Button>
              </Box>
            </Box>
          </Section>
        </Stack.Item>
        <Stack.Item grow>
          <Section title={activeEntry ? `Выбор: ${activeEntry.label}` : 'Выбор'}>
            <Box style={{ maxHeight: '560px', overflowY: 'auto' }}>
              {activeEntry ? (
                <>
                  <Box mb={0.6}>
                    <Input fluid placeholder="Поиск..." value={search} onChange={setSearch} />
                  </Box>
                  <Box style={{ display: 'grid', gridTemplateColumns: 'repeat(2, minmax(0, 1fr))', gap: '8px' }}>
                    {filteredOptions.map((option) => (
                      <Button
                        key={`${activeEntry.key}-${option.id}`}
                        selected={option.name === activeEntry.value || (option.id === '0' && activeEntry.value === 'None')}
                        textAlign="center"
                        style={{ minHeight: '54px' }}
                        onClick={() => props.act('set_culinary_axis', { axis: activeEntry.key, value: option.id })}
                      >
                        <Box bold>{option.name}</Box>
                      </Button>
                    ))}
                  </Box>
                  {!filteredOptions.length ? <Box color="label">Ничего не найдено.</Box> : null}
                </>
              ) : <Box color="label">Выберите категорию слева.</Box>}
            </Box>
          </Section>
        </Stack.Item>
      </Stack>
    </ModalShell>
  );
};

export const FamiliarModal = (props: {
  data?: FamiliarEditorData;
  act: (action: string, payload?: Record<string, unknown>) => void;
  onClose: () => void;
}) => {
  const entries = props.data?.entries || [];
  const [activeOrigin, setActiveOrigin] = useState(entries[0]?.planar_origin || 'fae');
  const activeEntry = entries.find((entry) => entry.planar_origin === activeOrigin) || entries[0];
  const [name, setName] = useState(activeEntry?.familiar_name || '');
  const [headshot, setHeadshot] = useState(activeEntry?.familiar_headshot_link || '');
  const [flavor, setFlavor] = useState(activeEntry?.familiar_flavortext || '');
  const [ooc, setOoc] = useState(activeEntry?.familiar_ooc_notes || '');
  const [extra, setExtra] = useState(activeEntry?.familiar_ooc_extra_link || '');

  useEffect(() => {
    if (!entries.some((entry) => entry.planar_origin === activeOrigin) && entries[0]) {
      setActiveOrigin(entries[0].planar_origin);
    }
  }, [activeOrigin, entries]);

  useEffect(() => {
    setName(activeEntry?.familiar_name || '');
    setHeadshot(activeEntry?.familiar_headshot_link || '');
    setFlavor(activeEntry?.familiar_flavortext || '');
    setOoc(activeEntry?.familiar_ooc_notes || '');
    setExtra(activeEntry?.familiar_ooc_extra_link || '');
  }, [
    activeEntry?.planar_origin,
    activeEntry?.familiar_name,
    activeEntry?.familiar_headshot_link,
    activeEntry?.familiar_flavortext,
    activeEntry?.familiar_ooc_notes,
    activeEntry?.familiar_ooc_extra_link,
  ]);

  const familiarAction = (action: string, value?: unknown) => {
    if (!activeEntry) {
      return;
    }
    props.act(action, { planar_origin: activeEntry.planar_origin, value });
  };

  return (
    <ModalShell title="Настройки фамильяра" width="1020px" onClose={props.onClose}>
      <Box mb={0.6} p={0.5} style={cardStyle}>
        <Box color="label" mb={0.4}>
          Настройки хранятся отдельно для каждого плана. Выберите тип призыва, который хотите настроить.
        </Box>
        <Stack>
          {entries.map((entry) => (
            <Stack.Item key={entry.planar_origin} grow>
              <Button
                fluid
                selected={entry.planar_origin === activeEntry?.planar_origin}
                onClick={() => setActiveOrigin(entry.planar_origin)}
              >
                {entry.plane_name}
              </Button>
            </Stack.Item>
          ))}
        </Stack>
      </Box>
      {activeEntry ? (
        <Stack>
          <Stack.Item basis="40%">
            <Section title={`Основное — ${activeEntry.plane_name}`}>
              <Box style={{ maxHeight: '570px', overflowY: 'auto', paddingBottom: '10px', boxSizing: 'border-box' }}>
                {activeEntry.planar_origin === 'void' ? (
                  <Box mb={0.5} p={0.5} style={cardStyle}>
                    <Box bold>Void Drakeling</Box>
                    {activeEntry.lore_blurb ? <Box mt={0.45} color="label" style={{ whiteSpace: 'normal' }}>{activeEntry.lore_blurb}</Box> : null}
                  </Box>
                ) : (
                  <Box mb={0.5} p={0.5} style={cardStyle}>
                    <Box color="label">Тип</Box>
                    <Dropdown
                      width="100%"
                      mt={0.35}
                      options={activeEntry.species_options.map((option) => ({ displayText: option.name, value: option.id }))}
                      selected={activeEntry.familiar_specie || 'None selected'}
                      disabled={!activeEntry.species_options.length}
                      onSelected={(value) => familiarAction('set_familiar_specie', value)}
                    />
                    {activeEntry.lore_blurb ? <Box mt={0.45} color="label" style={{ whiteSpace: 'normal' }}>{activeEntry.lore_blurb}</Box> : null}
                  </Box>
                )}
                <Box mb={0.5} p={0.5} style={cardStyle}>
                  <Box color="label">Местоимения</Box>
                  <Dropdown
                    width="100%"
                    mt={0.35}
                    options={(props.data?.pronoun_options || []).map((option) => ({ displayText: option.name, value: option.id }))}
                    selected={activeEntry.familiar_pronouns || 'they/them'}
                    onSelected={(value) => familiarAction('set_familiar_pronouns', value)}
                  />
                </Box>
                <Box mb={0.5} p={0.5} style={cardStyle}>
                  <Box color="label" mb={0.35}>Имя</Box>
                  <input value={name} onChange={(event) => setName(event.currentTarget.value)} style={{ width: '100%', height: '34px', background: 'rgba(255,255,255,0.06)', color: 'white', border: '1px solid rgba(255,255,255,0.18)', padding: '4px 8px' }} />
                  <Box mt={0.4}><Button fluid onClick={() => familiarAction('set_familiar_name', name)}>Сохранить имя</Button></Box>
                </Box>
                <Box mb={0.5} p={0.5} style={cardStyle}>
                  <Box color="label" mb={0.35}>Headshot URL</Box>
                  <input value={headshot} onChange={(event) => setHeadshot(event.currentTarget.value)} style={{ width: '100%', height: '34px', background: 'rgba(255,255,255,0.06)', color: 'white', border: '1px solid rgba(255,255,255,0.18)', padding: '4px 8px' }} />
                  <Box mt={0.4}><Button fluid onClick={() => familiarAction('set_familiar_headshot', headshot)}>Сохранить портрет</Button></Box>
                </Box>
                {activeEntry.familiar_headshot_link ? (
                  <Box textAlign="center" mt={0.4}>
                    <img src={activeEntry.familiar_headshot_link} alt="Familiar headshot" style={{ maxWidth: '100%', maxHeight: '220px' }} />
                  </Box>
                ) : null}
              </Box>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section title="Описание">
              <Box style={{ maxHeight: '570px', overflowY: 'auto', paddingBottom: '10px', boxSizing: 'border-box' }}>
                <Box mb={0.5}>
                  <Box color="label" mb={0.35}>Флавортекст</Box>
                  <textarea value={flavor} onChange={(event) => setFlavor(event.currentTarget.value)} style={{ width: '100%', minHeight: '160px', background: 'rgba(255,255,255,0.06)', color: 'white', border: '1px solid rgba(255,255,255,0.18)', padding: '8px' }} />
                  <Box mt={0.35}><Button fluid onClick={() => familiarAction('set_familiar_flavortext', flavor)}>Сохранить флавор</Button></Box>
                </Box>
                <Box mb={0.5}>
                  <Box color="label" mb={0.35}>OOC заметки</Box>
                  <textarea value={ooc} onChange={(event) => setOoc(event.currentTarget.value)} style={{ width: '100%', minHeight: '130px', background: 'rgba(255,255,255,0.06)', color: 'white', border: '1px solid rgba(255,255,255,0.18)', padding: '8px' }} />
                  <Box mt={0.35}><Button fluid onClick={() => familiarAction('set_familiar_ooc_notes', ooc)}>Сохранить OOC заметки</Button></Box>
                </Box>
                <Box mb={0.5}>
                  <Box color="label" mb={0.35}>OOC Extra URL</Box>
                  <input value={extra} onChange={(event) => setExtra(event.currentTarget.value)} style={{ width: '100%', height: '34px', background: 'rgba(255,255,255,0.06)', color: 'white', border: '1px solid rgba(255,255,255,0.18)', padding: '4px 8px' }} />
                  <Box mt={0.35}><Button fluid onClick={() => familiarAction('set_familiar_ooc_extra', extra)}>Сохранить OOC Extra</Button></Box>
                </Box>
                <Box mt={0.7} p={0.6} style={cardStyle}>
                  <Box color="label" mb={0.4}>
                    Отправляет живым носителям арканы уведомление о готовом к призыву фамильяре. Перезарядка — 10 минут.
                  </Box>
                  <Button fluid onClick={() => props.act('pulse_familiar')}>Отправить импульс</Button>
                </Box>
              </Box>
            </Section>
          </Stack.Item>
        </Stack>
      ) : (
        <Box color="label">Настройки фамильяров недоступны.</Box>
      )}
    </ModalShell>
  );
};

export const GenderModal = (props: {
  data: Data;
  onApplyPreset: (preset: 'masculine' | 'feminine') => void;
  onSetBodyType: (gender: 'masculine' | 'feminine') => void;
  onSetVoiceType: (voiceType: string) => void;
  onEditPreference: (preference: string) => void;
  onClose: () => void;
}) => {
  const bodyIsFeminine = !!props.data.appearance.body_is_feminine;

  return (
    <ModalShell title="Тело и голос" width="900px" onClose={props.onClose}>
      <Section title="Пресеты" fitted>
        <Stack>
          <Stack.Item grow>
            <Button fluid onClick={() => props.onApplyPreset('masculine')}>Мужской пресет</Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button fluid onClick={() => props.onApplyPreset('feminine')}>Женский пресет</Button>
          </Stack.Item>
        </Stack>
      </Section>

      <Section title="Тело и обращение" mt={0.75} fitted>
        <Box mb={0.6}>
          <Box color="label" mb={0.35}>Тип тела</Box>
          <Stack>
            <Stack.Item>
              <GenderChoiceButton label="Маскулинное" selected={!bodyIsFeminine} onClick={() => props.onSetBodyType('masculine')} />
            </Stack.Item>
            <Stack.Item>
              <GenderChoiceButton label="Фемининное" selected={bodyIsFeminine} onClick={() => props.onSetBodyType('feminine')} />
            </Stack.Item>
          </Stack>
        </Box>

        <Box mb={0.6}>
          <Box color="label" mb={0.35}>Гендер голоса</Box>
          <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '8px' }}>
            {(props.data.voice_type_choices || []).map((voiceName) => {
              const lower = voiceName.toLowerCase();
              let label = voiceName;
              if (lower.includes('androg')) {
                label = 'Андрогинный';
              } else if (lower.includes('fem')) {
                label = 'Женский';
              } else if (lower.includes('masc') || lower.includes('male')) {
                label = 'Мужской';
              }
              return (
                <GenderChoiceButton
                  key={voiceName}
                  label={label}
                  selected={props.data.identity.voice_type === voiceName}
                  onClick={() => props.onSetVoiceType(voiceName)}
                />
              );
            })}
          </Box>
        </Box>

        <CompactRow label="Титулы" value={translateChoiceValue(props.data.identity.titles)} onClick={() => props.onEditPreference('titles')} />
        <CompactRow label="Местоимения" value={translateChoiceValue(props.data.identity.pronouns)} onClick={() => props.onEditPreference('pronouns')} />
        <CompactRow label="Тип одежды" value={translateChoiceValue(props.data.identity.clothes)} onClick={() => props.onEditPreference('clothespref')} />
      </Section>
    </ModalShell>
  );
};

export const ManorModal = (props: {
  data: RoleplayData;
  onEditPreference: (preference: string) => void;
  onClose: () => void;
}) => (
  <ModalShell title="Имение" width="560px" onClose={props.onClose}>
    <Section title="Настройки имения">
      <CompactRow
        label="Есть имение"
        value={props.data.have_manor ? 'Да' : 'Нет'}
        onClick={() => props.onEditPreference('have_manor')}
      />
      <CompactRow
        label="Название имения"
        value={props.data.manor_name || 'Unknown Manor'}
        onClick={() => props.onEditPreference('manor_name')}
      />
      <CompactRow
        label="Тип имения"
        value={props.data.manor_type || 'Manor'}
        onClick={() => props.onEditPreference('manor_type')}
      />
    </Section>
  </ModalShell>
);
