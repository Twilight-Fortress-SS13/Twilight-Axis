import { useState } from 'react';
import { Box, Button, Section, Stack } from 'tgui-core/components';

import type { Data } from '../types';
import { CompactRow, cardStyle, truncate } from '../components/shared';

const notesFormattingExamples = [
  { code: '\\', text: 'экранирует специальные символы' },
  { code: '# text', text: 'заголовок' },
  { code: '|text|', text: 'центрирование текста' },
  { code: '**text**', text: 'жирный текст' },
  { code: '*text*', text: 'курсив' },
  { code: '^text^', text: 'крупный текст' },
  { code: '((text))', text: 'уменьшенный текст' },
  { code: '* item', text: 'элемент списка' },
  { code: '---', text: 'горизонтальная линия' },
  { code: '-=FFFFFFtext=-', text: 'цветной текст' },
];

const renderImagePreviewGrid = (
  images?: string[],
  emptyText = 'Нет изображений.',
  onRemove?: (index: number) => void,
) => (
  <Box mt={0.5}>
    {images?.length ? (
      <Box style={{ display: 'grid', gridTemplateColumns: 'repeat(3, minmax(0, 1fr))', gap: '6px' }}>
        {images.map((image, index) => (
          <Box key={`${image}-${index}`} p={0.25} style={{ ...cardStyle, position: 'relative' }}>
            <a href={image} target="_blank" rel="noreferrer">
              <img src={image} alt={`Preview ${index + 1}`} style={{ width: '100%', height: '120px', objectFit: 'cover', display: 'block' }} />
            </a>
            {onRemove ? (
              <Button
                color="bad"
                icon="trash"
                tooltip="Удалить изображение"
                onClick={() => onRemove(index)}
                style={{ position: 'absolute', top: '4px', right: '4px' }}
              />
            ) : null}
          </Box>
        ))}
      </Box>
    ) : (
      <Box color="label">{emptyText}</Box>
    )}
  </Box>
);

export const NotesTab = (props: {
  data: Data;
  onEditPreference: (preference: string) => void;
  onEditTextField: (field: string) => void;
  act: (action: string, payload?: Record<string, unknown>) => void;
}) => {
  const [showHelp, setShowHelp] = useState(false);

  return (
    <Stack fill>
      <Stack.Item basis="56%">
        <Section title="Описание" fill scrollable>
          <Stack mb={0.55}>
            <Stack.Item>
              <Button icon={showHelp ? 'chevron-up' : 'chevron-down'} onClick={() => setShowHelp(!showHelp)}>
                Подсказки по форматированию
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button icon="eye" onClick={() => props.act('link', { preference: 'ooc_preview', task: 'input' })}>
                Flavortext Preview
              </Button>
            </Stack.Item>
          </Stack>
          {showHelp ? (
            <Box mb={0.7} p={0.7} style={cardStyle}>
              <Box color="label" mb={0.35}>Можно использовать следующие маркеры:</Box>
              {notesFormattingExamples.map((example) => (
                <Box key={example.code} style={{ lineHeight: 1.25 }}>
                  <Box as="span" mr={0.4} style={{ fontFamily: 'monospace' }}>{example.code}</Box>
                  <Box as="span" color="label">— {example.text}</Box>
                </Box>
              ))}
            </Box>
          ) : null}

          <CompactRow wrap label="Flavortext" value={truncate(props.data.roleplay.flavortext, 1500)} onClick={() => props.onEditTextField('flavortext')} />
          <CompactRow wrap label="OOC Notes" value={truncate(props.data.roleplay.ooc_notes, 1500)} onClick={() => props.onEditTextField('ooc_notes')} />
          <CompactRow wrap label="Rumours" value={truncate(props.data.roleplay.rumour, 1500)} onClick={() => props.onEditTextField('rumour')} />
          <CompactRow wrap label="Дворянские сплетни" value={truncate(props.data.roleplay.noble_gossip, 1500)} onClick={() => props.onEditTextField('noble_gossip')} />
          <CompactRow wrap label="ERP Preferences" value={truncate(props.data.roleplay.erpprefs, 1500)} onClick={() => props.onEditTextField('erpprefs')} />
          <CompactRow wrap label="NSFW Flavortext" value={truncate(props.data.roleplay.nsfwflavortext, 1500)} onClick={() => props.onEditTextField('nsfwflavortext')} />
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section title="Галереи и музыка" fill scrollable>
          <CompactRow label="Headshot" value={props.data.roleplay.headshot_link || 'Не задан'} labelBasis="90px" onClick={() => props.onEditTextField('headshot_link')} />
          {props.data.roleplay.headshot_link ? (
            <Box mt={0.45} mb={0.55} p={0.35} style={cardStyle}>
              <a href={props.data.roleplay.headshot_link} target="_blank" rel="noreferrer">
                <img src={props.data.roleplay.headshot_link} alt="Headshot" style={{ width: '100%', maxHeight: '320px', objectFit: 'contain', display: 'block' }} />
              </a>
            </Box>
          ) : null}
          <CompactRow label="SFW Gallery" value={`${props.data.roleplay.sfw_gallery_count || 0}/3`} onClick={() => props.act('manage_gallery', { nsfw: 0 })} />
          {renderImagePreviewGrid(
            props.data.roleplay.sfw_gallery,
            'SFW Gallery is empty.',
            (index) => props.act('remove_gallery_image', { nsfw: 0, index: index + 1 }),
          )}
          <CompactRow label="NSFW Gallery" value={`${props.data.roleplay.nsfw_gallery_count || 0}/3`} onClick={() => props.act('manage_gallery', { nsfw: 1 })} />
          {renderImagePreviewGrid(
            props.data.roleplay.nsfw_gallery,
            'NSFW Gallery is empty.',
            (index) => props.act('remove_gallery_image', { nsfw: 1, index: index + 1 }),
          )}
          <CompactRow wrap label="Flavor Music" value={truncate(props.data.roleplay.music_url || 'Не задано', 72)} onClick={() => props.onEditPreference('ooc_extra')} />
          <CompactRow label="Artist" value={props.data.roleplay.song_artist || 'Не задан'} onClick={() => props.onEditPreference('change_artist')} />
          <CompactRow label="Track Title" value={props.data.roleplay.song_title || 'Не задано'} onClick={() => props.onEditPreference('change_title')} />
        </Section>
      </Stack.Item>
    </Stack>
  );
};
