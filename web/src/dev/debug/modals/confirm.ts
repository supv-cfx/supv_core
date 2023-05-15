import { debugData } from "../../../utils/debugData";
import type {ModalProps} from "../../../typings";
const desc = `
A paragraph with *emphasis* and **strong importance**.
> A block quote with ~strikethrough~ and a URL: https://reactjs.org.

* Lists
* [ ] todo
* [x] done

A table:

| a | b |
| - | - |
`;

export const debugModalsConfirm = () => {
  debugData([
    {
      action: 'supv:modal:opened',
      data: {
        type: 'confirm',
        title: 'Dialog title',
        subtitle: 'Markdown',
        //style: {
          //backgroundImage: `linear-gradient(to left bottom, rgba(39,54,102,0.38), rgba(36,51,98,0.38), rgba(34,48,94,0.38), rgba(31,46,90,0.38), rgba(29,43,86,0.//38), rgba(31,40,81,0.38), rgba(32,36,75,0.//38), rgba2,33,70,0.38), rgba(34,29,62,0.38), rgba(34,24,54,0.38), rgba(33,21,46,0.38), rgba(31,17,39,0.38))`,
          //transition: 'all 0.3s ease-in-out',
          //color: '#0FBA81',
          //borderRadius: '5px',
          //boxShadow: '0 0 10px 0 rgba(0,0,0,0.2)',
        //},
        description: desc
        } as ModalProps,
      }
  ]);     
}