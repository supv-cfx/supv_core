import React, { useState } from "react";
import { ActionIcon, Group } from "@mantine/core";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
	faPenToSquare,
	faCheck,
	faXmark,
} from "@fortawesome/free-solid-svg-icons";
import { fetchNui } from "../../../utils/fetchNui";
import { _ButtonEditorProps } from "../../../typings";

export const ButtonsEditor: React.FC<_ButtonEditorProps> = ({
	inputKey,
	resource,
	file,
	value,
	setIsDisabled,
	isDisabled,
	setResourceData,
	navKey,
	index,
}) => {
	const [isHovered, setIsHovered] = useState<number>(0);

	return (
		<Group position="right">
			<ActionIcon
				mb={5}
				variant="light"
				color="green"
				onMouseEnter={() => setIsHovered(1)}
				onMouseLeave={() => setIsHovered(0)}
				onClick={(e) => {
					!isDisabled && setIsDisabled(true);
					!isDisabled &&
						setResourceData(resource, file, value, navKey, index);
					const k = !isDisabled && inputKey.replace(`${resource}.`, "");
					!isDisabled &&
						fetchNui("supv:rm:validate", {
							resource: resource,
							file: file,
							key: k,
							value: value,
						});
				}}
			>
				<FontAwesomeIcon icon={faCheck} shake={isHovered === 1} />
			</ActionIcon>
			<ActionIcon
				mb={5}
				variant="light"
				color="orange"
				onMouseEnter={() => setIsHovered(2)}
				onMouseLeave={() => setIsHovered(0)}
				onClick={(e) => setIsDisabled(false)}
			>
				<FontAwesomeIcon icon={faPenToSquare} shake={isHovered === 2} />
			</ActionIcon>
			<ActionIcon
				mb={5}
				mr={5}
				variant="light"
				color="red"
				onMouseEnter={() => setIsHovered(3)}
				onMouseLeave={() => setIsHovered(0)}
				onClick={(e) => {
					!isDisabled && setIsDisabled(true);
				}}
			>
				<FontAwesomeIcon icon={faXmark} shake={isHovered === 3} />
			</ActionIcon>
		</Group>
	);
};
