import { debugData } from "../../utils/debugData";
import type { NotificationProps } from "../../typings/Notification";

export const debugNotification = () => {
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        id: '1',
        //title: 'Whereas recognition of the inherent dignity',
        description: 'Notif',
        type: 'warning',
        position: 'top-right',
        //duration: 5000,
        //progress: true,
        //closable: true,
      } as NotificationProps,
    }
  ]);
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        id: '2',
        title: 'Whereas recognition of the inherent dignity',
        description: 'Notification description\nwith new line',
        type: 'success',
        position: 'top-right',
        //duration: 5000,
        //progress: true,
        //closable: true,
      } as NotificationProps,
    }
  ]);
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        //title: 'Whereas recognition of the inherent dignity',
        description: 'Notification description\nwith new line',
        type: 'error',
        position: 'top-right',
        //duration: 5000,
        //progress: true,
        //closable: true,
      } as NotificationProps,
    }
  ]);
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        //title: 'Whereas recognition of the inherent dignity',
        description: 'Celle-ci je peux la fermer',
        type: 'info',
        position: 'top-right',
        //duration: 5000,
        //progress: true,
        closable: true,
      } as NotificationProps,
    }
  ]);
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'Une notification avec un titre type loading',
        //description: 'Loading',
        type: 'loading',
        position: 'top-right',
        //duration: 5000,
        //progress: true,
        closable: true,
      } as NotificationProps,
    }
  ]);
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'Une notification avec un titre sans type',
        //description: 'Loading',
        //type: 'loading',
        position: 'top-right',
        //duration: 5000,
        //progress: true,
        closable: true,
      } as NotificationProps,
    }
  ]);
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'Une notification avec un titre avec icon sans type',
        //description: 'Loading',
        //type: 'loading',
        //position: 'bottom-right',
        //duration: 5000,
        //progress: true,
        iconAnim: 'fade',
        icon: 'x-ray',
        closable: true,
      } as NotificationProps,
    }
  ]);
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'Un bloc de code',
        //description: "```lua\nfunction(data)\n\tprint(data)\nend\n```",

        //type: 'loading',
        //position: 'bottom-right',
        //duration: 5000,
        //progress: true,
        color: 'dark.4',
        iconAnim: 'beat',
        icon: 'code',
      } as NotificationProps,
    }
  ]);
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'MarkDown',
        description: `
~~~ts
export interface NotificationProps {
  title?: string;
  id?: number | string;
  description?: string; 
  type?: string; 
  duration?: number; // default: 3000
  icon?: IconProp; // default: check on type
  position?: ToastPosition; // default: top-right
  color?: string; // default: check on type
  closable?: boolean; // default: false (not semi-implementation)
  border?: boolean; // default: false (not semi-implementation)
  iconAnim: string; // default: false
}
~~~
`,
        //type: 'loading',
        //position: 'bottom-right',
        //duration: 5000,
        //progress: true,
        iconAnim: 'fade',
        icon: 'code',
        closable: true,
        style: {
          maxWidth: 1920,
          backgroundColor: 'rgba(0,0,0,0.25)',
        }
      } as NotificationProps,
    }
  ]);
} // screwdriver-wrench