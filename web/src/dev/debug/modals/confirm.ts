import { debugData } from "../../../utils/debugData";
import type {ModalProps} from "../../../typings";

export const debugModalsConfirm = () => {
  debugData([
    {
      action: 'supv:modal:opened',
      data: {
        type: 'confirm',
        title: 'Dialog title',
        subtitle: 'Markdown',
        description:`
A paragraph with *emphasis* and **strong importance**.
> A block quote with ~strikethrough~ and a URL: https://reactjs.org.

* Lists
* [ ] todo
* [x] done

A table:

| a | b |
| - | - |
        `
        } as ModalProps,
      }
  ]);     
}