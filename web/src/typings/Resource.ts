export interface _BooleanSwitchProps {
	inputKey: string;
	label: string;
	description?: string;
  currentValue: boolean;
  resource: string;
  file: string;
}

export interface _ButtonEditorProps {
  inputKey: string;
  value?: any;
  resource: string;
  file: string;
  isDisabled: boolean;
  setIsDisabled: (value: boolean) => void;
}

export interface _StringEditorProps {
	inputKey: string;
	label: string;
	description?: string;
	placeholder?: string;
	defaultValue?: string;
	currentValue?: string;
	resource: string;
	file: string;
}

export interface _BadgeEditorProps {
	inputKey: string;
	label: string;
	description?: string;
	placeholder?: string;
	defaultValue?: Array<string>;
  resource: string;
  file: string;
}
