import React, { useState } from 'react';
import { Slider, Text, Box } from '@mantine/core';
import type { _SliderProps } from '../../../../typings';

export const SliderField: React.FC<_SliderProps> = ({
  index,
  label,
  defaultValue,
  min,
  max,
  step,
  transition,
  onChanged,
}) => {
  const [value, setValue] = useState<number>(defaultValue || 0);

  return (
    <Box mx='auto' sx={{ paddingTop: '10px' }}>
      <Text size='sm'>{label}</Text>
      <Slider
        label={value}
        defaultValue={value}
        min={min || 0}
        max={max || 100}
        step={step || 1}
        value={value}
        labelTransition={transition?.name || 'fade'}
        labelTransitionDuration={transition?.duration || 100}
        labelTransitionTimingFunction={transition?.timingFunction || 'ease'}
        onChangeEnd={(value: any) => {
          onChanged(index, value);
        }}
        onChange={(value: any) => {
          setValue(value);
        }}
      />
    </Box>
  );
};