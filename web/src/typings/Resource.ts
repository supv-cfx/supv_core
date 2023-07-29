export interface _BooleanSwitchProps {
	inputKey: string;
	label: string;
	description?: string;
	currentValue: boolean;
	resource: string;
	file: string;
	navKey: string;
	index: number;
	setResourceData: (
		resourceName: string,
		file: string,
		value: any,
		navKey: string,
		index: number
	) => void;
}

export interface _ButtonEditorProps {
	inputKey: string;
	value?: any;
	resource: string;
	file: string;
	isDisabled: boolean;
	setIsDisabled: (value: boolean) => void;
	navKey: string;
	index: number;
	setResourceData: (
		resourceName: string,
		file: string,
		value: any,
		navKey: string,
		index: number
	) => void;
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
	navKey: string;
	index: number;
	setResourceData: (
		resourceName: string,
		file: string,
		value: any,
		navKey: string,
		index: number
	) => void;
}

export interface _BadgeEditorProps {
	inputKey: string;
	label: string;
	description?: string;
	placeholder?: string;
	defaultValue?: Array<string>;
	resource: string;
	file: string;
	navKey: string;
	index: number;
	setResourceData: (
		resourceName: string,
		file: string,
		value: any,
		navKey: string,
		index: number
	) => void;
}

export interface _ArraySwitchEditorProps {
	inputKey: string;
	label: string;
	description: string;
	currentValue: Array<boolean>;
	resource: string;
	file: string;
	navKey: string;
	groupLabel: string[];
	index: number;
	setResourceData: (
		resource: string,
		file: string,
		value: string[],
		navKey: string,
		index: number
	) => void;
}

export interface _ObjectSwitchEditorProps {
	inputKey: string;
	label: string;
	description: string;
	currentValue: Record<string, boolean>;
	resource: string;
	file: string;
	navKey: string;
	//groupLabel: string[];
	index: number;
	setResourceData: (
		resource: string,
		file: string,
		value: string[],
		navKey: string,
		index: number
	) => void;
}

export interface _ObjectInputEditorProps {
	inputKey: string;
	label?: string;
	description?: Record<string, string>;
	currentValue: Record<string, string>;
	resource: string;
	file: string;
	navKey: string;
	placeHolders?: Record<string, string>;
	index: number;
	setResourceData: (
		resource: string,
		file: string,
		value: string[],
		navKey: string,
		index: number
	) => void;
}