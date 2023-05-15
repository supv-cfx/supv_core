import React from 'react';
import { Checkbox } from '@mantine/core';

interface Props {
  key: string;
  index: number;
  label?: string;
  defaultValue?: boolean;
  onChanged: (index: number, value: boolean) => void;
}

export const CheckboxField: React.FC<Props> = ({
  index,
  key,
  label,
  defaultValue,
  onChanged,
}) => {
  return (
    <>
      <Checkbox
        sx={{ display: 'flex' }}
        key={key}
        label={label}
        defaultChecked={defaultValue || false}
        onChange={(event) => onChanged(index, event.target.checked)}
      />
    </>
  );
};
