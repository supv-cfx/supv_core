import React from "react";
import { Image } from "@mantine/core";
import ReactMarkdown from "react-markdown";
import { MarkdownComponents } from "../../../utils";

interface _DescriptionProps {
  description: string,
	source?: string
}

export const DescriptionItem: React.FC<_DescriptionProps> = ({
  description,
	source
}) => {
	return (
		<div style={{ display: "flex", flexDirection: "row" }}>
			{source && (
				<Image
          src={source}
					style={{
						marginTop: "8px",
						marginRight: "8px",
						width: "20%",
						height: "auto",
					}}
				/>
			)}
			<ReactMarkdown components={MarkdownComponents}>
				{description}
			</ReactMarkdown>
		</div>
	);
};
