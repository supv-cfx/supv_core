import React from "react";
import { Kbd, Text } from "@mantine/core";

export const ActionItem: React.FC = () => {
	return (
		<div
			style={{
				display: "flex",
				justifyContent: "center",
				alignItems: "center",
			}}
		>
			<Kbd mr={5} size="xs">
				Y
			</Kbd>
			<Text c="teal.4" mr={5}>
				Accepter
			</Text>
			|
			<Text ml={5} mr={5} c="red.6">
				Refuser
			</Text>
			<Kbd size="xs" mr={5}>
				N
			</Kbd>
		</div>
	);
};