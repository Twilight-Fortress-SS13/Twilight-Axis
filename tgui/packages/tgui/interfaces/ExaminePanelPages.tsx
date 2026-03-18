import { useState, useMemo } from 'react';
import { Box, Button, Image, Section, Stack } from 'tgui-core/components';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { ExaminePanelData } from './ExaminePanelData';

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

  const flavorHTML = useMemo(() => ({
    __html: `<span className='Chat'>${flavor_text}</span>`,
  }), [flavor_text]);

  const nsfwHTML = useMemo(() => ({
    __html: `<span className='Chat'>${flavor_text_nsfw}</span>`,
  }), [flavor_text_nsfw]);

  const oocHTML = useMemo(() => ({
    __html: `<span className='Chat'>${ooc_notes}</span>`,
  }), [ooc_notes]);

  const oocnsfwHTML = useMemo(() => ({
    __html: `<span className='Chat'>${ooc_notes_nsfw}</span>`,
  }), [ooc_notes_nsfw]);

  return (
    <Stack fill>
      <Stack fill vertical>
        <Stack.Item align="center">
          <img
            src={resolveAsset(headshot)}
            width="350px"
            height="350px"
          />
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
                      disabled={!ooc_notes_nsfw}
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
                {oocNotesIndex === 'SFW' && (
                  <Box dangerouslySetInnerHTML={oocHTML} />
                )}
                {oocNotesIndex === 'NSFW' && (
                  <Box dangerouslySetInnerHTML={oocnsfwHTML} />
                )}
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
                disabled={!flavor_text_nsfw || !is_naked}
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
              <Box dangerouslySetInnerHTML={flavorHTML} />
              {ooc_extra_image && (
                <Box
                  mt={1}
                  dangerouslySetInnerHTML={{
                    __html: ooc_extra_image,
                  }}
                />
              )}
            </>
          )}

          {flavorTextIndex === 'NSFW' && (
            <>
              <Box dangerouslySetInnerHTML={nsfwHTML} />
              {nsfw_ooc_extra_image && (
                <Box
                  mt={1}
                  dangerouslySetInnerHTML={{
                    __html: nsfw_ooc_extra_image,
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

  const images =
    galleryMode === 'NSFW' ? (nsfw_img_gallery || []) : (img_gallery || []);

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
            disabled={!nsfw_img_gallery?.length || !is_naked}
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

  return (
    <Stack fill justify="space-evenly">
      <Stack.Item grow>
        <Section align="center">
          <Image
            maxHeight="100%"
            maxWidth="100%"
            src={resolveAsset(nsfw_headshot)}
          />
        </Section>
      </Stack.Item>
    </Stack>
  );
};
