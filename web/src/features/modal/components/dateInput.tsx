import { useState } from 'react';
import { DateInput } from '@mantine/dates';

const DateInputDev: React.FC = () => {

    const [value, setValue] = useState<Date | null>(null);
    
    const formatDate = (date: Date | null): string => {
        return date ? date.toLocaleDateString('fr-FR', { day: '2-digit', month: '2-digit', year: 'numeric' }) : '';
    };

    const onPlaceHolder = (date: Date | null): string => {
        return date ? formatDate(date) : new Date().toLocaleDateString('fr-FR', { day: '2-digit', month: '2-digit', year: 'numeric' });
    };

    return (
        <DateInput
            value={value}
            onChange={setValue}
            label="Date input"
            placeholder={onPlaceHolder(value)}
            valueFormat="DD/MM/YYYY"
            maw={400}
            mx="auto"
        />
    );
}

export default DateInputDev;