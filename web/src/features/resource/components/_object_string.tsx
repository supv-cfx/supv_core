import React, { useState } from "react";
import { Box, TextInput, Text } from "@mantine/core";
import { ButtonsEditor } from "./_buttons";
import { _ObjectInputEditorProps } from "../../../typings";

export const ObjectString: React.FC<_ObjectInputEditorProps> = ({
	inputKey,
	label,
	description,
	currentValue,
	resource,
	file,
  placeHolders,
	navKey,
	index,
	setResourceData,
}) => {
	const [isDisabled, setIsDisabled] = useState<boolean>(true);
	const [value, setValue] = useState<Record<string, string>>(currentValue);

	return (
		<Box
			sx={{
				backgroundColor: "rgba(255,255,255,0.035)",
				outline: "solid rgba(255,255,255, 0.2)",
				borderRadius: 2,
				margin: 5,
			}}
		>
			{label && (
				<Text m={5} size="sm">
					{label}
				</Text>
			)}
			{Object.keys(value).map((v: string, i: number) => (
				<TextInput
					key={`${inputKey}-${i}`}
					value={value[v]}
          description={description && description[v] || ''}
          placeholder={placeHolders && placeHolders[v] || ''}
					disabled={isDisabled}
					//label={v || `${label} ${i}`}
					onChange={(e) => {
						const newValue = { ...value };
						newValue[v] = e.currentTarget.value;
						setValue(newValue);
					}}
					size="xs"
					m={10}
				/>
			))}
			<ButtonsEditor
				inputKey={inputKey}
				resource={resource}
				file={file}
				value={value}
				setIsDisabled={setIsDisabled}
				isDisabled={isDisabled}
				index={index}
				navKey={navKey}
				setResourceData={setResourceData}
			/>
		</Box>
	);
};
