import React from 'react';
import { toast, Toaster } from 'react-hot-toast';
import ReactMarkdown from 'react-markdown';
import { createStyles, Notification } from '@mantine/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import type { NotificationProps } from '../../typings/Notification';
import { useConfig } from '../../providers/ConfigProvider';
import { SelectAnime } from '../../animation/notifications';
import { iconeAnimation } from '../../animation/icones';
//import { fetchNui } from '../../utils/fetchNui';

/**
 * Notifications - A component for displaying notifications
 * @example `lua`
 * 
 *supv.notify('simple', {
 *    id = 'notification_1',
 *    title = 'Notification title',
 *    description = 'Notification description',
 *    type = 'info',
 *    duration = 5000,
 *    icon = 'circle',
 *    position = 'bottom-right',
 *    color = 'gray',
 *    closable = false,
 *    border = false,
 *    iconAnim = 'beat',
 *    style = { fontSize: '16px', backgroundColor: rgba(255, 255, 255, 0.25) },
 *    animation = {enter = 'slide', exit = 'slideInElliptic'}
 *})
 * @param {string?} data.title - Title of the notification
 * @param {string?} data.description - Description of the notification
 * @param {string?} data.type - Type of the notification
 * @param {string?} data.color - Color of the notification
 * @param {string?} data.icon - Icon of the notification
 * @param {string?} data.iconAnim - Animation of the icon
 * @param {string?} data.position - Position of the notification
 * @param {string?} data.animation - Animation of the notification
 * @param {number?} data.duration - Duration of the notification
 * @param {boolean?} data.closable - Closable of the notification
 * @param {boolean?} data.border - Border of the notification
 * @param {React.CSSProperties?} data.style - Style of the notification
 * @param {string?} data.id - Id of the notification
 * @returns {Toaster} notifications
 * @type {NotificationProps}
*/
const Notifications: React.FC = () => {

  const { config } = useConfig();
  const useStyles = createStyles((theme) => ({...config.notificationStyles}));
  const { classes } = useStyles();

  /*const onRemoveQueue = async () => {
      await new Promise((resolve) => setTimeout(resolve, 200));
      fetchNui('supv:notification:removeQueue');
  };*/

  useNuiEvent<NotificationProps>('supv:notification:send', (data) => {
    if (!data.title && !data.description) return;
    let position = !data.position ? config.notificationStyles.container.position : data.position;
    //position = 'bottom-right' //to test
    if (!data.icon && data.type !== 'loading' && data.type) { data.icon = data.type === 'error' ? 'xmark' : data.type === 'success' ? 'check' : data.type === 'warning' ? 'exclamation' : 'info';};
    let description: string = data.description ? data.description.replace('\n', '  \n  ') : '';

    const { posEnter, posExit } = SelectAnime(data?.animation?.enter, data?.animation?.exit, position?.includes('bottom') ? 'bottom' : 'top', position?.includes('top') ? 'top' : position?.includes('right') ? 'right' : position?.includes('left') ? 'left' : 'right', 'top', undefined);

    toast.custom(
      (t) => (
        <Notification withBorder={data.border} loading={data.type === 'loading'} {...data.icon ? {
          icon:
            <FontAwesomeIcon icon={data.icon} beat={iconeAnimation(data.iconAnim)} fade={iconeAnimation(data.iconAnim)} />
        } : undefined}
          title={data.title} radius='md' withCloseButton={data.closable || false} onClose={() => { data.closable && toast.dismiss(t.id)/*; onRemoveQueue() */ }}
          color={!data.type && !data.color ? 'dark' : data.color ? data.color : data.type === 'error' ? 'red' : data.type === 'success' ? 'teal' : data.type === 'warning' ? 'orange' : data.type === 'loading' ? 'white' : 'blue'} sx={{
            animation: t.visible
              ? `${posEnter} 0.3s ease-out forwards`
              : `${posExit} 0.5s ease-in forwards`,
          }} className={`${classes.container}`} style={data.style}>
          {data.description && (
            <ReactMarkdown>
              {description}
            </ReactMarkdown>
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