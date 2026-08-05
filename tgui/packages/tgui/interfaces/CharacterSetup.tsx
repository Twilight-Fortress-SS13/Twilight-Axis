import { useState } from 'react';
import { Box, Stack, Tabs } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { CharacterSetupJobsContent } from './CharacterSetupJobs';
import { LoadoutPanel } from './LoadoutPanel';
import { legacyInputPreferences, serverIcon, textFieldPreferenceMap } from './CharacterSetup/constants';
import { LeftPane } from './CharacterSetup/components/Sidebar';
import { FeatureModal } from './CharacterSetup/modals/CustomizerModals';
import { KeyCaptureModal } from './CharacterSetup/modals/KeyCaptureModal';
import {
  CulinaryModal,
  DescriptorsModal,
  FamiliarModal,
  GenderModal,
  ManorModal,
  SearchableSelectorModal,
  VicesModal,
  resolveContextSelector,
} from './CharacterSetup/modals/PreferenceModals';
import { AntagsTab } from './CharacterSetup/tabs/AntagsTab';
import { AppearanceTab } from './CharacterSetup/tabs/AppearanceTab';
import { GeneralTab } from './CharacterSetup/tabs/GeneralTab';
import { KeysTab } from './CharacterSetup/tabs/KeysTab';
import { MarkingsTab } from './CharacterSetup/tabs/MarkingsTab';
import { NotesTab } from './CharacterSetup/tabs/NotesTab';
import { SystemTab } from './CharacterSetup/tabs/SystemTab';
import type { Data, DialogTab, KeybindEntry, MainTab } from './CharacterSetup/types';

const mainTabStyle = {
  flex: '1 1 0',
  minWidth: '72px',
  paddingLeft: '5px',
  paddingRight: '5px',
  whiteSpace: 'nowrap',
  textAlign: 'center',
  justifyContent: 'center',
} as const;

