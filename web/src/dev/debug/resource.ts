import { debugData } from "../../utils/debugData";

const options: Object = {
	supv_core: {
		main: {
			restart: true,
			reload: true,
			start: true,
			stop: true,
			description: `Description of the resource MarkDown supported  \neh ouéééé


A paragraph with *emphasis* and **strong importance**.
> A block quote with ~strikethrough~ and a URL: https://reactjs.org.

* Lists
 - [ ] todo
  - - [x] done
      
`,
		},

		config: {
			test: {
				objectCustom: [
					{
						id: "supv_core.hide_something",
						type: "object-custom",
						value: {
							scope_list: {
								WEAPON_HEAVYSNIPER_MK2: true,
								WEAPON_SNIPERRIFLE: true,
								WEAPON_MARKSMANRIFLE: true,
								WEAPON_MARKSMANRIFLE_MK2: true,
								WEAPON_HEAVYSNIPER: true,
							},
							list: [3, 4, 6, 7, 8, 9, 13, 14],
							enable: false,
						},

						data : {
							scope_list: {
								type: "object-switch",
								value: {
									WEAPON_HEAVYSNIPER_MK2: true,
									WEAPON_SNIPERRIFLE: true,
									WEAPON_MARKSMANRIFLE: true,
									WEAPON_MARKSMANRIFLE_MK2: true,
									WEAPON_HEAVYSNIPER: true,
								},
								label: "List of weapon allow hud",
								canAdd: true,
								canRemove: true,
								addDescription: "Add a weapon",
								keyFormat: "uppercase"
							},

							list: {
								type: "array-multi-select",
								value: [3, 4, 6, 7, 8, 9, 13, 14],
								values: [
									{ value: 0, label: "0" },
									{ value: 1, label: "1" },
									{ value: 2, label: "2" },
									{ value: 3, label: "3" },
									{ value: 4, label: "4" },
									{ value: 5, label: "5" },
									{ value: 6, label: "6" },
									{ value: 7, label: "7" },
									{ value: 8, label: "8" },
									{ value: 9, label: "9" },
									{ value: 10, label: "10" },
									{ value: 11, label: "11" },
									{ value: 12, label: "12" },
									{ value: 13, label: "13" },
									{ value: 14, label: "14" },
									{ value: 15, label: "15" }
								],
								canAdd: true,
								canRemove: true
							},

							enable: {
								type: "boolean",
								value: false,
								description: "Enable or disable this feature"
							}
						},
					},
				],
			},
			server: {
				test: [
					{
						id: "supv_core.testInput",
						type: "input",
						label: "Input Field4ss",
						required: true,
						callback: true,
						error: "Message perso",
					},
					{
						id: "supv_core.canSwap",
						type: "boolean",
						label: "Boolean Field",
						value: false,
						default: true,
						description: "Description of the field",
					},
					{
						id: "supv_core.testTable",
						type: "table",
						label: "Table Field",
						description: "Description of the field",
						default: ["adder", "t20", "entityxf", "raptor"],
					},
					{
						id: "supv_core.testText",
						type: "text",
						label: "Text Field3ww",
						required: true,
						callback: true,
						error: "Message perso",
					},
				],
				popo: [
					{
						id: "supv_core.testInputPopo",
						type: "input",
						label: "Input Field4ss",
						required: true,
						callback: true,
						error: "Message perso",
					},
					{
						id: "supv_core.testTextPopo",
						type: "text",
						label: "Text Field3",
						required: true,
						callback: true,
						error: "Message perso",
					},
				],
			},
			client: {
				xd: [
					{
						id: "supv_core.testInputXd",
						type: "input",
						label: "Input Field1ww",
						required: true,
						callback: true,
						error: "Message perso",
					},
					{
						id: "supv_core.testTextXd",
						type: "text",
						label: "Text Field2aa",
						required: true,
						callback: true,
						error: "Message perso",
					},
					{
						id: "supv_core.testTextXd2",
						type: "text",
						label: "Text Fieldtt2",
						required: true,
						callback: true,
						error: "Message perso",
					},
					{
						id: "supv_core.testTextXd3",
						type: "text",
						label: "Text Fieldsds2",
						required: true,
						callback: true,
						error: "Message perso",
					},
				],
			},
		},
	},
	supv_test: {
		main: {
			restart: true,
			reload: true,
			start: true,
			description: "Description of the resource",
		},

		config: {
			server: {
				test: [
					{
						id: "supv_test.testInput",
						type: "input",
						label: "Input Fielqsdd",
						required: true,
						callback: true,
						error: "Message perso",
					},
					{
						id: "supv_test.testText",
						type: "text",
						label: "Text Fielqd",
						required: true,
						callback: true,
						error: "Message perso",
					},
				],
			},

			client: {
				test: [
					{
						id: "supv_test.objectString",
						type: "object-string",
						label: "My list object string",
						description: {
							test1: "TEST 1",
							test2: "TEST 2",
							test3: "TEST 3",
							test4: "TEST 4",
						},
						value: {
							test1: "test",
							test2: "test",
							test3: "test",
							test4: "test",
							test5: "",
						},
					},
					{
						id: "supv_test.objectSwitch",
						type: "object-switch",
						label: "Object Switch",
						value: {
							DT_Invalid: true,
							DT_PoliceAutomobile: true,
							DT_PoliceHelicopter: true,
							DT_FireDepartment: true,
							DT_SwatAutomobile: true,
						},
					},
					{
						id: "supv_test.testInputClient",
						type: "input",
						label: "Input Fieldfd",
						required: true,
						callback: true,
						error: "Message perso",
					},
					{
						id: "supv_test.testTextClient",
						type: "text",
						label: "Text Fielgggd",
						required: true,
						callback: true,
						error: "Message perso",
					},
					{
						id: "supv_test.dispatch",
						type: "array-switch",
						label: "List of dispatch",
						value: [
							true,
							true,
							true,
							true,
							true,
							true,
							true,
							true,
							true,
							true,
							true,
							true,
							true,
							true,
							true,
							true,
						],
						description: "Turn off to desactivate dispatch",
						groupLabel: [
							"DT_Invalid",
							"DT_PoliceAutomobile",
							"DT_PoliceHelicopter",
							"DT_FireDepartment",
							"DT_SwatAutomobile",
							"DT_AmbulanceDepartment",
							"DT_PoliceRiders",
							"DT_PoliceVehicleRequest",
							"DT_PoliceRoadBlock",
							"DT_PoliceAutomobileWaitPulledOver",
							"DT_PoliceAutomobileWaitCruising",
							"DT_Gangs",
							"DT_SwatHelicopter",
							"DT_PoliceBoat",
							"DT_ArmyVehicle",
							"DT_BikerBackup",
						],
					},
				],
			},
		},
	},
};

