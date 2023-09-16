//import { ModalsProviderProps } from './config/modals';
import { MantineTransition } from '@mantine/core';

// Modal Props as cat all option
export interface Option {
  type: string;
  label: string;
  name?: string;
  checked?: boolean;
  description?: string;
  required?: boolean;
  default?: string | boolean | Date | number | Array<any>;
  format?: string;
  icon?: string | string[];
  placeholder?: string;
  max?: number;
  min?: number;
  step?: number;
  data?: any;
  size?: string;
  error?: string;
  callback?: boolean;
  options?: ItemSelectProps[];
  transition?: {name: MantineTransition, duration: number, timingFunction: string};
}

export interface ModalPropsCustom {
  title: string;
  size?: string;
  withOverlay?: boolean;
  options: Option[];
  useCallback?: boolean;
  canCancel?: boolean;
  transition?: {name: MantineTransition, duration: number, timingFunction: string};
}

export interface ModalConfirmProps {
  title?: string;
  description?: string;
  size?: string;
  transition?: {name: MantineTransition, duration: number, timingFunction: string};
  withOverlay?: boolean;
}

// _components

export interface ItemSelectProps {
  Array: {label: string, value: string}[];
}

export interface _SliderProps {
  index: string;
  label?: string;
  defaultValue?: number;
  min?: number;
  max?: number;
  step?: number;
  transition?: {name: MantineTransition, duration: number, timingFunction: string}
  onChanged: (
    index: string,
    value: number,
    isRequired?: boolean,
    callback?: boolean
  ) => void;
  props: any;
}

export interface _SelectProps {
  index: string;
  label?: string;
  data: any;
  options: ItemSelectProps[],
  onChanged: (
    index: string,
    value: string,
    isRequired?: boolean,
    callback?: boolean
  ) => void;
  props: any;
}

export interface _PasswordProps {
  index: string;
  label?: string;
  data?: any;
  onChanged: (
    index: string,
    value: string,
    isRequired?: boolean,
    callback?: boolean
  ) => void;
  props: any;
}

export interface _CheckboxProps {
  index: string;
  label?: string;
  data?: any;
  defaultValue?: boolean;
  onChanged: (
    index: string,
    value: boolean,
    isRequired?: boolean,
    callback?: boolean
  ) => void;
  props: any;
}

export interface _DateInputProps {
  index: string;
  label?: string;
  data?: any;
  onChanged: (
    index: string,
    value: string,
    isRequired?: boolean,
    callback?: boolean
  ) => void;
  props: any;
}

export interface _TextInputProps {
  index: string;
  label?: string;
  data?: any;
  onChanged: (
    index: string,
    value: string,
    isRequired?: boolean,
    callback?: boolean
  ) => void;
  props: any;
}

export interface _NumberInputProps {
  index: string;
  label?: string;
  data?: any;
  onChanged: (
    index: string,
    value: number,
    isRequired?: boolean,
    callback?: boolean
  ) => void;
  props: any;
}