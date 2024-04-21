import React from "react";
import { NumberInput } from "@mantine/core";
import { MathRound } from "../../../utils";

interface ClassiqueProps {
	data: any;
	price: number;
	setData: (data: any) => void;
}

export const Classique: React.FC<ClassiqueProps> = ({
	data,
	price,
	setData,
}) => {
	return (
		<NumberInput
			label="Prix"
			//placeholder="Prix"
			required
      min={1}
			defaultValue={price}
			onChange={(value) => {
				setData({ ...data, 
          price: MathRound(Number(value), 0),
        });
			}}
		/>
	);
};
