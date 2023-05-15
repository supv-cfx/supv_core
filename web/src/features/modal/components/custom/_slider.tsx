import React, { useState } from 'react';
import { Slider, Text, Stack } from '@mantine/core';

interface Props {
  key: string;
  index: number;
  label?: string;
  defaultValue?: number;
  min?: number;
  max?: number;
  step?: number;
  onChanged: (index: number, value: number) => void;
}

export const SliderField: React.FC<Props> = ({
  index,
  key,
  label,
  defaultValue,
  min,
  max,
  step,
  onChanged,
}) => {
  const [value, setValue] = useState<number>(defaultValue || 0);
  const [endValue, setEndValue] = useState<number>(defaultValue || 0);

  return (
    <>
        <Stack p={0}>
            <Text td='dimmed' size='xs'>{label}</Text>
            <Slider
                key={key}
                label={value}
                defaultValue={defaultValue || 0}
                min={min || 0}
                max={max || 100}
                step={step || 1}
                value={value}
                onChangeEnd={(value) => {
                setEndValue(value);
                onChanged(index, endValue);
                }}
                onChange={(value) => {
                    setValue(value);
                }}
            />
        </Stack>
    </>
  );
};
