import React from 'react';
import { PasswordInput  } from '@mantine/core';
import type { _PasswordProps } from '../../../../typings';

export const PasswordField: React.FC<_PasswordProps> = ({
  index,
  label,
  data,
  onChanged,
  props
}) => {
  return (
    <>
      <PasswordInput 
        label={label}
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