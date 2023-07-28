import React, { useState } from "react";
import { Box, Switch, Text } from "@mantine/core";
import { ButtonsEditor } from "./_buttons";
import { _ObjectSwitchEditorProps } from "../../../typings";

export const ObjectSwitch: React.FC<_ObjectSwitchEditorProps> = ({
	inputKey,
	label,
	description,
	currentValue,
	resource,
	file,
	navKey,
	index,
	setResourceData,
}) => {
	const [isDisabled, setIsDisabled] = useState<boolean>(true);
	const [value, setValue] = useState<Record<string, boolean>>(currentValue);

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
			{description && (
				<Text m={5} size="xs">
					{description}
				</Text>
			)}

			{Object.keys(value).map((v: string, i: number) => (
				<Switch
					key={`${inputKey}-${i}`}
					checked={value[v]}
					disabled={isDisabled}
					label={v || `${label} ${i}`}
					onChange={(e) => {
						const newValue = { ...value };
						newValue[v] = e.currentTarget.checked;
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
