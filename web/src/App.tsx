import React, { useState } from "react";
import {
	MantineProvider,
	ColorSchemeProvider,
	ColorScheme,
} from "@mantine/core";
import { useClipboard } from '@mantine/hooks';
import { themeOverride } from "./theme";
import { useNuiEvent } from "./hooks/useNuiEvent";

import CrosshairTool from "./features/tool/Crosshair";
import Crosshair from "./features/crosshair/Crosshair";
//import {useConfig} from './providers/ConfigProvider'; // TODO: use config
import { isEnvBrowser } from "./utils/misc";
import ConvertUnixTime from "./features/tool/ConvertUnix";
//import DialogComponent from './features/dialog/Dialog';
import NotificationsWrapper from "./features/notify/SimpleNotifyWrapp";
import ModalConfirm from "./features/modal/ModalConfirm";
import ModalCustom from "./features/modal/ModalCustom";
import ActionWrapper from "./features/action/ActionWrapper";
//import ResourceManager from "./features/resource/main";
//import ChatText from './features/chat/Chat';

import DevTool from "./dev/DevEnv";


const App: React.FC = () => {
	//const { config } = useConfig(); // TODO: use config
	const [colorScheme, setColorScheme] = useState<ColorScheme>("dark");
	const toggleColorScheme = (value?: ColorScheme) =>
		setColorScheme(value || (colorScheme === "dark" ? "light" : "dark"));
	const clipboard = useClipboard({ timeout: 500 });

	useNuiEvent("supv_core:copy", (data) => {
	  clipboard.copy(data);
	});

	return (
		<>
			<ColorSchemeProvider
				colorScheme={colorScheme}
				toggleColorScheme={toggleColorScheme}
			>
				<MantineProvider
					theme={{ colorScheme, ...themeOverride }}
					withGlobalStyles
					withNormalizeCSS
				>
					<ConvertUnixTime />
					<ModalCustom />
					<ModalConfirm />
					<NotificationsWrapper />
          <CrosshairTool />
          <Crosshair />
		  <ActionWrapper />
					{/*<ChatText />
					<ResourceManager />*/}
				{isEnvBrowser() && <DevTool />}
				</MantineProvider>
			</ColorSchemeProvider>
		</>
	);
};

export default App;