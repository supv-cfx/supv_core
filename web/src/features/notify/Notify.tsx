import React, { useState, useEffect, useCallback } from 'react';
import { toast, Toaster } from 'react-hot-toast';
import ReactMarkdown from 'react-markdown';
import { createStyles, Notification, keyframes, Loader } from '@mantine/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import type { NotificationProps } from '../../typings/Notification';
//import { fetchNui } from '../../utils/fetchNui';
import { useConfig } from '../../providers/ConfigProvider';
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter';
import { materialDark } from 'react-syntax-highlighter/dist/esm/styles/prism';

const enterAnimationTop = keyframes({
  from: {
    opacity: 0,
    transform: 'translateY(-30px)',
  },
  to: {
    opacity: 1,
    transform: 'translateY(0px)',
  },
});

const enterAnimationBottom = keyframes({
  from: {
    opacity: 0,
    transform: 'translateY(30px)',
  },
  to: {
    opacity: 1,
    transform: 'translateY(0px)',
  },
});

const exitAnimationTop = keyframes({
  from: {
    opacity: 1,
    transform: 'translateY(0px)',
  },
  to: {
    opacity: 0,
    transform: 'translateY(-100%)',
  },
});

const exitAnimationRight = keyframes({
  from: {
    opacity: 1,
    transform: 'translateX(0px)',
  },
  to: {
    opacity: 0,
    transform: 'translateX(100%)',
  },
});

const exitAnimationLeft = keyframes({
  from: {
    opacity: 1,
    transform: 'translateX(0px)',
  },
  to: {
    opacity: 0,
    transform: 'translateX(-100%)',
  },
});

const exitAnimationBottom = keyframes({
  from: {
    opacity: 1,
    transform: 'translateY(0px)',
  },
  to: {
    opacity: 0,
    transform: 'translateY(100%)',
  },
});


const slideInEllipticTopFwd = keyframes({
  from: {
    transform: 'translateY(-600px) rotateX(-30deg) scale(0)',
    transformOrigin: '50% 100%',
    opacity: 0,
  },
  to: {
    transform: 'translateY(0) rotateX(0) scale(1)',
    transformOrigin: '50% 1400px',
    opacity: 1,
  },
});

const slideOutEllipticTopBck = keyframes({
  from: {
    transform: 'translateY(0) rotateX(0) scale(1)',
    transformOrigin: '50% 1400px',
    opacity: 1,
  },
  to: {
    transform: 'translateY(-600px) rotateX(-30deg) scale(0)',
    transformOrigin: '50% 100%',
    opacity: 0,
  },
});

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
        let position = data.position;
        //position = 'bottom-right'
        if (!data.icon && data.type !== 'loading' && data.type) {
            data.icon = data.type === 'error' ? 'xmark' : data.type === 'success' ? 'check' : data.type === 'warning' ? 'exclamation' : 'info';
        }
        let description: string = data.description?.includes('~~~') ? data.description : data.description ? data.description.replace('\n', '  \n  ') : ''
        
        toast.custom(
            (t) => (
                <Notification withBorder={data.border} loading={data.type === 'loading'} {...data.icon ? { icon: 
                  <FontAwesomeIcon icon={data.icon} beat={iconeAnimation(data.iconAnim)} fade={iconeAnimation(data.iconAnim)}/> } : undefined}
                    title={data.title} radius='md' withCloseButton={data.closable || false} onClose={() => { data.closable && toast.dismiss(t.id)/*; onRemoveQueue() */}} 
                    color={!data.type && !data.color ? 'dark' : data.color ? data.color : data.type === 'error' ? 'red' : data.type === 'success' ? 'teal' : data.type === 'warning' ? 'orange' : data.type === 'loading' ? 'white' : 'blue'} sx={{
                        animation: t.visible
                            ? `${position?.includes('bottom') ? enterAnimationBottom : slideInEllipticTopFwd} 0.5s ease-out forwards`
                            : `${slideOutEllipticTopBck} 0.5s ease-in forwards`,

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
                          }
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