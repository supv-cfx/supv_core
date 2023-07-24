import React, { useState } from "react";
import { TextInput, Box } from "@mantine/core";
import { ButtonsEditor } from "./_buttons";
import { _StringEditorProps } from "../../../typings";

export const InputEdit: React.FC<_StringEditorProps> = ({
	inputKey,
	label,
	description,
	placeholder,
	defaultValue,
	currentValue,
	resource,
	file,
}) => {
	const [isDisabled, setIsDisabled] = useState<boolean>(true);
  const [value, setValue] = useState<string | undefined>(currentValue || defaultValue);
	
	return (
		<Box
			sx={{
				backgroundColor: "rgba(255,255,255,0.035)",
				outline: "solid rgba(255,255,255, 0.2)",
				borderRadius: 2,
				margin: 5,
			}}
		>
			<TextInput
				key={inputKey}
				label={label}
				placeholder={placeholder}
				defaultValue={currentValue || defaultValue}
				description={description}
				disabled={isDisabled}
        onChange={(e) => {setValue(e.currentTarget.value)}}
				m={5}
			/>
      <ButtonsEditor 
        inputKey={inputKey}
        resource={resource}
        file={file}
        value={value}
        setIsDisabled={setIsDisabled}
        isDisabled={isDisabled}
      />
		</Box>
	);
};
