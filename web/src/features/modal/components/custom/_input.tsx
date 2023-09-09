import React from 'react';
import { TextInput } from '@mantine/core';
import type { _TextInputProps } from '../../../../typings';

export const InputField: React.FC<_TextInputProps> = ({
  index,
  label,
  data,
  onChanged,
  props
}) => {
  return (
    <>
      <TextInput
        label={label}
        defaultValue={data?.default || ''}
        sx={{ paddingTop: '10px' }}
        placeholder={data?.placeholder || ''}
        description={data?.description || ''}
        required={data?.required || false}
        minLength={data?.min || 0}
        maxLength={data?.max || 255}
        onChange={(event) => onChanged(index, event.target.value, data?.required, data?.callback)}
        error={props.error || false}
      />
    </>
  );
};
