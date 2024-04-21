import React from "react";
import { Select, NumberInput, TextInput } from "@mantine/core";
import { MathRound } from "../../../utils";

interface AmendesProps {
	data: any;
	options: Array<{ label: string; value: string | number }>;
  amendesOptions: { [key: number]: { label: string, amount: number, id: number } };
	//onChanged: (key: string, value: any) => void;
  setData: (data: any) => void;
}

export const Amendes: React.FC<AmendesProps> = ({
	data,
	options,
  amendesOptions,
  setData,
	//onChanged,
}) => {
	return (
		<>
			<Select
        key={'select-amende'}
				withinPortal
				data={[...options] as any}
				label="Sélectionner une amende"
				required
				withAsterisk
				onChange={(value) => {
          // @ts-ignore
          const obj = value!== 'custom' ? amendesOptions[value] : {label: '', amount: 0, id: 0};
          
          setData({ 
            ...data, 
            amende_id: value,
            amende_label: obj.label,
            price: obj.amount,
            amount: data.remise ? MathRound(Number(obj.amount) - (Number(obj.amount) * data.remise / 100), 0) : obj.amount
          });          
        }}
				styles={(theme) => ({
					item: {
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
						//color: theme.colors.gray[1],
					},
				})}
			/>
			{data.amende_id === "custom" && (
        <>
          <TextInput
            label="Nom de l'amende"
            required
            withAsterisk
            onChange={(e) => setData({...data, amende_label: e.currentTarget.value})/* onChanged("amende_label", value)*/}
          />
          <NumberInput
            label="Montant de l'amende"
            placeholder="Montant de l'amende"
            required
            withAsterisk
            min={0}
            onChange={(value) => {
              setData({...data, 
                price: value,
                amount: data.remise ? MathRound(Number(value) - (Number(value) * data.remise / 100), 0) : value
              })
            }/* onChanged("price", value)*/}
          />
        </>
			)}
		</>
	);
};
