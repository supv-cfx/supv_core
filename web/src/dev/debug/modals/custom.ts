import { debugData } from '../../../utils/debugData';
import type { ModalPropsCustom/*, Option */} from '../../../typings';
const modalOptions = [
  { type: 'input', label: 'Input Field', required: true, callback: true, error: 'Message perso' },
  { type: 'select', label: 'Select Field', options: 
  [
    { value: 'react', label: 'React' },
    { value: 'ng', label: 'Angular' },
    { value: 'svelte', label: 'Svelte' },
    { value: 'vue', label: 'Vue' }
  ], required: true, error: 'Select an option', callback: true },
  {
    type: 'checkbox',
    label: 'Checkbox Field',
    callback: true,
  },
  {
    type: 'password',
    label: 'Password Field',
    required: true,
  },
  {
    type: 'slider',
    label: 'Slider Field',
    /*min: 120,
    max: 240,
    default: 180,*/
    transition: {
      name: 'skew-up',
      duration: 100,
      timingFunction: 'ease-in-out'
    }
  },
  {
    type: 'date',
    label: 'Date Input Field',
    required: true
  },
  {
    type: 'number',
    label: 'Number Input Field',
    format: {separator: ',', value: '€'},
  }
];

export const debugModalsCustom = () => {
  debugData([
    {
      action: 'supv:modal:opened-custom',
      data: {
        title: 'Title of the modal',
        useCallback: true,
        canCancel: false,
        transition: {
          name: 'skew-up',
          duration: 200,
          timingFunction: 'ease-in-out'
        },
        //canCancel: false,
        options: modalOptions,
      } as ModalPropsCustom,
    },
  ]);
};
