import React, { useState } from "react";
import {
	TextInput,
	ActionIcon,
	Group,
	Box,
	Badge,
	rem,
	NavLink,
} from "@mantine/core";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faXmark } from "@fortawesome/free-solid-svg-icons";
import { ButtonsEditor } from "./_buttons";
import { _BadgeEditorProps } from "../../../typings";

export const BadgeEdit: React.FC<_BadgeEditorProps> = ({
	inputKey,
	label,
	description,
	placeholder,
	defaultValue,
  resource,
  file,
  navKey,
  index,
  setResourceData
}) => {
	const [isHovered, setIsHovered] = useState<number>(0);
	const [isDisabled, setIsDisabled] = useState<boolean>(true);
	const [value, setValue] = useState<Array<string>>(defaultValue || []);

	const RemoveBadge = (index: number) => {
		return (
			<ActionIcon
				size={rem(5)}
				key={inputKey}
				variant="light"
				color="blue"
				onClick={(e) => {
					!isDisabled && setValue(value.filter((_, i) => i !== index));
				}}
				onMouseEnter={() => setIsHovered(index + 10)}
				onMouseLeave={() => setIsHovered(0)}
			>
				<FontAwesomeIcon
					icon={faXmark}
					size="xs"
					shake={isHovered === index + 10}
				/>
			</ActionIcon>
		);
	};

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
				description={description}
				disabled={isDisabled}
				m={5}
				onKeyDown={(e) => {
					if (e.key === "Enter") {
						!isDisabled && setValue([...value, e.currentTarget.value]);
						e.currentTarget.value = "";
					}
				}}
			/>
			<NavLink label="show/hide" h={3} m={5}>
				<Group position="center">
					{value.map((badge, index) => (
						<Badge
							key={index}
							pl={3}
							color="blue"
							variant="light"
							size="sm"
							sx={{ marginBottom: 5 }}
							rightSection={RemoveBadge(index)}
						>
							{badge}
						</Badge>
					))}
				</Group>
			</NavLink>
      <ButtonsEditor
        inputKey={inputKey}
        resource={resource}
        file={file}
        value={value}
        setIsDisabled={setIsDisabled}
        isDisabled={isDisabled}
        navKey={navKey}
        index={index}
        setResourceData={setResourceData}
      />
		</Box>
	);
};
