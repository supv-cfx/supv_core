import React from "react";
import { TextInput, NumberInput, Modal, ActionIcon } from "@mantine/core";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faPlus } from "@fortawesome/free-solid-svg-icons";
import { _CanAddInputEditorProps } from "../../../typings";

export const CanAddInputEditor: React.FC<_CanAddInputEditorProps> = ({
	addOption,
	state,
	value,
	setValue,
}) => {

  const HandleModal = () => {
    return (
      <Modal
        opened={true}
        onClose={() => {

        }}
        title={addOption.description}
      >
        <TextInput
          onKeyDown={(e) => {
            if (e.key === "Enter") {
              if (addOption.in === "object") {
                const newValue = { ...value };
                const currentVal = e.currentTarget.value;
                switch (addOption.keyFormat) {
                  case "lowercase":
                    newValue[currentVal.toLowerCase()] = true;
                    break;
                  case "uppercase":
                    newValue[currentVal.toUpperCase()] = true;
                    break;
                  default:
                    newValue[currentVal] = true;
                    break;
                }
                setValue(newValue);
              }
            }
          }}
          icon={
            <FontAwesomeIcon icon={faPlus} color={!state ? "green" : "gray"} />
          }
          m={10}
          size="xs"
          disabled={state}
          placeholder={addOption.placeholder}
        />
      </Modal>
    )
  }

	return (
		<>
			{addOption.type === "number" ? (
				<NumberInput
					description={addOption.description}
					onKeyDown={(e) => {
						if (e.key === "Enter") {
							if (addOption.in === "object") {
								setValue({ ...value, [e.currentTarget.value]: true });
							} else {
								setValue([...value, e.currentTarget.value]);
							}
						}
					}}
					icon={
						<FontAwesomeIcon icon={faPlus} color={!state ? "green" : "gray"} />
					}
					m={10}
					size="xs"
					disabled={state}
          placeholder={addOption.placeholder}
				/>
			) : addOption.type === 'object' ? (
        <ActionIcon
          onClick={() => {
            HandleModal()
          }}
        >
          <FontAwesomeIcon icon={faPlus} color={!state ? "green" : "gray"} />
        </ActionIcon>
      ) : (
				<TextInput
					description={addOption.description}
					onKeyDown={(e) => {
						if (e.key === "Enter") {
							if (addOption.in === "object") {
								const newValue = { ...value };
								const currentVal = e.currentTarget.value;
								switch (addOption.keyFormat) {
									case "lowercase":
										newValue[currentVal.toLowerCase()] = true;
										break;
									case "uppercase":
										newValue[currentVal.toUpperCase()] = true;
										break;
									default:
										newValue[currentVal] = true;
										break;
								}
								setValue(newValue);
							}
						}
					}}
					icon={
						<FontAwesomeIcon icon={faPlus} color={!state ? "green" : "gray"} />
					}
					m={10}
					size="xs"
					disabled={state}
          placeholder={addOption.placeholder}
				/>
			)}
		</>
	);
};