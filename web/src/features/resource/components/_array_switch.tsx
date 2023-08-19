import React, { useState } from "react";
import { Box, Switch, Text } from "@mantine/core";
import { ButtonsEditor } from "./_buttons";
import { CanAddInputEditor } from "./_canAdd";
import { _ArraySwitchEditorProps } from "../../../typings";

export const ArraySwitch: React.FC<_ArraySwitchEditorProps> = ({
	inputKey,
	label,
	description,
	currentValue,
	resource,
	file,
	navKey,
	groupLabel,
	index,
	setResourceData,
	canAdd,
	addOption,
}) => {
	const [isDisabled, setIsDisabled] = useState<boolean>(true);
	const [value, setValue] = useState<Array<boolean>>(currentValue);
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
			{value.map((v, i) => (
				<Switch
					key={`${inputKey} ${i}`}
					checked={v}
					disabled={isDisabled}
					label={groupLabel[i] || `${label} ${i}`}
					onChange={(e) => {
						const newValue = [...value];
						newValue[i] = e.currentTarget.checked;
						setValue(newValue);
					}}
					size="xs"
					m={10}
				/>
			))}
			{canAdd && (
				<CanAddInputEditor
					addOption={addOption as any}
					state={isDisabled}
					value={value}
					setValue={setValue}
				/>
			)}
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
