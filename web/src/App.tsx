import ConvertUnixTime from './features/tool/ConvertUnix';
import DialogComponent from './features/dialog/Dialog';
import { isEnvBrowser } from './utils/misc';
import DevTool from './dev/DevEnv';

const App: React.FC = () => {
    return (
        <>
            <ConvertUnixTime />
            <DialogComponent />
            {isEnvBrowser() && <DevTool />}
        </>
    )
}

export default App;
