import { debugData } from '../../../utils/debugData';
import type { ModalProps } from '../../../typings';
const modalOptions = [
  { type: 'input', name: 'inputField', label: 'Input Field', required: true },
  {
    type: 'checkbox',
    name: 'checkboxField',
    label: 'Checkbox Field',
    checked: true,
  },
  {
    type: 'password',
    name: 'inputField',
    label: 'Input Field',
    required: true,
  },
  {
    type: 'slider',
    name: 'sliderField',
    label: 'Slider Field',
    min: 120,
    max: 240,
    default: 180,
  },
  {
    type: 'date-input',
    label: 'Date Input Field',
  }
];

export const debugModalsCustom = () => {
  debugData([
    {
      action: 'supv:modal:opened',
      data: {
        type: 'custom',
        title: 'Dialog title',
        options: modalOptions,
      } as ModalProps,
    },
  ]);
};
