local p

---@class BillingProps
---@field type string<'normal' | 'custom' | 'amende' | 'item_service'>
---@field title? string
---@field options? string[]
---@field price? number
---@field description? string
---@field canRemise? boolean
---@field remise? {min: number, max: number}
---@field amendesOptions? table<string, {label: string, amount: number, id: string}>
---@field articlesOptions? table<string, {label: string, amount: number, id: string}>
---@field nom? string
---@field prenom? string
---@field entreprise? string

---@param data BillingProps
function supv.openBilling(data)
    if p then return end

    if not data.type then
        return print('^1[ERROR]^7 Billing type is required.')
    end

    supv.sendReactMessage(true, {
        action = 'supv_core:billing:open',
        data = data
    })

    p = promise.new()
    return supv.await(p)
end

---@class ReturnBillingProps
---@field type string<'normal' | 'custom' | 'amende' | 'item_service'>
---@field amount number
---@field price number (' But not required, amount is total price of the billing (with service & remise if exist)')
---@field articles? table<string, any>
---@field remise? number
---@field nom? string
---@field prenom? string
---@field entreprise? string

---@param data ReturnBillingProps
---@param cb fun(...: any): void
supv.registerReactCallback('supv_core:billing:send', function(data, cb)
    cb(1)
    if p then p:resolve(data) end p = nil
end, true)

--[[
interface BillingDataProps {
	type?: string;
	title?: string;
	options?: any;
	price?: number;
	description?: string;
	canRemise?: boolean;
	remise?: { min: number; max: number };
	amendesOptions?: any;
	articlesOptions?: any;
  nom?: string;
  prenom?: string;
  entreprise?: string;
}

interface DataProps {
	type?: string;
	[key: string]: any | undefined;
	amount?: number;
	metadata?: any;
	clientType?: string;
  nom?: string;
  prenom?: string;
  entreprise?: string;
}

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
]]

