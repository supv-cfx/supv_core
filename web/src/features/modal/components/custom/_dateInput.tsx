import { useState } from 'react';
import { DateInput } from '@mantine/dates';

interface Props {
    key: string;
    index: number;
    label?: string;
    data?: Data;
    onChanged: (index: number, value: string) => void;
}

export const DateInputField: React.FC<Props> = ({key, index, label, data, onChanged}) => {
  const [value, setValue] = useState<Date | null>(null);

  const formatDate = (date: Date | null): string => {
    return date
      ? date.toLocaleDateString('fr-FR', {
          day: '2-digit',
          month: '2-digit',
          year: 'numeric',
        })
      : '';
  };

  const handlerChange = (date: Date | null) => {
    setValue(date);
    onChanged(index, formatDate(date));
    };

  const onPlaceHolder = (date: Date | null): string => {
    return date
      ? formatDate(date)
      : new Date().toLocaleDateString('fr-FR', {
          day: '2-digit',
          month: '2-digit',
          year: 'numeric',
        });
  };

  return (
      <DateInput
        key={key}
        value={value}
        onChange={handlerChange}
        label={label}
        placeholder={onPlaceHolder(value)}
        valueFormat='DD/MM/YYYY'
        mx='xs'
        style={{ width: 'auto', height: 'auto'}}
      />
  );
};