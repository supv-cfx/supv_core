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
        defaultValue={data?.default || null}
        onChange={(value) => onChanged(index, value as string, data?.required, data?.callback)}
        error={props.error || false}
        styles={(theme) => ({
          item: {
            '&[data-selected]': {
               color: 'white',
               background: 'rgba(14, 44, 100, 0.86)', //theme.colors.blue[6],
              '&, &:hover': {
                color: 'white',
                background: 'rgba(14, 44, 100, 0.86)'
              },
            },
            '&[data-hovered]': {
              //color: theme.colors.blue[8],
              background: 'rgba(14, 44, 100, 0.86)',
            },
            //color: theme.colors.gray[1],
          },
        })}
      />
    </>
  );
};