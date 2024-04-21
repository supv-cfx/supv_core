import { debugData } from "../../utils/debugData";


// Selection / Custom
const AmendesOptions = {
  options: [
    { label: "Amende 1", value: 'amende_1'},
    { label: "Amende 2", value: 'amende_2'},
    { label: "Amende 3", value: 'amende_3'},
    { label: 'Custom', value: 'custom'}
  ],
  filter: { // [value] is important to match the options, so "id" is the same as "value"
    amende_1: {label: "Amende 1", amount: 100, id: 'amende_1'},
    amende_2: {label: "Amende 2", amount: 200, id: 'amende_2'},
    amende_3: {label: "Amende 3", amount: 300, id: 'amende_3'},
  }
};

// Multi Slection
const ItemActions = {
  options: [
    { label: "Pain", value: 'bread'},
    { label: "Milk", value: 'milk'},
    { label: "Eggs", value: 'eggs'},
    { label: 'Burger', value: 'burger'},
    { label: 'Pizza', value: 'pizza' }
  ],
  filter: {
    bread: {label: "Pain", amount: 100, id: 'bread'},
    milk: {label: "Milk", amount: 200, id: 'milk'},
    eggs: {label: "Eggs", amount: 300, id: 'eggs'},
    burger: {label: "Burger", amount: 400, id: 'burger'},
    pizza: {label: "Pizza", amount: 500, id: 'pizza'}
  }
}

const BuildBilling = {
  amende: {
    type: "amende",
    options: AmendesOptions.options,
    amendesOptions: AmendesOptions.filter,
    articlesOptions: AmendesOptions.filter,
    canRemise: false,
    nom: "Zoulette",
    prenom: "Yoyo"
    //remise: { min: 1, max: 10 }
  },
  custom: {
    type: "custom",
    options: ItemActions.options,
    amendesOptions: ItemActions.filter,
    articlesOptions: ItemActions.filter,
    canRemise: true,
    remise: { min: 1, max: 10 }
  },
  normal: {
    type: "normal",
    canRemise: true,
    remise: { min: 1, max: 10 }
  },
  item_service: {
    type: "item_service",
    options: ItemActions.options,
    articlesOptions: ItemActions.filter,
    canRemise: true,
    remise: { min: 1, max: 10 }
  }
}


export const debugBilling = async (value: string) => {
	debugData([
		{
			action: "supv_core:billing:open",
			data: BuildBilling[value as keyof typeof BuildBilling],
		},
	]);
};