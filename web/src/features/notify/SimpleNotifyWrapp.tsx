import React from "react";
import { toast, Toaster } from "react-hot-toast";
//import ReactMarkdown from "react-markdown";
import { createStyles, Notification, Kbd } from "@mantine/core";
import { useQueue, useHotkeys } from "@mantine/hooks";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import type { NotificationProps } from "../../typings/Notification";
import { useConfig } from "../../providers/ConfigProvider";
import { SelectAnime } from "../../animation/notifications";
import { fetchNui } from "../../utils/fetchNui";
import { isEnvBrowser } from "../../utils/misc";

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
const NotificationsWrapper: React.FC = () => {
	const { config } = useConfig();
	const useStyles = createStyles((theme) => ({ ...config.notificationStyles }));
	const { classes } = useStyles();
	const { state, queue, add, update } = useQueue({
		limit: 1,
	});
	let key = isEnvBrowser() ? 0 : 0;

	const updateStateAndQueue = () => {
		const updatedState =
			queue.length > 0 ? [...state.slice(1), queue[0]] : state.slice(1);
		update(() => updatedState);
	};

	const handleSubmit = () => {
		if (state[0]) {
      // @ts-ignore
			const { data, toastId, timerId } = state[0];
			if (toastId) {
				clearTimeout(timerId);
				toast.dismiss(toastId);
				updateStateAndQueue();
				fetchNui("supv:notify:response", { response: true, id: data.key });
			}
		}
	};

	const handleRefuse = () => {
		if (state[0]) {
			// @ts-ignore
			const { data, toastId, timerId } = state[0];
			if (toastId) {
				clearTimeout(timerId);
				toast.dismiss(toastId);
				updateStateAndQueue();
				fetchNui("supv:notify:response", { response: false, id: data.key });
			}
		}
	};

  useHotkeys([
    ['Y', () => handleSubmit()],
    ['N', () => handleRefuse()]
  ]);

	useNuiEvent<NotificationProps>("supv:notification:send", async (data) => {
		if (isEnvBrowser() && data.type === "action") {
			key++;
			data.key = key as number;
		}

		if (!data.title && !data.description) return;

		let position = !data.position ? "top-right" : data.position;
		if (!data.icon && data.type !== "loading" && data.type) {
			data.icon =
				data.type === "error"
					? "xmark"
					: data.type === "success"
					? "check"
					: data.type === "warning"
					? "exclamation"
					: "info";
		}
		let description: string = data.description
			? data.description.replace("\n", "  \n")
			: "";

		const { posEnter, posExit } = SelectAnime(
			data?.animation?.enter,
			data?.animation?.exit,
			position?.includes("bottom") ? "bottom" : "top",
			position?.includes("top")
				? "top"
				: position?.includes("right")
				? "right"
				: position?.includes("left")
				? "left"
				: "right",
			"top",
			undefined
		);

		await new Promise((resolve) => setTimeout(resolve, 150));
		const toastId = toast.custom(
			(t) => (
				<Notification
					withBorder={data.border}
					w={300}
					loading={data.type === "loading"}
					{...(data.icon
						? {
								icon: (
									<FontAwesomeIcon
										icon={data.icon}
										beat={data.iconAnim === "beat"}
										fade={data.iconAnim === "fade"}
										// @ts-ignore
										flip={data.iconAnim === "flip"}
										spin={data.iconAnim === "spin"}
										pulse={data.iconAnim === "pulse"}
										shake={data.iconAnim === "shake"}
									/>
								),
						  }
						: undefined)}
					title={data.title}
					radius="md"
					withCloseButton={data.closable || false}
					onClose={() => {
						data.closable && toast.dismiss(t.id);
					}}
					color={
						!data.type && !data.color
							? "dark"
							: data.color
							? data.color
							: data.type === "error"
							? "red"
							: data.type === "success"
							? "teal"
							: data.type === "warning"
							? "orange"
							: data.type === "loading"
							? "white"
							: "white"
					}
					sx={{
						background:
							"linear-gradient(45deg, rgba(7, 18, 39, 0.94) 25%, rgba(8, 25, 56, 0.94) 50%, rgba(14, 44, 100, 0.86) 100%)",
						animation: t.visible
							? `${posEnter} 0.3s ease-out forwards`
							: `${posExit} 0.5s ease-in forwards`,
					}}
					styles={{
						title: {
							fontFamily: "Yellowtail",
							paddingBottom: "0px",
							fontSize: 20,
						},
						description: {
							paddingTop: "0px",
							color: "white",
							wordWrap: "break-word",
						},
						icon: {
							backgroundColor: "transparent",
							color:
								!data.type && !data.color
									? "dark"
									: data.color
									? data.color
									: data.type === "error"
									? "red"
									: data.type === "success"
									? "teal"
									: data.type === "warning"
									? "orange"
									: data.type === "loading"
									? "white"
									: "blue",
						},
					}}
					className={`${classes.container}`}
					style={data.style || (classes.container as React.CSSProperties)}
				>
					{data?.type !== "action" && data.description ? (
						<>{description}</>
					) : (
						<>
							{description}
							<br />
							<Kbd>Y</Kbd> - Accepter | <Kbd>N</Kbd> - Refuser
						</>
					)}
				</Notification>
			),
			{
				id: data.id?.toString(),
				duration: data.duration || 3000,
				position: position || "top-right",
			}
		);

		if (data.type === "action") {
			const timerId = setTimeout(() => {
				toast.dismiss(toastId);
				updateStateAndQueue();
				fetchNui("supv:notify:response", { response: "null", id: data.key });
			}, data.duration! - 1000 || 5000 - 1000);
			add({ data, toastId, timerId });
		}
	});

	return <Toaster />;
};

export default NotificationsWrapper;