/*const options: any[] = [
  {
    resource: 'supv_core',

    main: [
      {
        restart: true,
        reload: true,
        start: true,
        stop: true,
      }
    ],
      

    config: {
      server: {
        test: [
          {type: 'input', label: 'Input Field4', required: true, callback: true, error: 'Message perso'},
          {type: 'text', label: 'Text Field3', required: true, callback: true, error: 'Message perso'},
        ],
        popo: [
          {type: 'input', label: 'Input Field4', required: true, callback: true, error: 'Message perso'},
          {type: 'text', label: 'Text Field3', required: true, callback: true, error: 'Message perso'},
        ]
      },
      client: {
        xd: [
          {type: 'input', label: 'Input Field1', required: true, callback: true, error: 'Message perso'},
          {type: 'text', label: 'Text Field2', required: true, callback: true, error: 'Message perso'},
          {type: 'text', label: 'Text Field2', required: true, callback: true, error: 'Message perso'},
          {type: 'text', label: 'Text Field2', required: true, callback: true, error: 'Message perso'},
        ]
      },
    }
  },
  {
    resource: 'supv_test',

    main: [
      {
        restart: true,
        reload: true,
        start: true,
        stop: false,
      }
    ],

    config: {
      server: {
        test: [
          {type: 'input', label: 'Input Field', required: true, callback: true, error: 'Message perso'},
          {type: 'text', label: 'Text Field', required: true, callback: true, error: 'Message perso'},
        ]
      },
    }
  }
]
*/
export const debugResourceManager = () => {
	debugData([
		{
			action: "supv:open:rm",
			data: options as any,
		},
	]);
};
