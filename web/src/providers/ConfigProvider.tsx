import { Context, createContext, useContext, useEffect, useState } from 'react';
import { MantineColor } from '@mantine/core';
import { fetchNui } from '../utils/fetchNui';
import { 
  NotificationConfigProviderProps,
  EmojiPickerProps
} from '../typings';
import {
  NotificationConfigDev,
  ConfigEmojiPicker
} from '../dev/config';

interface Config {
  primaryColor: MantineColor;
  primaryShade: 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9;
  notificationStyles: NotificationConfigProviderProps;
  emojiPicker: EmojiPickerProps;
}

interface ConfigCtxValue {
  config: Config;
  setConfig: (config: Config) => void;
}

const ConfigCtx = createContext<{ config: Config; setConfig: (config: Config) => void } | null>(null);

const ConfigProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [config, setConfig] = useState<Config>({
    primaryColor: 'blue',
    primaryShade: 6,
    notificationStyles: NotificationConfigDev,
    emojiPicker: ConfigEmojiPicker,
  });

  useEffect(() => {
    fetchNui<Config>('supv:react:getConfig').then((data) => setConfig(data));
  }, []);

  return <ConfigCtx.Provider value={{ config, setConfig }}>{children}</ConfigCtx.Provider>;
};

export const useConfig = () => useContext<ConfigCtxValue>(ConfigCtx as Context<ConfigCtxValue>);
export default ConfigProvider;