import { debugData } from '../../../utils/debugData';
import type { ModalPropsCustom/*, Option */} from '../../../typings';
const modalOptions = [
  { type: 'input', label: 'Nom', required: true, default: 'Test', callback: true},
  { type: 'input', label: 'Prénom', required: true, default: 'Test2', callback: true},
  { type: 'select', label: 'Sexe', options: [{value: 'homme', label: 'Homme'}, {value: 'femme', label: 'Femme'}], required: true, default: 'homme', callback: true},
  { type: 'number', label: 'Age', required: true, default: 10, callback: true },
  { type: 'select', label: 'Ville', required: true, options: [{value: 'paris', label: 'Paris'}, {value: 'lyon', label: 'Lyon'}], default: 'lyon', callback: true },
  { type: 'number', label: 'Argent', required: true, default: 10000000, format: {}, callback: true},
  { type: 'multiselect', label: 'Multiselector', required: true, options: [{value: 'paris', label: 'Paris'}, {value: 'lyon', label: 'Lyon'}], default: ['lyon'], callback: true },
  
  /*{ type: 'input', label: 'Input Field', required: true, callback: true, error: 'Message perso', default: 'test' },
  { type: 'number', label: 'Textarea Field', required: true, callback: true, default: 10 },
  { type: 'select', label: 'Select Field', options: 
  [
    { value: 'react', label: 'React' },
    { value: 'ng', label: 'Angular' },
    { value: 'svelte', label: 'Svelte' },
    { value: 'vue', label: 'Vue' }
  ], required: true, error: 'Select an option', callback: true, default: 'ng' },
  /*{
    type: 'checkbox',
    label: 'Checkbox Field',
    callback: true,
  },
  {
    type: 'password',
    label: 'Password Field',
    required: true,
  },
  /*{
    type: 'slider',
    label: 'Slider Field',
    /*min: 120,
    max: 240,
    default: 180,*/
    /*transition: {
      name: 'skew-up',
      duration: 100,
      timingFunction: 'ease-in-out'
    }
  },
  {
    type: 'date',
    label: 'Date Input Field',
    required: true
  },*/

];

export const debugModalsCustom = () => {
  debugData([
    {
      action: 'supv:modal:opened-custom',
      data: {
        title: 'Title of the modal',
        useCallback: true,
        //canCancel: false,
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
