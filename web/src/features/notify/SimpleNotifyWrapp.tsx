import React, { useState, useEffect } from "react";
import type { Minimap, MinimapProps, NotificationProps } from "../../typings";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { Badge, Title, Progress, Image, Loader } from "@mantine/core";
import ReactMarkdown, { Components } from "react-markdown";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";

interface Notification {
	dur: number;
	id: string;
	visible?: boolean;
	data: NotificationProps;
}

/**
  exemple badge title => {badge:text:color:variant:size:radius} :
  title = "Vous avez reçu 5$ {badge:bonus:red:outline:sx}"
  regex = /{badge:(.*?)(?::(.*?))?(?::(.*?))?(?::(.*?))?(?::(.*?))?}/
  regex[0] = "{badge:bonus:red:outline:sx}"
  regex[1] = "bonus"
  regex[2] = "red"
  regex[3] = "outline"
  regex[4] = "sx"
  regex[5] = "xs"
  newTitle = "Vous avez reçu 5$ "
*/

const MarkdownComponents: Components = {
	//@ts-ignore
	h1: ({ node, ...props }) => <Title {...props} />,
	//@ts-ignore
	h2: ({ node, ...props }) => <Title order={2} {...props} />,
	//@ts-ignore
	h3: ({ node, ...props }) => <Title order={3} {...props} />,
};

const NotificationItem: React.FC<{
	notification: Notification;
	duration: number;
}> = ({ notification, duration }) => {
	const { id, data, visible } = notification;

	const animationStyle = {
		width: "100%",
		height: "auto",
		marginBottom: "4px",
		padding: "12px",
		background: "rgba(26, 27, 30, 0.90)",
		color: "#fff",
		animation: visible
			? "scaleIn 0.3s ease-in forwards"
			: "scaleOut 0.5s ease-in forwards",
	};

	//const foundBadge = data.title?.match(/{badge:(.*)/);
	let regexTitle = notification.data.title
		? notification.data.title.match(
				/{badge:(.*?)(?::(.*?))?(?::(.*?))?(?::(.*?))?(?::(.*?))?}/
		  )
		: null;
	let newTitle = regexTitle && notification.data.title;
	const description = data.description
		? data.description.replace("\n", "  \n")
		: "";

	if (regexTitle && notification.data.title) {
		newTitle = notification.data.title.replace(regexTitle[0], "");
		regexTitle[1] =
			regexTitle[1] === undefined || regexTitle[1] === "?"
				? "info"
				: regexTitle[1];
		regexTitle[2] =
			regexTitle[2] === undefined || regexTitle[2] === "?"
				? "green"
				: regexTitle[2];
		regexTitle[3] =
			regexTitle[3] === undefined || regexTitle[3] === "?"
				? "light"
				: regexTitle[3];
		regexTitle[4] =
			regexTitle[4] === undefined || regexTitle[4] === "?"
				? "sx"
				: regexTitle[4];
		regexTitle[5] =
			regexTitle[5] === undefined || regexTitle[5] === "?"
				? "xs"
				: regexTitle[5];
	}

	const progress = ((duration - notification.data.duration) / duration) * 100;
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
		<>
			<style>
				{`
          @keyframes scaleIn {
            from {
              opacity: 0;
              transform: scale(0.5);
            }
            to {
              opacity: 1;
              transform: scale(1);
            }
          }

          @keyframes scaleOut {
            0% {
              opacity: 1;
              transform: translateY(0) rotateX(0) scale(1);
            }
            50% {
              opacity: 0.1;
              transform: translateY(300px) rotateX(-15deg) scale(0.5);
            }
            100% {
              opacity: 0;
              transform: translateY(600px) rotateX(-30deg) scale(0);
            }
          }
        `}
			</style>
			<div key={id} style={animationStyle}>
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
												// @ts-ignore
												flip={data.iconStyle?.animation === "flip"}
												spin={data.iconStyle?.animation === "spin"}
												pulse={data.iconStyle?.animation === "pulse"}
												shake={data.iconStyle?.animation === "shake"}
											/>
										) : (
											<Loader
												size="sm"
                        color={data.iconStyle?.color as string || iconColor || "white"}
                        variant={data.iconStyle?.animation as "dots" as "bars" as "oval" || "oval"}
												style={{
													paddingRight: "8px",
												}}
											/>
										)}
									</>
								)}
								{regexTitle && newTitle ? newTitle : data.title}
							</div>
							{regexTitle && newTitle && (
								<Badge
									color={regexTitle[2]}
									variant={regexTitle[3]}
									style={{ marginRight: "8px" }}
									size={regexTitle[4]}
									radius={regexTitle[5]}
								>
									{regexTitle[1]}
								</Badge>
							)}
						</div>
						{description && (
							<div style={{ display: "flex", flexDirection: "row" }}>
								{data.image && (
									<Image
										src={data.image}
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
						)}
					</div>
				</div>
				<Progress
					value={100 - progress}
					size="xs"
					radius="sm"
					color="white"
					style={{ marginTop: "8px" }}
				/>
			</div>
		</>
	);
};

