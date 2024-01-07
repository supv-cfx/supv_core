import React, { useState } from "react";
import { Text, ColorPicker, Box } from "@mantine/core";
import type { _ColorPickerProps } from "../../../../typings";

export const ColorPickerField: React.FC<_ColorPickerProps> = ({
	index,
	label,
	data,
	onChanged,
  props,
}) => {
  const [color, setColor] = useState(data?.default || '#000000');

	return (
		<Box sx={{ paddingTop: "10px", textAlign: 'center'}}>
			<Text size="sm">{label}</Text>
			<ColorPicker
        format={data?.format || "rgb"}
				value={color}
        size={props?.size}
        swatches={props?.swatches}
        swatchesPerRow={props?.swatchesPerRow}
				onChange={(value: string) => {
          setColor(value);
					//onChanged(index, value, data?.required, data?.callback);
				}}
        onChangeEnd={(value: string) => {
          //setColor(value);
          onChanged(index, value, data?.required, data?.callback);
        }}
        sx={{ margin: 'auto' }}  // Centrer le ColorPicker
			/>
      <Text size='xs' sx={{ paddingTop: '5px' }}>{color}</Text>
		</Box>
	);
};
