import React, { useState } from "react";
import {
	MantineProvider,
	ColorSchemeProvider,
	ColorScheme,
} from "@mantine/core";
import { themeOverride } from "./theme";

import CrosshairTool from "./features/tool/Crosshair";
import Crosshair from "./features/crosshair/Crosshair";
//import {useConfig} from './providers/ConfigProvider'; // TODO: use config
import { isEnvBrowser } from "./utils/misc";
import ConvertUnixTime from "./features/tool/ConvertUnix";
//import DialogComponent from './features/dialog/Dialog';
import NotificationsWrapper from "./features/notify/SimpleNotifyWrapp";
import ModalConfirm from "./features/modal/ModalConfirm";
import ModalCustom from "./features/modal/ModalCustom";
//import ResourceManager from "./features/resource/main";
//import ChatText from './features/chat/Chat';

import DevTool from "./dev/DevEnv";
import { useNuiEvent } from "./hooks/useNuiEvent";

const App: React.FC = () => {
	//const { config } = useConfig(); // TODO: use config
	const [colorScheme, setColorScheme] = useState<ColorScheme>("dark");
	const toggleColorScheme = (value?: ColorScheme) =>
		setColorScheme(value || (colorScheme === "dark" ? "light" : "dark"));

  useNuiEvent("supv_core:copy", async (data) => {
    try {
      const clipboard = navigator.clipboard;
      await clipboard.writeText(data);
      console.log(`copied to clipboard\n ${data}`);
    } catch (err) {
      console.error('Erreur lors de la tentative de copie', err);
    }
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
					{/*<ChatText />
					<ResourceManager />*/}
				{isEnvBrowser() && <DevTool />}
				</MantineProvider>
			</ColorSchemeProvider>
		</>
	);
};

export default App;
