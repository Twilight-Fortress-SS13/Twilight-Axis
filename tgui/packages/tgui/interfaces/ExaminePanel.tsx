import { useEffect, useMemo, useState } from 'react';
import { Button, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { PageButton } from '../components/PageButton';
import { Window } from '../layouts';
import { ExaminePanelData } from './ExaminePanelData';
import { FlavorTextPage } from './ExaminePanelPages';
import { ImageGalleryPage } from './ExaminePanelPages';
import { NSFWHeadshotPage } from './ExaminePanelPages';

enum Page {
  FlavorText,
  ImageGallery,
  NSFWHeadshot,
}

const isValidAssetValue = (value?: string | null) =>
  !!value && value !== '0' && value !== '00';

export const ExaminePanel = (props) => {
  const { act, data } = useBackend<ExaminePanelData>();
  const {
    is_vet,
    character_name,
    is_playing,
    has_song,
    img_gallery,
    nsfw_img_gallery,
    examine_theme,
    is_naked,
    nsfw_headshot,
  } = data;

  const [currentPage, setCurrentPage] = useState(Page.FlavorText);

  const safeSfwGallery = useMemo(
    () => (img_gallery || []).filter(isValidAssetValue),
    [img_gallery],
  );

  const safeNsfwGallery = useMemo(
    () => (nsfw_img_gallery || []).filter(isValidAssetValue),
    [nsfw_img_gallery],
  );

  const hasSfwGallery = safeSfwGallery.length > 0;
  const hasNsfwGallery = safeNsfwGallery.length > 0;
  const hasAnyGallery = Boolean(hasSfwGallery || hasNsfwGallery);
  const hasNudeshot = isValidAssetValue(nsfw_headshot);
  const showNudeshot = Boolean(is_naked) && hasNudeshot;
  const shouldShowTabs = Boolean(hasAnyGallery || showNudeshot);

  useEffect(() => {
    if (currentPage === Page.ImageGallery && !hasAnyGallery) {
      setCurrentPage(Page.FlavorText);
      return;
    }

    if (currentPage === Page.NSFWHeadshot && !showNudeshot) {
      setCurrentPage(Page.FlavorText);
    }
  }, [currentPage, hasAnyGallery, showNudeshot]);

  let pageContents;

  switch (currentPage) {
    case Page.FlavorText:
      pageContents = <FlavorTextPage />;
      break;
    case Page.ImageGallery:
      pageContents = <ImageGalleryPage />;
      break;
    case Page.NSFWHeadshot:
      pageContents = <NSFWHeadshotPage />;
      break;
    default:
      pageContents = <FlavorTextPage />;
      break;
  }

  return (
    <Window
      title={character_name}
      width={1000}
      height={700}
      theme={examine_theme || undefined}
      buttons={
        <>
          {!!is_vet && (
            <Button
              color="gold"
              icon="crown"
              tooltip="This player is age-verified!"
              tooltipPosition="bottom-start"
              onClick={() => act('vet_chat')}
            />
          )}
          <Button
            color="green"
            icon="music"
            tooltip="Music player"
            tooltipPosition="bottom-start"
            onClick={() => act('toggle')}
            disabled={!has_song}
            selected={!is_playing}
          />
        </>
      }
    >
      <Window.Content>
        <Stack vertical fill>
          {shouldShowTabs && (
            <>
              <Stack style={{ marginBottom: '4px' }}>
                <Stack.Item grow>
                  <PageButton
                    currentPage={currentPage}
                    page={Page.FlavorText}
                    setPage={setCurrentPage}
                  >
                    Flavor Text
                  </PageButton>
                </Stack.Item>

                {hasAnyGallery && (
                  <Stack.Item grow>
                    <PageButton
                      currentPage={currentPage}
                      page={Page.ImageGallery}
                      setPage={setCurrentPage}
                    >
                      Image Gallery
                    </PageButton>
                  </Stack.Item>
                )}

                {showNudeshot && (
                  <Stack.Item grow>
                    <PageButton
                      currentPage={currentPage}
                      page={Page.NSFWHeadshot}
                      setPage={setCurrentPage}
                    >
                      Nudeshot
                    </PageButton>
                  </Stack.Item>
                )}
              </Stack>

              <Stack.Divider />
            </>
          )}

          <Stack.Item grow position="relative" overflowX="hidden" overflowY="auto">
            {pageContents}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
