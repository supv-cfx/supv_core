import { isEnvBrowser } from './utils/misc';
import DevTool from './dev/DevEnv';
//import { Notifications } from '@mantine/notifications';

import ConvertUnixTime from './features/tool/ConvertUnix';
import DialogComponent from './features/dialog/Dialog';
import SimpleNotifications from './features/notify/SimpleNotifyWrapp';
import ChatText from './features/chat/Chat';
//import {useConfig} from './providers/ConfigProvider';

const App: React.FC = () => {

    //const { config } = useConfig();

    return (
        <>
            <ChatText />
            <ConvertUnixTime />
            <DialogComponent />
            <SimpleNotifications/>
            {isEnvBrowser() && <DevTool />}
        </>
    )
}

export default App;