const NotificationsWrapper: React.FC = () => {
	const [minimap, setMinimap] = useState<Minimap>({
		x: 0,
		y: 0,
		w: 150,
		h: 0,
		expanded: false,
	});
	const [notifications, setNotifications] = useState<Notification[]>([]);

	const addNotification = async (id: string, data: NotificationProps) => {
		return new Promise<void>((resolve) => {
			if (!data.duration) data.duration = 3000;
			if (!data.dur || data.duration > data.dur) data.dur = data.duration;

			const newNotification: Notification = {
				id: id,
				visible: true,
				data,
				dur: data.duration,
			};

			const existingNotification = notifications.find(
				(notification) => notification.id === id
			);

			if (existingNotification) {
				existingNotification.data = { ...existingNotification.data, ...data };
				existingNotification.data.duration = data.duration || 3000;

				setNotifications((prevNotifications) => {
					return prevNotifications.map((notification) => {
						if (notification.id === id) {
							return existingNotification;
						}

						return notification;
					});
				});
			} else {
				setNotifications((prevNotifications) => [
					...prevNotifications,
					newNotification,
				]);
			}

			resolve();
		});
	};

	useEffect(() => {
		const interval = setInterval(() => {
			setNotifications((prevNotifications) => {
				return prevNotifications.filter((notification) => {
					notification.data.duration -= 100;
					notification.visible = notification.data.duration > 700;
					return notification.data.duration > 0;
				});
			});
		}, 100);

		return () => {
			clearInterval(interval);
		};
	}, [notifications]);

	useNuiEvent<MinimapProps>("supv_core:hud:minimap", async (d) => {
		await new Promise((resolve) => setTimeout(resolve, 200));
		setMinimap((prevData) => ({
			...prevData,
			[d.name]: d.value,
		}));

    // console.log('y : ' + minimap.y);
    // console.log('h : ' + minimap.h);
    // console.log('w : ' + minimap.w);
    // console.log('x : ' + minimap.x);
    // console.log('expanded : ' + minimap.expanded);
    // console.log('--------------------------');
    // console.log('y + w: ' + (minimap.y + minimap.w));
	});

	useNuiEvent<NotificationProps>("supv:notification:send", async (data) => {
		await addNotification(!data.id ? Date.now().toString() : data.id, data);
	});

	return (
		<div
			style={{
				left: `${minimap.x}px`,
				bottom: `${minimap.h + 36}px`,
				width: `${minimap.w}px`,
				height: "auto",
				display: "flex",
				flexDirection: "column-reverse",
				alignItems: "flex-start",
				//backgroundColor: "rgba(39, 39, 39, 0.7)",
				zIndex: 0,
				//padding: "16px",
				position: "fixed",
			}}
		>
			{notifications.map((notification) => (
				<NotificationItem
					key={notification.id}
					notification={notification}
					duration={notification.dur}
				/>
			))}
		</div>
	);
};

export default NotificationsWrapper;

// import React, { useState } from "react";
// import { toast, Toaster } from "react-hot-toast";
// //import ReactMarkdown from "react-markdown";
// import { createStyles, Notification, Kbd } from "@mantine/core";
// import { useQueue, useHotkeys } from "@mantine/hooks";
// import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
// import { useNuiEvent } from "../../hooks/useNuiEvent";
// import type { NotificationProps, MinimapProps, Minimap } from "../../typings/Notification";
// import { useConfig } from "../../providers/ConfigProvider";
// import { SelectAnime } from "../../animation/notifications";
// import { fetchNui } from "../../utils/fetchNui";
// import { isEnvBrowser } from "../../utils/misc";

// const NotificationsWrapper: React.FC = () => {
//   const { config } = useConfig();
//   const useStyles = createStyles((theme) => ({ ...config.notificationStyles }));
//   const { classes } = useStyles();
//   const [minimap, setMinimap] = useState<Minimap>({ x: 0, y: 0, w: 0, h: 0, expanded: false });
//   const { state, queue, add, update } = useQueue({
//     limit: 1,
//   });
//   let key = isEnvBrowser() ? 0 : 0;

