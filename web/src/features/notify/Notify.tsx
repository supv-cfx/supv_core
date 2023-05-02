import React from 'react';
import { toast, Toaster } from 'react-hot-toast';
import ReactMarkdown from 'react-markdown';
import { createStyles, Notification, keyframes } from '@mantine/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import type { NotificationProps } from '../../typings/Notification';
//import { fetchNui } from '../../utils/fetchNui';
import { useConfig } from '../../providers/ConfigProvider';
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter';
import { materialDark } from 'react-syntax-highlighter/dist/esm/styles/prism';
import {SelectAnime} from '../../animation/notifications';
import { renderToString } from 'react-dom/server';

function formatText(text: string) {
  const parts = text.split(/(~r~|~o~|~y~|~g~|~b~|~p~)/);
  return (
    <>
      {parts.map((part, index) => {
        switch (part) {
          case "~r~":
            return <span key={index} style={{ color: "red" }} />;
          case "~o~":
            return <span key={index} style={{ color: "orange" }} />;
          case "~y~":
            return <span key={index} style={{ color: "yellow" }} />;
          case "~g~":
            return <span key={index} style={{ color: "green" }} />;
          case "~b~":
            return <span key={index} style={{ color: "blue" }} />;
          case "~p~":
            return <br key={index} />;
          default:
            return <span key={index}>{part}</span>;
        }
      })}
    </>
  );
}



const Notifications: React.FC = () => {

    const { config } = useConfig();

    const useStyles = createStyles((theme) => ({
        ...config.notificationStyles
    }));

    const { classes } = useStyles();

    /*const onRemoveQueue = async () => {
        await new Promise((resolve) => setTimeout(resolve, 200));
        fetchNui('supv:notification:removeQueue');
    }*/



    const iconeAnimation = (anim: string) => {
      switch (anim) {
        case 'beat':
          return true;
        case 'spin':
          return true;
        case 'fade':
          return true;
        case 'pulse':
          return true;
        case 'shake':
          return true;
        case 'tada':
          return true;
        case 'flip':
          return true;
        default:
          return false;
      }
    }

    useNuiEvent<NotificationProps>('supv:notification:send', (data) => {
        if (!data.title && !data.description) return;
        console.log(data.position)
        let position = !data.position ? config.notificationStyles.container.position : data.position;
        //position = 'bottom-right'
        if (!data.icon && data.type !== 'loading' && data.type) {
            data.icon = data.type === 'error' ? 'xmark' : data.type === 'success' ? 'check' : data.type === 'warning' ? 'exclamation' : 'info';
        }
        let description: string = data.description?.includes('~~~') ? data.description : data.description ? data.description.replace('\n', '  \n  ') : ''

        const {posEnter, posExit} = SelectAnime(data?.animation?.enter, data?.animation?.exit, position?.includes('bottom') ? 'bottom' : 'top', position?.includes('top') ? 'top' : position?.includes('right') ? 'right' : position?.includes('left') ? 'left' : 'right', 'top', undefined);

        toast.custom(
            (t) => (
                <Notification withBorder={data.border} loading={data.type === 'loading'} {...data.icon ? { icon: 
                  <FontAwesomeIcon icon={data.icon} beat={iconeAnimation(data.iconAnim)} fade={iconeAnimation(data.iconAnim)}/> } : undefined}
                    title={data.title} radius='md' withCloseButton={data.closable || false} onClose={() => { data.closable && toast.dismiss(t.id)/*; onRemoveQueue() */}} 
                    color={!data.type && !data.color ? 'dark' : data.color ? data.color : data.type === 'error' ? 'red' : data.type === 'success' ? 'teal' : data.type === 'warning' ? 'orange' : data.type === 'loading' ? 'white' : 'blue'} sx={{
                      animation: t.visible
                          ? `${posEnter} 0.2s ease-out forwards`
                          : `${posExit} 0.9s ease-in forwards`,
                  }} /*onAnimationEnd={() => onRemoveQueue()}*/ className={`${classes.container}`} style={data.style}>
                    {data.description && (
                      <ReactMarkdown
                        children={description}
                        components={{
                          code({node, inline, className, children, ...props}) {
                            const match = /language-(\w+)/.exec(className || '')
                            return !inline && match ? (
                              <SyntaxHighlighter
                                {...props}
                                children={String(children).replace(/\n$/, '')}
                                style={materialDark}
                                language={match[1]}
                                PreTag="div"
                              />
                            ) : (
                              <code {...props} className={className}>
                                {children}
                              </code>
                            )
                          },
                        }}
                      />
                    )}
                </Notification>
            ),
            {
                id: data.id?.toString(),
                duration: data.duration || 3000,
                position: position || 'top-right',
            }
            );
        });

    return <Toaster />;
};

export default Notifications;