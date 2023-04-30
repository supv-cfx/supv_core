import React from 'react';
import { toast, Toaster } from 'react-hot-toast';
import ReactMarkdown from 'react-markdown';
import { Transition, createStyles, Notification} from '@mantine/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import type { NotificationProps } from '../../typings/Notification';
import { fetchNui } from '../../utils/fetchNui';

const useStyles = createStyles((theme) => ({
    container: {
        width: 'fit-content',
        maxWidth: 300,
        height: 'fit-content',
        backgroundColor: theme.colors.dark[4],
        fontFamily: 'Ubuntu',
    },
    title: {
        fontWeight: 500,
        lineHeight: 'normal',
        color: theme.colors.gray[6],
    },
    description: {
        fontSize: 12,
        color: theme.colors.gray[4],
        fontFamily: 'Ubuntu',
        lineHeight: 'normal',
    },
    descriptionOnly: {
        fontSize: 14,
        color: theme.colors.gray[2],
        fontFamily: 'Ubuntu',
        lineHeight: 'normal',
    },
}));

const Notifications: React.FC = () => {
    const { classes } = useStyles();

    const onRemoveQueue = () => {
        fetchNui('supv:notification:removeQueue');
    }

    useNuiEvent<NotificationProps>('supv:notification:send', (data) => {
        if (!data.title && !data.description) return;
        let position = data.position;

        if (!data.icon && data.type !== 'loading' && data.type) {
            data.icon = data.type === 'error' ? 'xmark' : data.type === 'success' ? 'check' : data.type === 'warning' ? 'exclamation' :  'info';
        }

        let description: string = data.description ? data.description.replace('\n', '  \n  ') : '';
            //supv:notificiation:onRemove

        const Notify = (data: NotificationProps) => {
            if (data.type !== 'loading') {
                toast.custom(
                    (t) => (
                        <Transition transition='slide-left' duration={800} mounted={t.visible} timingFunction='ease'>
                            {(styles) => (
                                <Notification {...data.icon ? {icon: <FontAwesomeIcon icon={data.icon} />} : undefined}
                                    title={data.title} radius='md' withCloseButton={data.closable || false} onClose={() => {data.closable && toast.dismiss(t.id) }} color={!data.icon ? 'dark' : data.type === 'error' ? 'red' : data.type === 'success' ? 'teal' : data.type === 'warning' ? 'orange' : 'blue'} sx={{mt: 'md'}} className={`${classes.container}`} style={{...styles}}>
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
                        <Transition transition='slide-left' duration={1000} mounted={t.visible} timingFunction='ease' onExit={onRemoveQueue}>
                            {(styles) => (
                                <Notification loading
                                    title={data.title} radius='md' withCloseButton={data.closable || false} onClose={() => {data.closable && toast.dismiss(t.id); onRemoveQueue()}} color={!data.color ? 'dark' : data.color} sx={{mt: 'md'}} className={`${classes.container}`} style={{...styles}}>
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