import React, { useState } from 'react';
import { MantineProvider, ColorSchemeProvider, ColorScheme } from '@mantine/core';
import { themeOverride } from './theme';

//import {useConfig} from './providers/ConfigProvider'; // TODO: use config
import { isEnvBrowser } from './utils/misc';

import ConvertUnixTime from './features/tool/ConvertUnix';
//import DialogComponent from './features/dialog/Dialog';
import SimpleNotifications from './features/notify/SimpleNotifyWrapp';
import ModalWrapper from './features/modal/ModalWrapper';
import ChatText from './features/chat/Chat';

import DevTool from './dev/DevEnv';

const App: React.FC = () => {
    //const { config } = useConfig(); // TODO: use config
    const [colorScheme, setColorScheme] = useState<ColorScheme>('dark');
    const toggleColorScheme = (value?: ColorScheme) => setColorScheme(value || (colorScheme === 'dark' ? 'light' : 'dark'));
    return (
        <>
            <ColorSchemeProvider colorScheme={colorScheme} toggleColorScheme={toggleColorScheme}>
                <MantineProvider theme={{colorScheme, ...themeOverride}} withGlobalStyles withNormalizeCSS>
                    <ChatText />
                    <ConvertUnixTime />
                    <ModalWrapper />
                    <SimpleNotifications />
                    {isEnvBrowser() && <DevTool />}
                </MantineProvider>
            </ColorSchemeProvider>
        </>
    )
}

export default App;