//   let miniStyle = {
//     //position: "absolute",
//     left: `${(minimap.x + minimap.w) + (minimap.w/80)}px`,
//     top: `${minimap.y}px`,
//     width: `${minimap.w + minimap.w / 5}px`,
//     height: `${minimap.h}px`,
//     display: "flex",
//     //flexDirection: "column",
//     alignItems: "flex-start",
//     //justifyContent: "flex-start",
//     backgroundColor: 'rgba(39, 39, 39, 0.7)',
//     zIndex: 0,
//   };

//   return (
//     <div style={{...miniStyle, flexDirection: 'column', position: 'absolute'}}>

//     </div>
//   )
// }

// export default NotificationsWrapper;

/**
 * Notifications - A component for displaying notifications
 * @example `lua`
 *
 *supv.notify('simple', {
 *    id = 'notification_1',
 *    title = 'Notification title',
 *    description = 'Notification description',
 *    type = 'info',
 *    duration = 5000,
 *    icon = 'circle',
 *    position = 'bottom-right',
 *    color = 'gray',
 *    closable = false,
 *    border = false,
 *    iconAnim = 'beat',
 *    style = { fontSize: '16px', backgroundColor: rgba(255, 255, 255, 0.25) },
 *    animation = {enter = 'slide', exit = 'slideInElliptic'}
 *})
 * @class Notifications
 * @param {string?} data.title - Title of the notification
 * @param {string?} data.description - Description of the notification
 * @param {string?} data.type - Type of the notification
 * @param {string?} data.color - Color of the notification
 * @param {string?} data.icon - Icon of the notification
 * @param {string?} data.iconAnim - Animation of the icon
 * @param {string?} data.position - Position of the notification
 * @param {string?} data.animation - Animation of the notification
 * @param {number?} data.duration - Duration of the notification
 * @param {boolean?} data.closable - Closable of the notification
 * @param {boolean?} data.border - Border of the notification
 * @param {React.CSSProperties?} data.style - Style of the notification
 * @param {string?} data.id - Id of the notification
 * @returns {Toaster} notifications
 * @type {NotificationProps}
 */
// const NotificationsWrapper: React.FC = () => {
// 	const { config } = useConfig();
// 	const useStyles = createStyles((theme) => ({ ...config.notificationStyles }));
// 	const { classes } = useStyles();
//   const [minimap, setMinimap] = useState<Minimap>({ x: 0, y: 0, w: 0, h: 0, expanded: false });
// 	const { state, queue, add, update } = useQueue({
// 		limit: 1,
// 	});
// 	let key = isEnvBrowser() ? 0 : 0;

// 	const updateStateAndQueue = () => {
// 		const updatedState =
// 			queue.length > 0 ? [...state.slice(1), queue[0]] : state.slice(1);
// 		update(() => updatedState);
// 	};

//   useNuiEvent<MinimapProps>("supv_core:hud:minimap", async (d) => {
// 		//console.log(JSON.stringify(d));
// 		await new Promise((resolve) => setTimeout(resolve, 200));
// 		setMinimap((prevData) => ({
// 			...prevData,
// 			[d.name]: d.value,
// 		}))
// 	});

// 	const handleSubmit = () => {
// 		if (state[0]) {
//       // @ts-ignore
// 			const { data, toastId, timerId } = state[0];
// 			if (toastId) {
// 				clearTimeout(timerId);
// 				toast.dismiss(toastId);
// 				updateStateAndQueue();
// 				fetchNui("supv:notify:response", { response: true, id: data.key });
// 			}
// 		}
// 	};

// 	const handleRefuse = () => {
// 		if (state[0]) {
// 			// @ts-ignore
// 			const { data, toastId, timerId } = state[0];
// 			if (toastId) {
// 				clearTimeout(timerId);
// 				toast.dismiss(toastId);
// 				updateStateAndQueue();
// 				fetchNui("supv:notify:response", { response: false, id: data.key });
// 			}
// 		}
// 	};
// /**
//  * <div
//           className="container-info"
//           style={{
//             //backgroundColor: 'rgba(39, 39, 39, 0.7)',
//             position: "absolute",
//             left: `${(minimap.x + minimap.w) + (minimap.w/80)}px`,
//             top: `${minimap.y}px`,
//             width: `${minimap.w + minimap.w / 5}px`,
//             height: `${minimap.h}px`,
//             display: "flex",
//             flexDirection: "column",
//             alignItems: "flex-start",
//             //justifyContent: "flex-start",
//             zIndex: 0,
//           }}
//         >
//  */
//   useHotkeys([
//     ['Y', () => handleSubmit()],
//     ['N', () => handleRefuse()]
//   ]);

// 	useNuiEvent<NotificationProps>("supv:notification:send", async (data) => {
// 		if (isEnvBrowser() && data.type === "action") {
// 			key++;
// 			data.key = key as number;
// 		}

// 		if (!data.title && !data.description) return;

