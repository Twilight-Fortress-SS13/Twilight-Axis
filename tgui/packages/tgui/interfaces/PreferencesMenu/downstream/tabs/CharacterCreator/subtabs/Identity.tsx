import { useBackend } from 'tgui/backend';
import { Button } from 'tgui-core/components';

export const SubtabIdentityCardGameplayDownstream = () => {
  const { act } = useBackend();

  return (
    <>
      <Button
        fluid
        icon="house"
        mt={1}
        onClick={() => act('open_manor_preferences')}
      >
        Manor Preferences
      </Button>
      <Button
        fluid
        icon="gamepad"
        mt={1}
        onClick={() => act('open_ccg_preferences')}
      >
        Arlette Deck Builder
      </Button>
      <Button
        fluid
        icon="users"
        mt={1}
        onClick={() => act('open_family_preferences')}
      >
        Family Preferences
      </Button>
    </>
  );
};

export const SubtabIdentityDownstreamPaneLeft = (props) => {
  // Suggested format:
  // return (
  //   <>
  //     <Stack.Item>
  //       <MyCardHere />
  //     </Stack.Item>
  //     <Stack.Item>
  //       <MyCardHere2 />
  //     </Stack.Item>
  //   </>
  // )

  return null;
};

export const SubtabIdentityDownstreamPaneRight = (props) => {
  // Suggested format:
  // return (
  //   <>
  //     <Stack.Item>
  //       <MyCardHere />
  //     </Stack.Item>
  //     <Stack.Item>
  //       <MyCardHere2 />
  //     </Stack.Item>
  //   </>
  // )

  return null;
};
