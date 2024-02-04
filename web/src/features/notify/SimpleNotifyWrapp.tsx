import React, { useState, useEffect, useCallback } from "react";
import type {
	Minimap,
	MinimapProps,
	NotificationProps,
  NotificationItemsProps,
} from "../../typings";
import { useQueue, useHotkeys } from "@mantine/hooks";
import {
	MathRandom,
	isEnvBrowser,
	fetchNui,
	useNuiEvent,
} from "../../utils";
import NotificationItem from "./Notification";

let key = 0;

const NotificationsWrapper: React.FC = () => {
	const [minimap, setMinimap] = useState<Minimap>({
		x: 0,
		y: 0,
		w: 300,
		h: 0,
		expanded: false,
	});
	const { state, queue, add, update /*, cleanQueue */ } = useQueue({
		initialValues: [] as NotificationItemsProps[],
		limit: 3,
	});

	const addNotification = async (id: string, data: NotificationProps) => {
		return new Promise<void>((resolve) => {
			if (!data.duration)
				data.duration = data?.type === "action" ? 10000 : 3000;
			if (!data.dur || data.duration > data.dur) data.dur = data.duration;

			const newNotification: NotificationItemsProps = {
				id: id,
				visible: true,
				data,
				dur: data.duration,
			};

			if (isEnvBrowser() && data.type === "action") {
				key++;
				newNotification.data.key = key;
			}

			const existingNotification = state.find((item) => item.id === id);
			// Si la notification existe dans le state alors on la met à jour
			if (existingNotification) {
				existingNotification.data = { ...existingNotification.data, ...data };
				existingNotification.data.duration = data.duration || 3000;

				update((prevNotifications) => {
					return prevNotifications.map((notification) => {
						if (notification.id === id) {
							return existingNotification;
						}

						return notification;
					});
				});
			} else {
				// Si la notification n'existe pas dans le state

				// Verification si la notification existe dans la queue
				const existingNotificationInQueue = queue.find(
					(item) => item.id === id
				);

				// Si la notification existe dans la queue on la met à jour
				if (existingNotificationInQueue) {
					update((item) => {
						return item.map((notification) => {
							if (notification.id === id) {
								return newNotification;
							}
							return notification;
						});
					});
				} else {
					// Si la notification n'existe pas dans la queue on l'ajoute
					add(newNotification);
				};
			};

			resolve();
		});
	};

	const findActionIndex = () => {
		for (let i = 0; i < state.length; i++) {
			if (state[i].data.type === "action") return i;
		}
		return false;
	};

	const handleSubmit = () => {
		if (state.length > 0) {
			const Index = findActionIndex();
			if (Index === false) return;
			const Action = state[Index];
			fetchNui("supv:notify:response", { response: true, id: Action.data.key });
			RemoveInQueue(Index, Action.id);
		}
	};

	const handleRefuse = () => {
		if (state.length > 0) {
			const Index = findActionIndex();
			if (Index === false) return;
			const Action = state[Index];
			fetchNui("supv:notify:response", {
				response: false,
				id: Action.data.key,
			});
			RemoveInQueue(Index, Action.id);
		}
	};

	useHotkeys([
		["Y", handleSubmit],
		["N", handleRefuse],
	]);

	const RemoveInQueue = useCallback(
		(index: number, id: string) => {
			state[index].visible = false;
			update((prevNotifications) => {
				return prevNotifications.map((notification, i) => {
					if (i === index) notification.visible = false;
					return notification;
				});
			});

			setTimeout(() => {
				// ici on supprime la notification du state d'où l'id correspond
				update((prevNotifications) => {
					return prevNotifications.filter(
						(notification) => notification.id !== id
					);
				});
			}, 500);
		},
		[state, update]
	);

	useEffect(() => {
		const interval = setInterval(() => {
			update((prevNotifications) => {
				return prevNotifications.map((notification, index) => {
					if (state[index]) {
						if (typeof notification.data.duration !== "number")
							return notification;
						if (notification.data.duration <= 0) {
							if (notification.data.type === "action") {
								fetchNui("supv:notify:response", {
									response: "null",
									id: notification.data.key,
								});
							}

							RemoveInQueue(index, notification.id);
						} else notification.data.duration -= 50;
					}
					return notification;
				});
			});
		}, 50);

		return () => {
			clearInterval(interval);
		};
	}, [state, update, RemoveInQueue]);

	useNuiEvent<MinimapProps>("supv_core:hud:minimap", async (d) => {
		await new Promise((resolve) => setTimeout(resolve, 200));
		setMinimap((prevData) => ({
			...prevData,
			[d.name]: d.value,
		}));
	});

	useNuiEvent<NotificationProps>("supv:notification:send", async (d) => {
		await addNotification(
			!d.id ? `${Date.now()}${MathRandom(111, 999)}` : d.id,
			d
		);
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
				position: "fixed",
			}}
		>
			{state.map((notification, index) => (
				<NotificationItem
					key={notification.id}
					notification={notification}
					duration={notification.dur}
					zi={state.length - index}
				/>
			))}
		</div>
	);
};

export default NotificationsWrapper;

/**
  SAVE REGEX

    	//const foundBadge = data.title?.match(/{badge:(.*)/);
	let regexTitle = notification.data.title
  ? notification.data.title.match(
      /{badge:(.*?)(?::(.*?))?(?::(.*?))?(?::(.*?))?(?::(.*?))?}/
    )
  : null;
  let newTitle = regexTitle && notification.data.title;
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
 */