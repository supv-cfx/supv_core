import React, { useState, useEffect } from 'react';
import { Modal, Stack, Group } from '@mantine/core';
import { CheckboxField, InputField, PasswordField, DateInputField, SliderField, SelectField } from '../components/custom';
import { faCheck, faXmark } from '@fortawesome/free-solid-svg-icons';
import AnimatedButton from '../components/buttons';
import { fetchNui } from '../../../utils/fetchNui';

interface Option {
  type: string;
  label: string;
  description?: string;
  required?: boolean;
  default?: string | boolean | Date | number | Array<any>;
  format?: string;
  icon?: string | string[];
  placeholder?: string;
  max?: number;
  min?: number;
  step?: number;
  data?: Data;
}

interface ModalPropsCustom {
  title?: string;
  options: Option[];
  handleClose: () => void;
  open: boolean;
}

interface RenderedProps {
  index: number;
  field: Option;
}

export const OpenModalCustom: React.FC<ModalPropsCustom> = ({
  title,
  options,
  handleClose,
  open,
}) => {
  const [formData, setFormData] = useState<Record<number, string | boolean | number | Array<any>>>(
    {}
  );
  const [areRequiredFieldsCompleted, setRequiredFieldsCompleted] =
    useState(true);

  const handleInputChange = (index: number, value: boolean | string | number) => {
    setFormData((prevData) => {
      const updatedData = { ...prevData };
      updatedData[index] = value;
      return updatedData;
    });
  };

  const handleSubmit = async (type: any) => {
    handleClose();
    type = type ? formData : setFormData({});
    await new Promise((resolve) => setTimeout(resolve, 200));
    fetchNui('supv:modal:closedCustom', type || false, setFormData({}));
  };

  const renderField = (field: Option, index: number) => {
    switch (field.type) {
      case 'input':
        return (
          <InputField
            key={String(index)}
            index={index}
            label={field.label}
            data={field as Data}
            onChanged={handleInputChange}
          />
        );
      case 'checkbox':
        return (
          <CheckboxField
            key={String(index)}
            index={index}
            label={field.label}
            defaultValue={
              (formData[index] as boolean) ||
              (field.default as boolean) ||
              false
            }
            onChanged={handleInputChange}
          />
        );
      case 'password':
        return (
          <PasswordField
            key={String(index)}
            index={index}   
            label={field.label}
            data={field as Data}
            onChanged={handleInputChange}
          />
        );
      case 'date-input':
        return (
          <DateInputField
            key={String(index)}
            index={index}
            label={field.label}
            data={field as Data}
            onChanged={handleInputChange}
          />
        );
      case 'slider':
        return (
          <SliderField
            key={String(index)}
            index={index}
            label={field.label}
            defaultValue={field.default as number}
            min={field.min}
            max={field.max}
            step={field.step}
            onChanged={handleInputChange}
          />
        );
      case 'select':
        return (
          <SelectField
            key={String(index)}
            index={index}
            label={field.label}
            data={field.data as Data}
            onChanged={handleInputChange}
          />
        );
      default:
        return null;
    }
  };

  const renderedFields: RenderedProps[] = options.map(
    (field: Option, index: number) => ({
      index,
      field,
    })
  );

  useEffect(() => {
    const requiredFields = renderedFields
      .filter(({ field }) => field.required)
      .map(({ index }) => index);
    const areAllRequiredFieldsCompleted = requiredFields.every((index) => {
      const fieldData = formData[index];
      return typeof fieldData !== 'undefined' && fieldData !== '';
    });
    setRequiredFieldsCompleted(areAllRequiredFieldsCompleted);
  }, [formData, renderedFields]);

  return (
    <>
        <Modal
          opened={open}
          size='xs'
          onClose={handleClose}
          withCloseButton={false}
          centered
          withOverlay={false}
          //fullScreen
          styles={{title: {width: '500px', display: 'flex', justifyContent: 'center' }}}
          title={title}
          transitionProps={{
            transition: 'scale-y',
            duration: 250,
            keepMounted: true,
            timingFunction: 'ease-in-out',
          }}
        >
          <Stack style={{height: 'auto', width: 'auto', display: 'flex', justifyContent: 'center' }}>
            {renderedFields.map(({ field, index }) => renderField(field, index))}
            <Group position='center'>
              <AnimatedButton
                iconAwesome={faXmark}
                text='Annuler'
                onClick={() => handleSubmit(false)}
                color='red.6'
                args={false}
              />
              <AnimatedButton
                iconAwesome={faCheck}
                text='Valider'
                onClick={() => handleSubmit(true)}
                color='teal.6'
                args={true}
                isDisabled={!areRequiredFieldsCompleted}
              />
            </Group>
          </Stack>
        </Modal>
    </>
  );
};

/*
local modals = supv.openModals({
    type = 'custom',
    title = 'Custom modal',
    options = {
        {type = 'input', label = 'Text input', description = 'Some input description', required = true, min = 4, max = 16},
        {type = 'number', label = 'Number input', description = 'Some number description', icon = 'hashtag'},
        {type = 'checkbox', label = 'Simple checkbox'},
        {type = 'color', label = 'Colour input', default = '#eb4034'},
        {type = 'date', label = 'Date input', icon = {'far', 'calendar'}, default = true, format = "DD/MM/YYYY"}
    }
})

print(json.encode(modals))
*/
