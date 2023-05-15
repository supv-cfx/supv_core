import React from 'react';
import { TextInput } from '@mantine/core';

interface Props {
  key: string;
  index: number;
  label?: string;
  data?: Data;
  onChanged: (index: number, value: string) => void;
}

export const InputField: React.FC<Props> = ({
  index,
  key,
  label,
  data,
  onChanged,
}) => {
  return (
    <>
      <TextInput
        key={key}
        label={label}
        placeholder={data?.placeholder || ''}
        description={data?.description || ''}
        required={data?.required || false}
        minLength={data?.min || 0}
        maxLength={data?.max || 255}
        onChange={(event) => onChanged(index, event.target.value)}
      />
    </>
  );
};
