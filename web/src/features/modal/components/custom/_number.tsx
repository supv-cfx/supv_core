import React from 'react';
import { NumberInput } from '@mantine/core';
import type { _NumberInputProps } from '../../../../typings';

export const NumberField: React.FC<_NumberInputProps> = ({
  index,
  label,
  data,
  onChanged,
  props,
}) => {
  return (
    <>
      <NumberInput
        label={label}
        sx={{ paddingTop: '10px' }}
        placeholder={data?.placeholder || ''}
        description={data?.description || ''}
        required={data?.required || false}
        withAsterisk={data?.required || false}
        defaultValue={data?.defaultValue || null}
        min={data?.min}
        max={data?.max}
        step={data?.step}
        precision={data?.precision || 0}
        formatter={(value) =>
          data?.format
            ? !Number.isNaN(parseFloat(value))
              ? `${data?.format.value || '$'} ${value}`.replace(
                  /\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g,
                  `${data?.format.separator || ' '}`
                )
              : `${data?.format.value || '$'}`
            : value
        }
        onChange={(value: number) =>
          onChanged(index, value, data?.required, data?.callback)
        }
        error={props.error || data.required ? "Ce champ est requis!" : false}
      />
    </>
  );
};
