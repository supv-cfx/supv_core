import { debugData } from "../../utils/debugData";

export const debugAction = async (value: boolean) => {
  console.log(value);
	debugData([
		{
			action: value === true ? "supv_core:action:send" : "supv_core:action:hide",
			data: value === true ? {
        title: "Appuyez pour intéragir!",
        description: "Ouvrir vestiaire",
        title2: 'Ouvrir',
        description2: 'la porte',
        keybind2: 'H',
			} : null,
		},
	]);
};