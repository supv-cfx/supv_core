import { isEnvBrowser } from './utils/misc';
import DevTool from './dev/DevEnv';

import ConvertUnixTime from './features/tool/ConvertUnix';
import DialogComponent from './features/dialog/Dialog';
import Notifications from './features/notify/Notify';

const App: React.FC = () => {
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
