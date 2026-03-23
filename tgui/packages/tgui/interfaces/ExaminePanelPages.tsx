import { useMemo, useState } from 'react';
import { Box, Button, Image, Section, Stack } from 'tgui-core/components';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { ExaminePanelData } from './ExaminePanelData';

const isValidAssetValue = (value?: string | null) =>
  !!value && value !== '0' && value !== '00';

const sanitizeMarkupValue = (value?: string | null) => {
  if (!value || value === '0' || value === '00') {
    return '';
  }
  return value;
};

export const FlavorTextPage = (props) => {
  const { data } = useBackend<ExaminePanelData>();
  const {
    flavor_text,
    flavor_text_nsfw,
    ooc_notes,
    ooc_notes_nsfw,
    headshot,
    is_naked,
    ooc_extra_image,
    nsfw_ooc_extra_image,
  } = data;

  const [oocNotesIndex, setOocNotesIndex] = useState('SFW');
  const [flavorTextIndex, setFlavorTextIndex] = useState('SFW');

  const safeHeadshot = isValidAssetValue(headshot) ? headshot : null;
  const safeFlavorText = sanitizeMarkupValue(flavor_text);
  const safeFlavorTextNsfw = sanitizeMarkupValue(flavor_text_nsfw);
  const safeOocNotes = sanitizeMarkupValue(ooc_notes);
  const safeOocNotesNsfw = sanitizeMarkupValue(ooc_notes_nsfw);
  const safeOocExtraImage = sanitizeMarkupValue(ooc_extra_image);
  const safeNsfwOocExtraImage = sanitizeMarkupValue(nsfw_ooc_extra_image);
  const canShowNsfwFlavor = Boolean(safeFlavorTextNsfw) && Boolean(is_naked);

  const flavorHTML = useMemo(
    () => ({
      __html: `<span class='Chat'>${safeFlavorText}</span>`,
    }),
    [safeFlavorText],
  );

  const nsfwHTML = useMemo(
    () => ({
      __html: `<span class='Chat'>${safeFlavorTextNsfw}</span>`,
    }),
    [safeFlavorTextNsfw],
  );

  const oocHTML = useMemo(
    () => ({
      __html: `<span class='Chat'>${safeOocNotes}</span>`,
    }),
    [safeOocNotes],
  );

  const oocnsfwHTML = useMemo(
    () => ({
      __html: `<span class='Chat'>${safeOocNotesNsfw}</span>`,
    }),
    [safeOocNotesNsfw],
  );

  return (
    <Stack fill>
      <Stack fill vertical>
        <Stack.Item align="center">
          {safeHeadshot ? (
            <img
              src={resolveAsset(safeHeadshot)}
              width="350px"
              height="350px"
            />
          ) : (
            <Box
              width="350px"
              height="350px"
              align="center"
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
              }}
              color="gray"
            >
              No headshot available.
            </Box>
          )}
        </Stack.Item>

        <Stack.Item grow>
          <Stack fill>
            <Stack.Item grow width="300px">
              <Section
                scrollable
                fill
                title="OOC Notes"
                preserveWhitespace
                buttons={
                  <>
                    <Button
                      selected={oocNotesIndex === 'SFW'}
                      bold={oocNotesIndex === 'SFW'}
                      onClick={() => setOocNotesIndex('SFW')}
                      textAlign="center"
                      minWidth="60px"
                    >
                      SFW
                    </Button>
                    <Button
                      selected={oocNotesIndex === 'NSFW'}
                      disabled={!safeOocNotesNsfw}
                      bold={oocNotesIndex === 'NSFW'}
                      onClick={() => setOocNotesIndex('NSFW')}
                      textAlign="center"
                      minWidth="60px"
                    >
                      NSFW
                    </Button>
                  </>
                }
              >
                {oocNotesIndex === 'SFW' &&
                  (safeOocNotes ? (
                    <Box dangerouslySetInnerHTML={oocHTML} />
                  ) : (
                    <Box color="gray">No OOC notes available.</Box>
                  ))}

                {oocNotesIndex === 'NSFW' &&
                  (safeOocNotesNsfw ? (
                    <Box dangerouslySetInnerHTML={oocnsfwHTML} />
                  ) : (
                    <Box color="gray">No NSFW OOC notes available.</Box>
                  ))}
              </Section>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>

      <Stack.Item grow>
        <Section
          scrollable
          fill
          preserveWhitespace
          title="Flavor Text"
          buttons={
            <>
              <Button
                selected={flavorTextIndex === 'SFW'}
                bold={flavorTextIndex === 'SFW'}
                onClick={() => setFlavorTextIndex('SFW')}
                textAlign="center"
                width="60px"
              >
                SFW
              </Button>
              <Button
                selected={flavorTextIndex === 'NSFW'}
                disabled={!canShowNsfwFlavor}
                bold={flavorTextIndex === 'NSFW'}
                onClick={() => setFlavorTextIndex('NSFW')}
                textAlign="center"
                width="60px"
              >
                NSFW
              </Button>
            </>
          }
        >
          {flavorTextIndex === 'SFW' && (
            <>
              {safeFlavorText ? (
                <Box dangerouslySetInnerHTML={flavorHTML} />
              ) : (
                <Box color="gray">No flavor text available.</Box>
              )}
              {Boolean(safeOocExtraImage) && (
                <Box
                  mt={1}
                  dangerouslySetInnerHTML={{
                    __html: safeOocExtraImage,
                  }}
                />
              )}
            </>
          )}

          {flavorTextIndex === 'NSFW' && (
            <>
              {safeFlavorTextNsfw ? (
                <Box dangerouslySetInnerHTML={nsfwHTML} />
              ) : (
                <Box color="gray">No NSFW flavor text available.</Box>
              )}
              {Boolean(safeNsfwOocExtraImage) && (
                <Box
                  mt={1}
                  dangerouslySetInnerHTML={{
                    __html: safeNsfwOocExtraImage,
                  }}
                />
              )}
            </>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

export const ImageGalleryPage = (props) => {
  const { data } = useBackend<ExaminePanelData>();
  const {
    img_gallery,
    nsfw_img_gallery,
    is_naked,
  } = data;

  const [galleryMode, setGalleryMode] = useState<'SFW' | 'NSFW'>('SFW');

  const safeSfwGallery = useMemo(
    () => (img_gallery || []).filter(isValidAssetValue),
    [img_gallery],
  );

  const safeNsfwGallery = useMemo(
    () => (nsfw_img_gallery || []).filter(isValidAssetValue),
    [nsfw_img_gallery],
  );

  const images = galleryMode === 'NSFW' ? safeNsfwGallery : safeSfwGallery;
  const canShowNsfwGallery = safeNsfwGallery.length > 0 && Boolean(is_naked);

  return (
    <Section
      title="Image Gallery"
      fill
      scrollable
      buttons={
        <>
          <Button
            selected={galleryMode === 'SFW'}
            bold={galleryMode === 'SFW'}
            onClick={() => setGalleryMode('SFW')}
            textAlign="center"
            minWidth="60px"
          >
            SFW
          </Button>
          <Button
            selected={galleryMode === 'NSFW'}
            disabled={!canShowNsfwGallery}
            bold={galleryMode === 'NSFW'}
            onClick={() => setGalleryMode('NSFW')}
            textAlign="center"
            minWidth="60px"
          >
            NSFW
          </Button>
        </>
      }
    >
      {images.length === 0 ? (
        <Box align="center" color="gray">
          No images available.
        </Box>
      ) : (
        <Stack fill justify="space-evenly">
          {images.map((val) => (
            <Stack.Item grow key={val}>
              <Section align="center">
                <Image
                  maxHeight="100%"
                  maxWidth="100%"
                  src={resolveAsset(val)}
                />
              </Section>
            </Stack.Item>
          ))}
        </Stack>
      )}
    </Section>
  );
};

export const NSFWHeadshotPage = (props) => {
  const { data } = useBackend<ExaminePanelData>();
  const {
    nsfw_headshot,
  } = data;

  const safeNsfwHeadshot = isValidAssetValue(nsfw_headshot)
    ? nsfw_headshot
    : null;

  return (
    <Stack fill justify="space-evenly">
      <Stack.Item grow>
        <Section align="center">
          {safeNsfwHeadshot ? (
            <Image
              maxHeight="100%"
              maxWidth="100%"
              src={resolveAsset(safeNsfwHeadshot)}
            />
          ) : (
            <Box align="center" color="gray">
              No nudeshot available.
            </Box>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
