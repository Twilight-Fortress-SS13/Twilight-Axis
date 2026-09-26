import { NoticeBox, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { FamilyListSections } from './FamilyDisplayPanel/FamilyListSections';
import { FamilyTree } from './FamilyDisplayPanel/FamilyTree';
import type { FamilyDisplayData } from './FamilyDisplayPanel/types';

export const FamilyDisplayPanel = () => {
  const { data } = useBackend<FamilyDisplayData>();
  const {
    title = 'Family',
    subtitle = '',
    emptyMessage = 'Nothing to show.',
    sections = [],
    tree = [],
  } = data;
  const hasTree = !!tree.length;
  const hasSections = !!sections.length;

  return (
    <Window title={title} width={860} height={620}>
      <Window.Content scrollable style={{ backgroundImage: 'none' }}>
        <Stack vertical fill>
          {!!subtitle && (
            <Stack.Item>
              <NoticeBox info>{subtitle}</NoticeBox>
            </Stack.Item>
          )}
          {!hasTree && !hasSections && (
            <Stack.Item>
              <NoticeBox>{emptyMessage}</NoticeBox>
            </Stack.Item>
          )}
          {hasTree && (
            <Stack.Item>
              <FamilyTree tree={tree} />
            </Stack.Item>
          )}
          {hasSections && (
            <FamilyListSections
              sections={sections}
              emptyMessage={emptyMessage}
            />
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
