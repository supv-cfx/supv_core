import { Context, createContext, useContext, useEffect, useState } from 'react';
import { MantineColor } from '@mantine/core';
import { fetchNui } from '../utils/fetchNui';

interface Config {
  primaryColor: MantineColor;
  primaryShade: 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9;
  notificationStyles: {
    container: React.CSSProperties;
    title: React.CSSProperties;
    description: React.CSSProperties;
    descriptionOnly: React.CSSProperties;
  }
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
    notificationStyles: {
      container: {
        width: 'fit-content',
        //width: 300,
        maxWidth: 400,
        minWidth: 300,
        height: 'fit-content',
        backgroundColor: 'dark.4',
        fontFamily: 'Ubuntu',
      },
      title: {
        fontWeight: 500,
        lineHeight: 'normal',
        color: 'gray.6',
      },
      description: {
        fontSize: 12,
        color: 'gray.4',
        fontFamily: 'Ubuntu',
        lineHeight: 'normal',
      },
      descriptionOnly: {
        fontSize: 14,
        color: 'gray.2',
        fontFamily: 'Ubuntu',
        lineHeight: 'normal',
      },
    }
  });

  useEffect(() => {
    fetchNui<Config>('supv:react:getConfig').then((data) => setConfig(data));
  }, []);

  return <ConfigCtx.Provider value={{ config, setConfig }}>{children}</ConfigCtx.Provider>;
};

export default ConfigProvider;

export const useConfig = () => useContext<ConfigCtxValue>(ConfigCtx as Context<ConfigCtxValue>);