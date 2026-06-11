import { useMemo, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Input,
  NoticeBox,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';

type DisplayEntry = {
  path: string;
  name: string;
  icon?: string | null;
};

type Data = {
  catalog: DisplayEntry[];
  catalog_warming?: boolean;
};

const DisplayItemIcon = ({ icon, name }: { icon?: string | null; name: string }) => {
  return (
    <div
      style={{
        width: '64px',
        height: '64px',
        display: 'flex',
        lineHeight: 0,
        alignItems: 'center',
        justifyContent: 'center',
        overflow: 'hidden',
      }}>
      {icon ? (
        <img
          src={`data:image/png;base64,${icon}`}
          alt={name}
          style={{
            width: '100%',
            height: '100%',
            objectFit: 'contain',
            imageRendering: 'pixelated',
            pointerEvents: 'none',
            display: 'block',
          }}
        />
      ) : (
        <div style={{ opacity: 0.45, fontSize: '10px' }}>No icon</div>
      )}
    </div>
  );
};

const DisplayItemTile = ({ entry }: { entry: DisplayEntry }) => {
  const name = entry.name || entry.path;
  return (
    <Box style={{ margin: '2px' }}>
      <Tooltip content={name} position="bottom">
        <div
          style={{
            position: 'relative',
            width: '88px',
            height: '88px',
            borderRadius: '6px',
            background: 'rgba(255,255,255,0.03)',
            border: '1px solid rgba(255,255,255,0.08)',
            cursor: 'default',
            userSelect: 'none',
            overflow: 'hidden',
          }}>
          <div
            style={{
              position: 'absolute',
              inset: '0',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              pointerEvents: 'none',
            }}>
            <DisplayItemIcon icon={entry.icon} name={name} />
          </div>
        </div>
      </Tooltip>
    </Box>
  );
};

export const TatTraderDisplayCase = () => {
  const { data } = useBackend<Data>();
  const [search, setSearch] = useState('');
  const normalizedSearch = search.toLowerCase().trim();

  const catalog = useMemo(() => {
    return (data.catalog || [])
      .filter((entry) => {
        if (!normalizedSearch) {
          return true;
        }
        return (
          String(entry.name || '').toLowerCase().includes(normalizedSearch) ||
          String(entry.path || '').toLowerCase().includes(normalizedSearch)
        );
      })
      .sort((a, b) => String(a.name || a.path).localeCompare(String(b.name || b.path)));
  }, [data.catalog, normalizedSearch]);

  return (
    <Window title="Merchant's Display" width={520} height={640}>
      <Window.Content scrollable>
        <Section title="Displayed Goods">
          <Stack mb={1} align="center">
            <Stack.Item grow>
              <Input
                fluid
                placeholder="Search goods..."
                value={search}
                onChange={(value) => setSearch(String(value))}
              />
            </Stack.Item>
          </Stack>

          {data.catalog_warming ? (
            <NoticeBox>Goods are being arranged...</NoticeBox>
          ) : !catalog.length ? (
            <NoticeBox>No goods are displayed.</NoticeBox>
          ) : (
            <Stack wrap>
              {catalog.map((entry) => (
                <Stack.Item key={entry.path}>
                  <DisplayItemTile entry={entry} />
                </Stack.Item>
              ))}
            </Stack>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

export default TatTraderDisplayCase;
