import { isEnvBrowser } from './utils/misc';
import DevTool from './dev/DevEnv';

import ConvertUnixTime from './features/tool/ConvertUnix';
import DialogComponent from './features/dialog/Dialog';
import Notifications from './features/notify/Notify';
//import {useConfig} from './providers/ConfigProvider';

const App: React.FC = () => {

    //const { config } = useConfig();

    return (
        <>
            <ConvertUnixTime />
            <DialogComponent />
            <Notifications />
            {isEnvBrowser() && <DevTool />}
        </>
    )
}

export default App;
