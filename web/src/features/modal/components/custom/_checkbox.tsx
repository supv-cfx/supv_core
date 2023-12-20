import React from 'react';
import { Checkbox } from '@mantine/core';
import type { _CheckboxProps } from '../../../../typings';

export const CheckboxField: React.FC<_CheckboxProps> = ({
  index,
  label,
  defaultValue,
  data,
  onChanged,
  props
}) => {
  return (
    <>
      <Checkbox
        sx={{ display: 'flex', paddingTop: '10px' }}
        label={label}
        defaultChecked={defaultValue || false}
        onChange={(event: any) => onChanged(index, event.target.checked, data?.required, data?.callback)}
        error={!defaultValue && props.error}
      />
    </>
  );
};