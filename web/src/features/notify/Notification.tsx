import React/*, { useState, useEffect } */from "react";
import type { NotificationItemsProps, BadgeProps } from "../../typings";
import {
	FontAwesomeIconProps,
	FontAwesomeIcon,
} from "@fortawesome/react-fontawesome";
import { IconProp } from "@fortawesome/fontawesome-svg-core";
import { Avatar, Badge, Loader, Progress, Title } from "@mantine/core";
import { ActionItem, DescriptionItem } from "./components";

// const MathRandom = (min: number, max: number, current: number) => {
// 	let r = Math.floor(Math.random() * (max - min + 1) + min);
// 	while (r === current) {
// 		r = MathRandom(min, max, current);
// 	}
// 	return r;
// };

// Faire plusieurs couleurs différentes
// const Rainbow = [
// 	"red",
// 	"orange",
// 	"yellow",
// 	"green",
// 	"blue",
// 	"indigo",
// 	"violet",
// ];

// interface RainbowProps {
// 	rainbow: number;
// 	color: string;
// }

const NotificationItem: React.FC<{
	notification: NotificationItemsProps;
	duration: number;
	zi: number;
}> = ({ notification, duration, zi }) => {
	const { id, data, visible } = notification;
	// const [rainbow, setRainbow] = useState<RainbowProps>({
	// 	rainbow: 0,
	// 	color: Rainbow[0],
	// });

	// Changement de couleur toutes les 1.5 secondes
	// useEffect(() => {
	// 	const interval = setInterval(() => {
	// 		setRainbow((prevRainbow) => ({
	// 			rainbow: MathRandom(0, Rainbow.length - 1, prevRainbow.rainbow),
	// 			color: Rainbow[MathRandom(0, Rainbow.length - 1, prevRainbow.rainbow)],
	// 		}));
	// 	}, 1500);
	// 	return () => clearInterval(interval);
	// }, [rainbow]);

	let BadgeAddon =
		data?.badge && data.badge?.type === "icon" ? (
			<FontAwesomeIcon
				icon={data.badge?.name as IconProp}
				color={data.badge.color}
				size={(data.badge?.size as FontAwesomeIconProps["size"]) || "xs"}
				style={data.badge.style}
				beat={data.badge.animation === "beat"}
				fade={data.badge.animation === "fade"}
				spin={data.badge.animation === "spin"}
				pulse={data.badge.animation === "pulse"}
				shake={data.badge.animation === "shake"}
				//@ts-ignore
				//flip={data.badge.animation === "flip" && "horizontal"}
			/>
		) : data?.badge && data.badge?.type === "avatar" ? (
			<Avatar
				src={data.badge.src}
				size={data.badge.size || "xs"}
				radius={data.badge.radius || "xl"}
				gradient={data.badge?.gradient as BadgeProps["gradient"]}
				alt={data.badge.alt}
				m={data.badge.m || 0}
				ml={data.badge.ml || 0}
				mr={data.badge.mr || 0}
				mt={data.badge.mt || 0}
				mb={data.badge.mb || 0}
				imageProps={data.badge.imageProps}
				variant={data.badge.variant}
			/>
		) : undefined;

	const description = data.description
		? data.description.replace("\n", "  \n")
		: "";

	const progress = notification.data.duration
		? ((duration - notification.data.duration) / duration) * 100
		: 0;
	const icon = data.icon
		? data.icon
		: data.type === "error"
		? "xmark"
		: data.type === "success"
		? "check"
		: data.type === "warning"
		? "exclamation"
		: data.type === "loading"
		? true
		: undefined;
	const iconColor =
		data.type === "error"
			? "red"
			: data.type === "success"
			? "teal"
			: data.type === "warning"
			? "orange"
			: data.type === "loading"
			? "white"
			: "white";
	return (
		<div
			key={id}
			style={{
				width: "100%",
				height: "auto",
				marginBottom: "1px",
				padding: "5px",
				background: "rgba(0, 0, 0, 0.6)",
				color: "#fff",
				//transition: "height 0.3s ease-in-out, opacity 0.3s ease-in-out",
				animation: visible
					? "NotifyScaleIn 0.3s ease-in forwards"
					: "NotifyScaleOut 0.5s ease-in forwards",
				zIndex: zi,
        border: "2px solid",
        borderColor: 'rgba(14, 44, 100, 0.86)',
        //borderRadius: "10px",
        transition: "all 2s",
			}}
		>
			<div style={{ display: "flex", alignItems: "center" }}>
				<div style={{ flex: 1 }}>
					<div
						style={{
							display: "flex",
							justifyContent: "space-between",
							alignItems: "center",
						}}
					>
						<div style={{ fontWeight: "bold" }}>
							{icon && (
								<>
									{typeof icon === "string" ? (
										<FontAwesomeIcon
											icon={icon}
											style={{
												paddingRight: "8px",
												color:
													(data.iconStyle?.color as string) ||
													iconColor ||
													"white",
											}}
											size="sm"
											beat={data.iconStyle?.animation === "beat"}
											fade={data.iconStyle?.animation === "fade"}
											spin={data.iconStyle?.animation === "spin"}
											pulse={data.iconStyle?.animation === "pulse"}
											shake={data.iconStyle?.animation === "shake"}
											// @ts-ignore
											//flip={data.iconStyle?.animation === "flip" && "both"}
										/>
									) : (
										<Loader
											size="sm"
											color={
												(data.iconStyle?.color as string) ||
												iconColor ||
												"white"
											}
											variant={
												(data.iconStyle
													?.animation as "dots" as "bars" as "oval") || "oval"
											}
											style={{
												paddingRight: "8px",
											}}
										/>
									)}
								</>
							)}
							<Title order={5} style={{ display: "inline-block" }}>
								{data.title}
							</Title>
						</div>
						{data.badge && data.badge.text && (
							<Badge
								color={data.badge.color || "teal.4"}
								variant={data.badge.variant || "light"}
								style={{ ...data.badge?.style, marginRight: "8px" }}
								size={data.badge.size || "xs"}
								radius={data.badge.radius || "sm"}
								rightSection={
									BadgeAddon && data.badge.position === "right"
										? BadgeAddon
										: undefined
								}
								leftSection={
									BadgeAddon && data.badge.position === "left"
										? BadgeAddon
										: undefined
								}
							>
								{data.badge.text}
							</Badge>
						)}
					</div>
					{description && (
						<DescriptionItem description={description} source={data.image} />
					)}
					{data?.type === "action" && <ActionItem />}
				</div>
			</div>
			<Progress
				value={progress > 0 ? 100 - progress : 0}
				size="xs"
				radius="sm"
				color="white"
				style={{ marginTop: "8px" }}
			/>
		</div>
	);
};

export default NotificationItem;