export const CharacterSetup = () => {
  const { act, data } = useBackend<Data>();
  const [mainTab, setMainTab] = useState<MainTab>('general');
  const [dialog, setDialog] = useState<DialogTab>(null);
  const [virtueSelectorTarget, setVirtueSelectorTarget] = useState<'virtue_primary' | 'virtue_secondary' | null>(null);
  const [keyCapture, setKeyCapture] = useState<{ binding: KeybindEntry; oldKey?: string | null } | null>(null);
  const [featureTargetId, setFeatureTargetId] = useState<string | null>(null);
  const activeCustomizer = data.active_customizer && (!featureTargetId || data.active_customizer.id === featureTargetId)
    ? data.active_customizer
    : null;

  const handleEditPreference = (preference: string) => {
    if (legacyInputPreferences.has(preference)) {
      act('link', { task: 'input', preference });
      return;
    }
    act('edit_preference', { preference });
  };
  const handleEditTextField = (field: string) => act('link', { preference: textFieldPreferenceMap[field] || field, task: 'input' });
  return (
    <Window
      title="Настройка персонажа"
      width={1103}
      height={709}
      buttons={(
        <Box
          style={{
            display: 'inline-flex',
            alignItems: 'center',
            gap: '6px',
            height: '100%',
            color: 'var(--titlebar-text)',
            fontWeight: 700,
            lineHeight: 1,
            letterSpacing: '0.04em',
          }}
        >
          <span>Twilight Axis</span>
          <img
            src={serverIcon}
            alt=""
            draggable={false}
            style={{
              width: '24px',
              height: '24px',
              objectFit: 'contain',
              imageRendering: 'pixelated',
            }}
          />
        </Box>
      )}
    >
      <Window.Content onMouseDown={(event) => event.stopPropagation()}>
        <Box style={{ position: 'relative', height: '100%' }}>
          <Stack fill>
            <Stack.Item basis="280px" shrink={0}>
              <Box
                style={{
                  position: 'relative',
                  height: '100%',
                }}
              >
                {mainTab !== 'classes' ? (
                  <LeftPane
                    data={data}
                    act={act}
                    onOpenPlayerQuality={() => act('link', { preference: 'playerquality' })}
                    onOpenTriumphs={() => act('link', { preference: 'triumphs' })}
                    onEditPreference={handleEditPreference}
                    onOpenGenderMenu={() => setDialog('gender')}
                  />
                ) : null}
                {mainTab === 'classes' ? (
                  <Box
                    style={{
                      position: 'absolute',
                      top: 0,
                      left: 0,
                      right: 0,
                      height: '34px',
                      borderBottom: '2px solid var(--color-border, rgba(255,255,255,0.18))',
                    }}
                  />
                ) : null}
              </Box>
            </Stack.Item>
            <Stack.Item grow basis={0} style={{ minWidth: 0, overflow: 'hidden' }}>
              <Box
                style={{
                  position: 'relative',
                  width: '100%',
                  maxWidth: '100%',
                  height: '100%',
                  minWidth: 0,
                  overflow: 'hidden',
                }}
              >
          {dialog === 'feature' ? (
            <FeatureModal
              data={data}
              active={activeCustomizer}
              act={act}
              onClose={() => { setFeatureTargetId(null); setDialog(null); }}
            />
          ) : null}
          {dialog === 'gender' ? (
            <GenderModal
              data={data}
              onApplyPreset={(preset) => act('apply_gender_preset', { preset })}
              onSetBodyType={(gender) => act('set_gender_body_type', { gender })}
              onSetVoiceType={(voiceType) => act('set_voice_identity', { voice_type: voiceType })}
              onEditPreference={handleEditPreference}
              onClose={() => setDialog(null)}
            />
          ) : null}
          {dialog === 'vices' ? (
            <VicesModal
              catalog={data.vice_catalog || []}
              selectedIds={data.selected_vices || []}
              limit={data.preference_limits?.vice_limit}
              act={act}
              onClose={() => setDialog(null)}
            />
          ) : null}
          {dialog === 'descriptors' ? (
            <DescriptorsModal
              data={data.descriptor_editor}
              act={act}
              onClose={() => setDialog(null)}
            />
          ) : null}
          {dialog === 'culinary' ? (
            <CulinaryModal
              data={data.culinary_editor}
              catalog={data.culinary_option_catalog}
              act={act}
              onClose={() => setDialog(null)}
            />
          ) : null}
          {dialog === 'familiar' ? (
            <FamiliarModal
              data={data.familiar_editor}
              act={act}
              onClose={() => setDialog(null)}
            />
          ) : null}
          {dialog === 'manor' ? (
            <ManorModal
              data={data.roleplay}
              onEditPreference={handleEditPreference}
              onClose={() => setDialog(null)}
            />
          ) : null}
          {virtueSelectorTarget ? (
            <SearchableSelectorModal
              title={resolveContextSelector(data, virtueSelectorTarget)?.title || 'Особенность'}
              selector={resolveContextSelector(data, virtueSelectorTarget)}
              onSelected={(value) => {
                act('set_context_preference', { kind: virtueSelectorTarget, value });
                setVirtueSelectorTarget(null);
              }}
              onClose={() => setVirtueSelectorTarget(null)}
            />
          ) : null}
          {keyCapture ? (
            <KeyCaptureModal
              bindingLabel={keyCapture.binding.label}
              oldKey={keyCapture.oldKey}
              onClose={() => setKeyCapture(null)}
              onClear={() => {
                act('set_keybinding', {
                  keybinding: keyCapture.binding.id,
                  old_key: keyCapture.oldKey || undefined,
                  clear_key: 1,
                });
                setKeyCapture(null);
              }}
              onSet={(payload) => {
                act('set_keybinding', {
                  keybinding: keyCapture.binding.id,
                  old_key: keyCapture.oldKey || undefined,
                  clear_key: 0,
                  key: payload.key,
                  alt: payload.alt ? 1 : 0,
                  ctrl: payload.ctrl ? 1 : 0,
                  shift: payload.shift ? 1 : 0,
                  numpad: payload.numpad ? 1 : 0,
                });
                setKeyCapture(null);
              }}
            />
          ) : null}

                <Stack vertical fill>
                <Stack.Item>
                  <Box
                    onWheel={(event) => {
                      const target = event.currentTarget;
                      if (target.scrollWidth <= target.clientWidth) {
                        return;
                      }
                      target.scrollLeft += event.deltaY || event.deltaX;
                      event.preventDefault();
                    }}
                    style={{
                      overflowX: 'auto',
                      overflowY: 'hidden',
                      minWidth: 0,
                      width: '100%',
                      height: '34px',
                      overscrollBehaviorX: 'contain',
                    }}
                  >
                    <Tabs
                      style={{
                        display: 'flex',
                        flexWrap: 'nowrap',
                        width: '100%',
                        minWidth: '720px',
                        maxWidth: '100%',
                      }}
                    >
                      <Tabs.Tab style={mainTabStyle} selected={mainTab === 'general'} onClick={() => setMainTab('general')}>Общее</Tabs.Tab>
                      <Tabs.Tab style={mainTabStyle} selected={mainTab === 'appearance'} onClick={() => setMainTab('appearance')}>Внешность</Tabs.Tab>
                      <Tabs.Tab style={mainTabStyle} selected={mainTab === 'markings'} onClick={() => setMainTab('markings')}>Маркинги</Tabs.Tab>
                      <Tabs.Tab style={mainTabStyle} selected={mainTab === 'notes'} onClick={() => setMainTab('notes')}>Заметки</Tabs.Tab>
                      <Tabs.Tab
                        style={mainTabStyle}
                        selected={mainTab === 'classes'}
                        onClick={() => {
                          act('refresh_jobs');
                          setMainTab('classes');
                        }}
                      >
                        Роли
                      </Tabs.Tab>
                      <Tabs.Tab style={mainTabStyle} selected={mainTab === 'loadout'} onClick={() => setMainTab('loadout')}>Лодаут</Tabs.Tab>
                      <Tabs.Tab style={mainTabStyle} selected={mainTab === 'antags'} onClick={() => setMainTab('antags')}>Антагонисты</Tabs.Tab>
                      <Tabs.Tab style={mainTabStyle} selected={mainTab === 'system'} onClick={() => setMainTab('system')}>Система</Tabs.Tab>
                      <Tabs.Tab style={mainTabStyle} selected={mainTab === 'keys'} onClick={() => setMainTab('keys')}>Клавиши</Tabs.Tab>
                    </Tabs>
                  </Box>
                </Stack.Item>
                <Stack.Item grow style={{ minWidth: 0, minHeight: 0, overflow: 'hidden' }}>
                  {mainTab === 'general' ? (
                    <GeneralTab
                      data={data}
                      onEditPreference={handleEditPreference}
                      onManageVices={() => setDialog('vices')}
                      onOpenDescriptors={() => setDialog('descriptors')}
                      onOpenCulinary={() => setDialog('culinary')}
                      onOpenFamiliar={() => setDialog('familiar')}
                      onOpenManor={() => setDialog('manor')}
                      onOpenVirtueSelector={(kind) => setVirtueSelectorTarget(kind)}
                      act={act}
                    />
                  ) : mainTab === 'appearance' ? (
                    <AppearanceTab
                      data={data}
                      onEditPreference={handleEditPreference}
                      act={act}
                    />
                  ) : mainTab === 'markings' ? (
                    <MarkingsTab
                      data={data}
                      act={act}
                    />
                  ) : mainTab === 'notes' ? (
                    <NotesTab
                      data={data}
                      onEditPreference={handleEditPreference}
                      onEditTextField={handleEditTextField}
                      act={act}
                    />
                  ) : mainTab === 'classes' ? null : mainTab === 'loadout' ? (
                    <LoadoutPanel />
                  ) : mainTab === 'antags' ? (
                    <AntagsTab
                      data={data}
                      act={act}
                      onEditPreference={handleEditPreference}
                      onEditTextField={handleEditTextField}
                    />
                  ) : mainTab === 'system' ? (
                    <SystemTab
                      data={data}
                      act={act}
                    />
                  ) : (
                    <KeysTab
                      data={data}
                      onCapture={(binding, oldKey) => setKeyCapture({ binding, oldKey })}
                      onResetDefaults={() => act('reset_keybindings')}
                    />
                  )}
                </Stack.Item>
                </Stack>
              </Box>
            </Stack.Item>
          </Stack>
          {mainTab === 'classes' ? (
            <Box
              style={{
                position: 'absolute',
                top: '34px',
                left: 0,
                right: 0,
                bottom: 0,
                minWidth: 0,
                overflow: 'hidden',
                zIndex: 1,
              }}
            >
              <CharacterSetupJobsContent />
            </Box>
          ) : null}
        </Box>
      </Window.Content>
    </Window>
  );
};
