import { ComponentPropsWithoutRef } from "react";
import { Components } from "react-markdown";
import { Title } from "@mantine/core";

export const MarkdownComponents: Components = {
	h1: ({ node, ...props }) => (
		<Title {...(props as ComponentPropsWithoutRef<typeof Title>)} />
	),
	h2: ({ node, ...props }) => (
		<Title order={2} {...(props as ComponentPropsWithoutRef<typeof Title>)} />
	),
	h3: ({ node, ...props }) => (
		<Title order={3} {...(props as ComponentPropsWithoutRef<typeof Title>)} />
	),
};