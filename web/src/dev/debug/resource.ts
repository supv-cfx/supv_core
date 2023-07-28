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
