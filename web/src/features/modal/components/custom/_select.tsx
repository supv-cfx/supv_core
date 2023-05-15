import React from 'react';
import { Select } from '@mantine/core';

interface Props {
  key: string;
  index: number;
  label?: string;
  data?: Data;
  onChanged: (index: number, value: string) => void;
}

export const SelectField: React.FC<Props> = ({
  index,
  key,
  label,
  data,
  onChanged,
}) => {
  return (
    <>
      <Select
        key={key}
        label={label}
        data={[...data as any]}
        required={data?.required || false}
        onChange={(value) => onChanged(index, value as string)}
      />
    </>
  );
};
