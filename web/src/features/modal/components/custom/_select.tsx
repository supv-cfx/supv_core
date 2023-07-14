import React from 'react';
import { Select } from '@mantine/core';
import type { _SelectProps } from '../../../../typings';

export const SelectField: React.FC<_SelectProps> = ({
  index,
  label,
  data,
  options,
  onChanged,
  props
}) => {
  return (
    <>
      <Select
        withinPortal
        label={label}
        data={[...options] as any}
        sx={{paddingTop: '10px' }}
        required={data?.required || false}
        withAsterisk={data?.required || false}
        onChange={(value) => onChanged(index, value as string, data?.required, data?.callback)}
        error={props.error || false}
        styles={(theme) => ({
          item: {
            '&[data-selected]': {
              color: theme.colors.gray[1],
              backgroundColor: theme.colors.teal[6],
              '&, &:hover': {
                color: theme.colors.gray[1],
              },
            },
            '&[data-hovered]': {
              color: theme.colors.teal[8],
            },
            color: theme.colors.gray[1],
          },
        })}
      />
    </>
  );
};