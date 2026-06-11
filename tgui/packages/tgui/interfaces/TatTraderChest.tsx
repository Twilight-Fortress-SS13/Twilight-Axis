import { useMemo, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Input,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

type CatalogEntry = {
  path: string;
  name: string;
  base_price: number;
  price: number;
  price_change: number;
  type?: string;
  icon?: string | null;
};

type Data = {
  bank_value: number;
  catalog: CatalogEntry[];
  catalog_warming?: boolean;
  can_use: boolean;
  default_withdraw: number;
  next_market_reroll?: number;
};

const TraderItemIcon = ({ icon, name }: { icon?: string | null; name: string }) => {
  return (
    <div
      style={{
        width: '42px',
        height: '42px',
        display: 'flex',
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
        <Box opacity={0.45} fontSize="10px">
          ?
        </Box>
      )}
    </div>
  );
};

const formatPriceChange = (value: number) => {
  if (value > 0) {
    return `+${value}%`;
  }
  return `${value}%`;
};

export const TatTraderChest = () => {
  const { act, data } = useBackend<Data>();
  const [search, setSearch] = useState('');
  const [withdrawAmount, setWithdrawAmount] = useState(String(data.default_withdraw || 10));

  const normalizedSearch = search.toLowerCase().trim();

  const catalog = useMemo(() => {
    return (data.catalog || [])
      .filter((entry) => {
        if (!normalizedSearch) {
          return true;
        }
        return (
          String(entry.name || '').toLowerCase().includes(normalizedSearch) ||
          String(entry.type || '').toLowerCase().includes(normalizedSearch) ||
          String(entry.path || '').toLowerCase().includes(normalizedSearch)
        );
      })
      .sort((a, b) => {
        const priceDiff = Number(a.price || 0) - Number(b.price || 0);
        if (priceDiff !== 0) {
          return priceDiff;
        }
        return String(a.name || a.path).localeCompare(String(b.name || b.path));
      });
  }, [data.catalog, normalizedSearch]);

  return (
    <Window title="Merchant's Chest" width={820} height={800}>
      <Window.Content scrollable>
        <Stack vertical>
          {!data.can_use && (
            <NoticeBox color="bad">
              You need a Merchant's Writ to use this chest.
            </NoticeBox>
          )}

          <Section title="Bank">
            <Stack align="center" justify="space-between">
              <Stack.Item>
                <Box bold fontSize="18px">
                  Banked value: {Number(data.bank_value) || 0}
                </Box>
                <Box mt={0.5} opacity={0.75}>
                  Deposit coins, goods, or a stranger's writ by using them on the chest.
                </Box>
                <Box mt={0.5} opacity={0.75}>
                  Market rerolls in: {Math.max(0, Number(data.next_market_reroll) || 0)} sec.
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Stack align="center">
                  <Stack.Item>
                    <Input
                      width="90px"
                      value={withdrawAmount}
                      onChange={(value) => setWithdrawAmount(String(value))}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      disabled={!data.can_use || (Number(data.bank_value) || 0) <= 0}
                      onClick={() => act('withdraw', { amount: Number(withdrawAmount) || 1 })}>
                      Withdraw
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Section>

          <Section title="Goods">
            <Stack mb={1} align="center">
              <Stack.Item grow>
                <Input
                  fluid
                  placeholder="Search goods..."
                  value={search}
                  onChange={(value) => setSearch(String(value))}
                />
              </Stack.Item>
              <Stack.Item>
                <Button disabled={!search} onClick={() => setSearch('')}>
                  Clear
                </Button>
              </Stack.Item>
            </Stack>

            {data.catalog_warming ? (
              <NoticeBox>Market catalogue is being prepared...</NoticeBox>
            ) : !catalog.length ? (
              <NoticeBox>No goods found. Items with base value 1 or lower are hidden.</NoticeBox>
            ) : (
              <Table>
                <Table.Row header>
                  <Table.Cell collapsing>Icon</Table.Cell>
                  <Table.Cell>Name</Table.Cell>
                  <Table.Cell collapsing>Type</Table.Cell>
                  <Table.Cell collapsing textAlign="right">Base</Table.Cell>
                  <Table.Cell collapsing textAlign="right">Market</Table.Cell>
                  <Table.Cell collapsing textAlign="right">Change</Table.Cell>
                  <Table.Cell collapsing>Action</Table.Cell>
                </Table.Row>
                {catalog.map((entry) => {
                  const price = Number(entry.price) || 0;
                  const basePrice = Number(entry.base_price) || 0;
                  const priceChange = Number(entry.price_change) || 0;
                  const canBuy = data.can_use && (Number(data.bank_value) || 0) >= price;
                  const changeColor = priceChange > 0 ? '#e8a0a0' : priceChange < 0 ? '#9fd6a8' : '#d9d9d9';
                  return (
                    <Table.Row key={entry.path}>
                      <Table.Cell collapsing>
                        <TraderItemIcon icon={entry.icon} name={entry.name || entry.path} />
                      </Table.Cell>
                      <Table.Cell>
                        <Box bold>{entry.name || entry.path}</Box>
                      </Table.Cell>
                      <Table.Cell collapsing>{entry.type || 'misc'}</Table.Cell>
                      <Table.Cell collapsing textAlign="right">{basePrice}</Table.Cell>
                      <Table.Cell collapsing textAlign="right">
                        <Box bold>{price}</Box>
                      </Table.Cell>
                      <Table.Cell collapsing textAlign="right">
                        <Box style={{ color: changeColor }} bold>
                          {formatPriceChange(priceChange)}
                        </Box>
                      </Table.Cell>
                      <Table.Cell collapsing>
                        <Button
                          disabled={!canBuy}
                          onClick={() => act('buy', { path: entry.path })}>
                          Buy
                        </Button>
                      </Table.Cell>
                    </Table.Row>
                  );
                })}
              </Table>
            )}
          </Section>
        </Stack>
      </Window.Content>
    </Window>
  );
};

export default TatTraderChest;
