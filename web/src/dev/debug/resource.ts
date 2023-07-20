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
						type: "input",
						label: "Input Field4",
						required: true,
						callback: true,
						error: "Message perso",
					},
					{
						type: "text",
						label: "Text Field3",
						required: true,
						callback: true,
						error: "Message perso",
					},
				],
				popo: [
					{
						type: "input",
						label: "Input Field4",
						required: true,
						callback: true,
						error: "Message perso",
					},
					{
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
						type: "input",
						label: "Input Field1",
						required: true,
						callback: true,
						error: "Message perso",
					},
					{
						type: "text",
						label: "Text Field2",
						required: true,
						callback: true,
						error: "Message perso",
					},
					{
						type: "text",
						label: "Text Field2",
						required: true,
						callback: true,
						error: "Message perso",
					},
					{
						type: "text",
						label: "Text Field2",
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
      description: 'Description of the resource',
		},

		config: {
			server: {
				test: [
					{
						type: "input",
						label: "Input Field",
						required: true,
						callback: true,
						error: "Message perso",
					},
					{
						type: "text",
						label: "Text Field",
						required: true,
						callback: true,
						error: "Message perso",
					},
				],
			},

			client: {
				test: [
					{
						type: "input",
						label: "Input Field",
						required: true,
						callback: true,
						error: "Message perso",
					},
					{
						type: "text",
						label: "Text Field",
						required: true,
						callback: true,
						error: "Message perso",
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
