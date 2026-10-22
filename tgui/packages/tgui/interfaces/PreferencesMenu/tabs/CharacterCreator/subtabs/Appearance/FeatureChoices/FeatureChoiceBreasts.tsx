import { LabeledGridList } from 'pm/components';
import type {
  Customizer,
  CustomizerChoice,
} from 'pm/tabs/CharacterCreator/data';
import { useBackendStrict } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export interface BreastsCustomizer extends CustomizerChoice {
  breast_size: string;
}

type LactationData = {
  lactating: BooleanLike;
};

export const FeatureChoiceBreasts = (props: { customizer: Customizer }) => {
  const { customizer } = props;
  const { act, data } = useBackendStrict<LactationData>();
  const { choices } = customizer;
  const { breast_size } = choices as BreastsCustomizer;

  return (
    <Stack.Item>
      <LabeledGridList>
        <LabeledGridList.Item label="Breast Size">
          <Button
            fluid
            onClick={() =>
              act('change_customizer', {
                customizer: customizer.type,
                customizer_task: 'breast_size',
              })
            }
          >
            {breast_size}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Lactation">
          <Button fluid onClick={() => act('toggle_lactation')}>
            {data.lactating ? 'Enabled' : 'Disabled'}
          </Button>
        </LabeledGridList.Item>
      </LabeledGridList>
    </Stack.Item>
  );
};
