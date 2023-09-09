import React, { useState } from "react";
import { DateInput } from "@mantine/dates";
import type { _DateInputProps } from "../../../../typings";
import dayjs from "dayjs";
import "dayjs/locale/fr";
//import { fr } from 'date-fns/locale';

interface DateType {
	status: "subtract" | "add";
	type: "year" | "month" | "day";
	value: number;
}

export const DateInputField: React.FC<_DateInputProps> = ({
	index,
	label,
	data,
	onChanged,
	props,
}) => {
	const [value, setValue] = useState<Date | null>(null);

	const formatDate = (date: Date | null): string => {
		return date
			? date.toLocaleDateString("fr-FR", {
					day: "2-digit",
					month: "2-digit",
					year: "numeric",
			  })
			: "";
	};

	const handlerChange = (date: Date | null) => {
		setValue(date);
		onChanged(index, formatDate(date), data?.required, data?.callback);
	};

	const onPlaceHolder = (date: Date | null): string => {
		return date
			? formatDate(date)
			: new Date().toLocaleDateString("fr-FR", {
					day: "2-digit",
					month: "2-digit",
					year: "numeric",
			  });
	};

	const selectOnDate = (data: DateType) => {
		return dayjs(new Date())[data.status](data?.value, data?.type).toDate();
	};

	return (
		<DateInput
			locale="fr"
			value={value}
			sx={{
				paddingTop: "10px",
				//item: {
				//  '&[data-selected]': {
				//    color: 'white',
				//    background: 'rgba(14, 44, 100, 0.86)', //theme.colors.blue[6],
				//    '&, &:hover': {
				//      color: 'white',
				//      background: 'rgba(14, 44, 100, 0.86)'
				//    },
				//  },
				//  '&[data-hovered]': {
				//    //color: theme.colors.blue[8],
				//    background: 'rgba(14, 44, 100, 0.86)',
				//  },
				//  //color: theme.colors.gray[1],
				//},
			}}
			styles={(theme) => ({
				day: {
					"&[data-selected]": {
						color: "white",
						background: "rgba(14, 44, 100, 0.86)", //theme.colors.blue[6],
						"&, &:hover": {
							color: "white",
							background: "rgba(14, 44, 100, 0.86)",
						},
					},
					"&:hover": {
						//color: theme.colors.blue[8],
						backgroundColor: "rgba(14, 44, 100, 0.86)",
						color: "white",
					},
					//color: theme.colors.gray[1],
				},
				month: {
					"&[data-selected]": {
						color: "white",
						background: "rgba(14, 44, 100, 0.86)", //theme.colors.blue[6],
						"&, &:hover": {
							color: "white",
							background: "rgba(14, 44, 100, 0.86)",
						},
					},
					"&:hover": {
						//color: theme.colors.blue[8],
						//backgroundColor: "rgba(14, 44, 100, 0.86)",
						//color: "white",
					},
					//color: theme.colors.gray[1],
				},
				yearsList: {
					"&[data-selected]": {
						color: "white",
						background: "rgba(14, 44, 100, 0.86)", //theme.colors.blue[6],
						"&, &:hover": {
							color: "white",
							background: "rgba(14, 44, 100, 0.86)",
						},
					},
					"&[data-hovered]": {
						//color: theme.colors.blue[8],
						background: "rgba(14, 44, 100, 0.86)",
					},
					"&:hover": {
						//color: theme.colors.blue[8],
						//backgroundColor: "rgba(14, 44, 100, 0.86)",
						//color: "white",
					},
					//color: theme.colors.gray[1],
				},
			})}
			popoverProps={{ withinPortal: true, position: "top" }}
			minDate={data.minDate && selectOnDate(data.minDate)}
			maxDate={data.maxDate && selectOnDate(data.maxDate)}
			onChange={handlerChange}
			label={label}
			placeholder={onPlaceHolder(value)}
			valueFormat="DD/MM/YYYY"
			mx="xs"
			required={data?.required || false}
			error={props.error || false}
			withAsterisk={data?.required || false}
		/>
	);
};
