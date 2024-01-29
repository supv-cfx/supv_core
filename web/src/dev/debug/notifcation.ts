import { debugData } from "../../utils/debugData";
import type { NotificationProps } from "../../typings/Notification";

export const debugNotification = async () => {
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        id: '1',
        title: 'Transaction',
        description: 'On souhaite vous donnez 5 pains',
        type: 'action',
        duration: 3000,
        icon: 'hand-holding-hand',
        iconStyle: {
          animation: 'shake',
          color: 'rgba(187, 155, 26, 0.74)',
        }
      } as NotificationProps,
    }
  ]);

  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'Transaction',
        description: 'On souhaite vous donnez 5 pains',
        type: 'loading',
        duration: 4500,
      } as NotificationProps,
    }
  ]);
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'Transaction',
        description: 'On souhaite vous donnez 5 pains',
        type: 'loading',
        iconStyle: {
          animation: 'dots'
        },
        duration: 4500,
      } as NotificationProps,
    }
  ]);
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'Transaction',
        description: 'On souhaite vous donnez 5 pains',
        type: 'loading',
        iconStyle: {
          animation: 'bars'
        },
        duration: 4500,
      } as NotificationProps,
    }
  ]);

  await new Promise(resolve => setTimeout(resolve, 1000));
  /*debugData([
    {
      action: 'supv:notification:send',
      data: {
        //id: '1',
        title: 'Salaire',
        description: 'Vous avez reçu 1000$',
        //type: 'action',
        position: 'top-right',
        color: 'rgba(26, 187, 53, 0.74)',
        iconAnim: 'shake',
        icon: 'money-bill',
      } as NotificationProps,
    }
  ]);

  debugData([
    {
      action: 'supv:notification:send',
      data: {
        //id: '1',
        title: 'Salaire',
        description: 'VqSDqDqSDssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssw',
        //type: 'action',
        position: 'top-right',
        color: 'rgba(26, 187, 53, 0.74)',
        iconAnim: 'shake',
        icon: 'money-bill',
      } as NotificationProps,
    }
  ]);*/

  debugData([
    {
      action: 'supv:notification:send',
      data: {
        id: '1',
        //title: 'Whereas recognition of the inherent dignity',
        description: 'action 2',
        type: 'action',
        position: 'top-right',
        //duration: 5000,
        //progress: true,
        //closable: true,
      } as NotificationProps,
    }
  ]);
  await new Promise(resolve => setTimeout(resolve, 1000));
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        id: '2',
        title: 'Whereas recognition of the inherent dignity',
        description: '~r~Notification~r~ ~p~description~p~\nwith new line',
        type: 'success',
        position: 'top-right',
        duration: 2000,
        //progress: true,
        //closable: true,
      } as NotificationProps,
    }
  ]);
  await new Promise(resolve => setTimeout(resolve, 100));
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'Title {badge:omagad x):?:?:?:?}',
        description: '100000',
        type: 'success',
        //position: 'top-right',
        duration: 10000,
        image: 'https://avatars.githubusercontent.com/u/31973315?v=4',
        //progress: true,
        //closable: true,
      } as NotificationProps,
    }
  ]);
  await new Promise(resolve => setTimeout(resolve, 100));
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'Whereas recognition of {badge:phone 0666-2555)}',
        description: '3000\nwith new line',
        type: 'success',
        //position: 'top-right',
        duration: 3000,
        //progress: true,
        //closable: true,
      } as NotificationProps,
    }
  ]);
  await new Promise(resolve => setTimeout(resolve, 100));
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'Une erreur ma gueule',
        description: '- je suis un bg\n- **wéwé ma gueule**',
        type: 'error',
        duration: 15000,
      } as NotificationProps,
    }
  ]);
  await new Promise(resolve => setTimeout(resolve, 100));
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'Whereas recognition of the inherent dignity',
        description: '~r~Notification~r~ ~p~description~p~\nwith new line',
        type: 'success',
        //position: 'top-right',
        duration: 5000,
        //progress: true,
        //closable: true,
      } as NotificationProps,
    }
  ]);
  /*
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
        ~r~Markdown~r~
`,
        //type: 'loading',
        //position: 'bottom-right',
        //duration: 5000,
        //progress: true,
        iconAnim: 'fade',
        icon: 'code',
        closable: true,
      } as NotificationProps,
    }
  ]);*/
} // screwdriver-wrench