// 		let position = !data.position ? "minimap" : data.position;
// 		if (!data.icon && data.type !== "loading" && data.type) {
// 			data.icon =
// 				data.type === "error"
// 					? "xmark"
// 					: data.type === "success"
// 					? "check"
// 					: data.type === "warning"
// 					? "exclamation"
// 					: "info";
// 		}
// 		let description: string = data.description
// 			? data.description.replace("\n", "  \n")
// 			: "";

// 		const { posEnter, posExit } = SelectAnime(
// 			data?.animation?.enter,
// 			data?.animation?.exit,
// 			position?.includes("bottom") ? "bottom" : "top",
// 			position?.includes("top")
// 				? "top"
// 				: position?.includes("right")
// 				? "right"
// 				: position?.includes("left")
// 				? "left"
// 				: "right",
// 			"top",
// 			undefined
// 		);

//     let miniStyle = {
//       position: "absolute",
//       left: `${(minimap.x + minimap.w) + (minimap.w/80)}px`,
//       top: `${minimap.y}px`,
//       width: `${minimap.w + minimap.w / 5}px`,
//       height: `${minimap.h}px`,
//       display: "flex",
//       flexDirection: "column",
//       alignItems: "flex-start",
//       //justifyContent: "flex-start",
//       zIndex: 0,
//     };

// 		await new Promise((resolve) => setTimeout(resolve, 150));
// 		const toastId = toast.custom(
// 			(t) => (
// 				<Notification
// 					withBorder={data.border}
// 					w={300}
// 					loading={data.type === "loading"}
// 					{...(data.icon
// 						? {
// 								icon: (
// 									<FontAwesomeIcon
// 										icon={data.icon}
// 										beat={data.iconAnim === "beat"}
// 										fade={data.iconAnim === "fade"}
// 										// @ts-ignore
// 										flip={data.iconAnim === "flip"}
// 										spin={data.iconAnim === "spin"}
// 										pulse={data.iconAnim === "pulse"}
// 										shake={data.iconAnim === "shake"}
// 									/>
// 								),
// 						  }
// 						: undefined)}
// 					title={data.title}
// 					radius="md"
// 					withCloseButton={data.closable || false}
// 					onClose={() => {
// 						data.closable && toast.dismiss(t.id);
// 					}}
// 					color={
// 						!data.type && !data.color
// 							? "dark"
// 							: data.color
// 							? data.color
// 							: data.type === "error"
// 							? "red"
// 							: data.type === "success"
// 							? "teal"
// 							: data.type === "warning"
// 							? "orange"
// 							: data.type === "loading"
// 							? "white"
// 							: "white"
// 					}
// 					sx={{
// 						background:
// 							"linear-gradient(45deg, rgba(7, 18, 39, 0.94) 25%, rgba(8, 25, 56, 0.94) 50%, rgba(14, 44, 100, 0.86) 100%)",
// 						animation: t.visible
// 							? `${posEnter} 0.3s ease-out forwards`
// 							: `${posExit} 0.5s ease-in forwards`,
// 					}}
// 					styles={{
// 						title: {
// 							fontFamily: "Yellowtail",
// 							paddingBottom: "0px",
// 							fontSize: 20,
// 						},
// 						description: {
// 							paddingTop: "0px",
// 							color: "white",
// 							wordWrap: "break-word",
// 						},
// 						icon: {
// 							backgroundColor: "transparent",
// 							color:
// 								!data.type && !data.color
// 									? "dark"
// 									: data.color
// 									? data.color
// 									: data.type === "error"
// 									? "red"
// 									: data.type === "success"
// 									? "teal"
// 									: data.type === "warning"
// 									? "orange"
// 									: data.type === "loading"
// 									? "white"
// 									: "blue",
// 						},
// 					}}
// 					className={`${classes.container}`}
// 					style={data.style || (classes.container as React.CSSProperties)}
// 				>
// 					{data?.type !== "action" && data.description ? (
// 						<>{description}</>
// 					) : (
// 						<>
// 							{description}
// 							<br />
// 							<Kbd>Y</Kbd> - Accepter | <Kbd>N</Kbd> - Refuser
// 						</>
// 					)}
// 				</Notification>
// 			),
// 			{
// 				id: data.id?.toString(),
// 				duration: data.duration || 3000,
// 				position: position || "top-right",
// 			}
// 		);

// 		if (data.type === "action") {
// 			const timerId = setTimeout(() => {
// 				toast.dismiss(toastId);
// 				updateStateAndQueue();
// 				fetchNui("supv:notify:response", { response: "null", id: data.key });
// 			}, data.duration! - 1000 || 5000 - 1000);
// 			add({ data, toastId, timerId });
// 		}
// 	});

// 	return <Toaster />;
// };

// export default NotificationsWrapper;
