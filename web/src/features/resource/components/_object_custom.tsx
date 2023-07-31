import React, { useState } from "react";
import {
	Box,
	Switch,
	Text,
	TextInput,
	Group,
	ActionIcon,
	MultiSelect
} from "@mantine/core";
import { ButtonsEditor } from "./_buttons";
import { _ObjectCustomEditorProps } from "../../../typings";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
	faPlus,
	faXmark,
} from "@fortawesome/free-solid-svg-icons";

export const ObjectCustom: React.FC<_ObjectCustomEditorProps> = ({
	inputKey,
	label,
	description,
	currentValue,
	resource,
	file,
	navKey,
	index,
	data,
	setResourceData,
}) => {
	const [isDisabled, setIsDisabled] = useState<boolean>(true);
	const [value, setValue] = useState<Record<string, any>>(currentValue);

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
			{Object.keys(value).map((v: string, i: number) =>
				data[v].type === "boolean" ? (
					<Switch
						key={`${inputKey}-${i}`}
						checked={value[v]}
						disabled={isDisabled}
						label={data[v].description || ""}
						onChange={(e) => {
							const newValue = { ...value };
							newValue[v] = e.currentTarget.checked;
							setValue(newValue);
						}}
						size="xs"
						m={10}
					/>
				) : data[v].type === "text" ? (
					<Text m={5} size="sm">
						{v}
					</Text>
				) : data[v].type === "input" ? (
					<TextInput
						key={`${inputKey}-${i}`}
						value={value[v]}
						onChange={(e) => {
							const newValue = { ...value };
							newValue[v] = e.currentTarget.value;
							setValue(newValue);
						}}
						disabled={isDisabled}
						size="xs"
						m={10}
					/>
				) : data[v].type === 'array-multi-select' ? (
					<MultiSelect
						key={`${inputKey}-${i}`}
						label={data[v].label}
						data={data[v].values}
						defaultValue={value[v]}
						onChange={(e) => {
							const newValue = { ...value };
							newValue[v] = e;
							setValue(newValue);
						}}
						disabled={isDisabled}
						size="xs"
						m={10}
						clearable
					/>
				) : data[v].type === "object-switch" ? (
					<Box
						sx={{
							backgroundColor: "rgba(255,255,255,0.035)",
							outline: "solid rgba(255,255,255, 0.2)",
							borderRadius: 2,
							margin: 10,
						}}
					>
						{data[v].label && (
							<Text m={5} size="sm">
								{data[v].label}
							</Text>
						)}
						{Object.keys(value[v]).map((vv: string, ii: number) => (
							<Group>
								<ActionIcon
									variant="light"
									color={!isDisabled ? "red" : "gray"}
									onClick={(e) => {
										if (!isDisabled) {
											const newValue = { ...value };
											delete newValue[v][vv];
											setValue(newValue);
										}
									}}
									size={5}
									ml={10}
									mt={10}
								>
									<FontAwesomeIcon icon={faXmark} size="xs" />
								</ActionIcon>
								<Switch
									key={`${inputKey}-${i}-${ii}`}
									checked={value[v][vv]}
									disabled={isDisabled}
									label={vv || `${label} ${i}`}
									onChange={(e) => {
										const newValue = { ...value };
										newValue[v][vv] = e.currentTarget.checked;
										setValue(newValue);
									}}
									size="xs"
									mt={10}
									ml={!data[v].canRemove ? 10 : 0}
								/>
							</Group>
						))}
						{data[v].canAdd && (
							<TextInput
								description={data[v].addDescription}
								onKeyDown={(e) => {
									if (e.key === "Enter") {
										const newValue = { ...value };
										const currentVal = e.currentTarget.value;
										switch (data[v].keyFormat) {
											case "lowercase":
												newValue[v][currentVal.toLowerCase()] = true;
												break;
											case "uppercase":
												newValue[v][currentVal.toUpperCase()] = true;
												break;
											default:
												newValue[v][currentVal] = true;
												break;
										} 
										setValue(newValue);
									}
								}}
								icon={<FontAwesomeIcon icon={faPlus} color={!isDisabled ? 'green' : 'gray'} />}
								disabled={isDisabled}
								size="xs"
								m={10}
							/>
						)}
					</Box>
				) : null
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