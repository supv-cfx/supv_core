import React from 'react';
import { toast, Toaster } from 'react-hot-toast';
import ReactMarkdown from 'react-markdown';
import { Transition, createStyles, Notification } from '@mantine/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import type { NotificationProps } from '../../typings/Notification';
import { fetchNui } from '../../utils/fetchNui';
import { useConfig } from '../../providers/ConfigProvider';

const scaleY = {
    in: { opacity: 1, transform: 'scaleY(1)' },
    out: { opacity: 0, transform: 'scaleY(0)' },
    common: { transformOrigin: 'top' },
    transitionProperty: 'transform, opacity',
};

const slideDown = { // animation compatible all the way
    in: {
        opacity: 1,
        transform: 'translateY(0)',
        transitionDuration: '0.5s',
    },
    out: {
        opacity: 0,
        transform: 'translateY(-10px)',
        transitionDuration: '0.5s',
    },
    common: {},
    transitionProperty: 'transform, opacity',
};

const pendouillage = { // pendouillage très bien a droite et surtout en bas
    in: {
        opacity: 1,
        transform: 'rotate(0deg) translateY(0)',
        transitionTimingFunction: 'cubic-bezier(0.18, 0.89, 0.32, 1.28)',
    },
    out: {
        opacity: 0,
        transform: 'rotate(-90deg) translateY(-10px)',
        transitionTimingFunction: 'cubic-bezier(0.6, -0.28, 0.74, 0.05)',
    },
    common: {
        transformOrigin: 'top right',
    },
    transitionProperty: 'transform, opacity',
};

const toastTransition = {
    in: {
        opacity: 1,
        transform: 'scale(1)',
        transitionDuration: '1.0s',
    },
    out: {
        opacity: 0,
        transform: 'scale(0)',
        transitionDuration: '1.0s',
    },
    common: {
    },
    transitionProperty: 'transform, opacity',
};

const Notifications: React.FC = () => {

    const { config } = useConfig();

    const useStyles = createStyles((theme) => ({
        ...config.notificationStyles
    }));

    const { classes } = useStyles();

    const onRemoveQueue = async () => {
        await new Promise((resolve) => setTimeout(resolve, 200));
        fetchNui('supv:notification:removeQueue');
    }

    useNuiEvent<NotificationProps>('supv:notification:send', (data) => {
        if (!data.title && !data.description) return;
        let position = data.position;
        //position = 'bottom-right'
        if (!data.icon && data.type !== 'loading' && data.type) {
            data.icon = data.type === 'error' ? 'xmark' : data.type === 'success' ? 'check' : data.type === 'warning' ? 'exclamation' : 'info';
        }
        let description: string = data.description ? data.description.replace('\n', '  \n  ') : '';

        const Notify = (data: NotificationProps) => {
            if (data.type !== 'loading') {
                toast.custom(
                    (t) => (
                        <Transition transition={scaleY} mounted={t.visible} timingFunction='ease-in-out' onExit={() => onRemoveQueue()}>
                            {(styles) => (
                                <Notification {...data.icon ? { icon: <FontAwesomeIcon icon={data.icon} /> } : undefined}
                                    title={data.title} radius='md' withCloseButton={data.closable || false} onClose={() => { data.closable && toast.dismiss(t.id); onRemoveQueue() }} color={!data.icon ? 'dark' : data.type === 'error' ? 'red' : data.type === 'success' ? 'teal' : data.type === 'warning' ? 'orange' : 'blue'} sx={{ mt: 'md' }} className={`${classes.container}`} style={{ ...styles }}>
                                    {data.description && (
                                        <ReactMarkdown className={!data.title ? `${classes.descriptionOnly}` : `${classes.description}`}>
                                            {description}
                                        </ReactMarkdown>
                                    )}
                                </Notification>
                            )}
                        </Transition>
                    ),
                    {
                        id: data.id?.toString(),
                        duration: data.duration || 3000,
                        position: position || 'top-right',
                    }
                );
            } else {
                toast.custom(
                    (t) => (
                        <Transition transition={scaleY} mounted={t.visible} timingFunction='ease-in-out' onExit={() => onRemoveQueue()}>
                            {(styles) => (
                                <Notification loading
                                    title={data.title} radius='md' withCloseButton={data.closable || false} onClose={() => { data.closable && toast.dismiss(t.id); onRemoveQueue() }} color={!data.color ? 'dark' : data.color} sx={{ mt: 'md' }} className={`${classes.container}`} style={{ ...styles }}>
                                    {data.description && (
                                        <ReactMarkdown className={!data.title ? `${classes.descriptionOnly}` : `${classes.description}`}>
                                            {description}
                                        </ReactMarkdown>
                                    )}
                                </Notification>
                            )}
                        </Transition>
                    ),
                    {
                        id: data.id?.toString(),
                        duration: data.duration || 3000,
                        position: position || 'top-right',
                    }
                );
            }
        }

        Notify(data);
    });

    return <Toaster />;
};

export default Notifications;