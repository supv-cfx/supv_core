import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
//import {VisibilityProvider} from './providers/VisibilityProvider';
import { MantineProvider } from '@mantine/core';

ReactDOM.render(
  <React.StrictMode>
    <MantineProvider theme={{ colorScheme: 'dark' }} withGlobalStyles withNormalizeCSS>
      <App />
    </MantineProvider>  
  </React.StrictMode>,
  document.getElementById('root')
);
