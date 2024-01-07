import React, { useState, Fragment } from 'react';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { useDisclosure } from '@mantine/hooks';
import { useForm } from '@mantine/form';
//import { useConfig } from '../../providers/ConfigProvider';
import { Stack, Group, Modal, Divider } from '@mantine/core';
import { faCheck, faXmark } from '@fortawesome/free-solid-svg-icons';
import { fetchNui } from "../../utils/fetchNui";
import AnimatedButton from './components/buttons';
import { InputField, SelectField, CheckboxField, DateInputField, PasswordField, SliderField, NumberField, MutltiSlectField, ColorPickerField } from './components/custom';
import type { ModalPropsCustom, Option, _SelectProps, _MultiSelectProps } from '../../typings';

const ModalCustom: React.FC = () => {
  //const { config } = useConfig(); // not used & implemented yet
  //const useStyles = createStyles((theme) => ({...config.modalsStyles}));
  //const { classes } = useStyles();
  const [getData, setData] = useState<ModalPropsCustom>({title: '', options: []});
  const [opened, { close, open }] = useDisclosure(false);
  const form = useForm<{index: {value: any, required: boolean}[]}>({});

  useNuiEvent<ModalPropsCustom>('supv:modal:opened-custom', async (data) => {
    const options = data.options;
    setData(data);
    options.map((field: Option, index: number) => {
      return form.setFieldValue(`${index}`, 
        {
          value :
            field.type === ('input' || 'password' || 'date') ? field.default || '' 
            : field.type === 'checkbox' ? field.checked || false
            : field.type === 'slider' ? field.default || 0
            : field.type === 'number' ? field.default || 0
            : field.type === 'colorpicker' ? field.default || '#000000'
            : field.type === ('select' || 'multiselect') ? field.default || null
            //: field.type === 'multiselect' ? field.default || null
            : null,
          required: field.required || false,
          callback: field.callback || false
        });
    });
    await new Promise((resolve) => setTimeout(resolve, 200));
    open();
  });

  const handleSubmit = form.onSubmit(async (data) => {
    let missing = false;
    const setArray: any[] = [];
    //console.log(JSON.stringify(data));
    Object.values(data).forEach((field: any, index: number) => {
      if (field.required) {
        const val = !field.value ? null : field.value;
        switch (val) {
          case null:
          case typeof val === 'number' && isNaN(val):
          case typeof val === 'boolean' && !val:
          case typeof val === 'string' && val.length <= 1:
            missing = true;
            const err = getData.options[index]?.error || null;
            form.setFieldError(`${index}`, err || 'Ce champ est requis');
            return;
          default: break;
        }
      }
      setArray.push(field.value);
    });
    if (missing) return;
    close();
    await new Promise((resolve) => setTimeout(resolve, 200));
    form.reset();
    fetchNui('supv:modal:submit', setArray, JSON.stringify(setArray));
  });

  const handleChange = (index: string, value: any, isRequired?: boolean, callback?: boolean) => {
    form.setFieldValue(`${index}`, {value, required: isRequired, callback: callback});
    if (callback && getData.useCallback) {
      fetchNui('supv:modal:callback', {index: parseInt(index) + 1, value: value})
    }
  };

  return (
    <>
      <Modal
        opened={opened}
        closeOnClickOutside={false}
        closeOnEscape={false}
        onClose={close}
        centered
        withCloseButton={false}
        styles={{ 
          header: { background: 'linear-gradient(45deg, rgba(7, 18, 39, 0.94) 25%, rgba(8, 25, 56, 0.94) 50%, rgba(14, 44, 100, 0.86) 100%)', },
          title: {fontFamily: 'Yellowtail', textAlign: 'center', width: '100%', fontSize: 20, color: 'white'},
          body: { background: 'rgba(0,0,0,0.5)'},
        }}
        style={{
          background: 'linear-gradient(45deg, rgba(7, 18, 39, 0.94) 25%, rgba(8, 25, 56, 0.94) 50%, rgba(14, 44, 100, 0.86) 100%)',
        }}
        transitionProps={ (getData.transition && {transition: getData.transition.name, duration: getData.transition.duration || 100, timingFunction: getData.transition.timingFunction || 'ease-in-out'}) || undefined}
        title={getData.title}
        size={getData.size || 'xs'}
        withOverlay={getData.withOverlay || false}
      >
        <Divider variant='solid' />
        <Stack>
          <form onSubmit={handleSubmit}>
            {getData.options.map((field: Option, index: number) => {
              return (
                <Fragment key={`${index}`}>
                  {
                    field.type === 'input' && (
                      <InputField
                        index={`${index}`}
                        label={field.label}
                        data={field as any}
                        onChanged={handleChange}
                        props={form.getInputProps(`${index}`)}
                      />
                    )
                  }
                  {
                    field.type === 'select' && (
                      <SelectField
                        index={`${index}`}
                        label={field.label}
                        options={field.options as _SelectProps["options"]}
                        data={field as any}
                        onChanged={handleChange}
                        props={form.getInputProps(`${index}`)}
                      />
                    )
                  }
                  {
                    field.type === 'checkbox' && (
                      <CheckboxField
                        index={`${index}`}
                        label={field.label}
                        data={field as any}
                        defaultValue={field.checked as boolean}
                        onChanged={handleChange}
                        props={form.getInputProps(`${index}`)}
                      />
                    )
                  }
                  {
                    field.type === 'date' && (
                      <DateInputField
                        index={`${index}`}
                        label={field.label}
                        data={field as any}
                        onChanged={handleChange}
                        props={form.getInputProps(`${index}`)}
                      />
                    )
                  }
                  {
                    field.type === 'password' && (
                      <PasswordField
                        index={`${index}`}
                        label={field.label}
                        data={field as any}
                        onChanged={handleChange}
                        props={form.getInputProps(`${index}`)}
                      />
                    )
                  }
                  {
                    field.type === 'slider' && (
                      <SliderField
                        index={`${index}`}
                        label={field.label}
                        defaultValue={field.default as number}
                        min={field.min as number}
                        max={field.max as number}
                        step={field.step as number}
                        transition={field.transition as Option["transition"]}
                        onChanged={handleChange}
                        props={form.getInputProps(`${index}`)}
                      />
                    )
                  }
                  {
                    field.type === 'number' && (
                      <NumberField
                        index={`${index}`}
                        label={field.label}
                        data={field as any}
                        onChanged={handleChange}
                        props={form.getInputProps(`${index}`)}
                      />
                    )
                  }
                  {
                    field.type === 'multiselect' && (
                      <MutltiSlectField
                        index={`${index}`}
                        label={field.label}
                        options={field.options as _MultiSelectProps["options"]}
                        data={field as any}
                        onChanged={handleChange}
                        props={form.getInputProps(`${index}`)}
                      />
                    )
                  }
                  {
                    field.type === 'colorpicker' && (
                      <ColorPickerField
                        index={`${index}`}
                        label={field.label}
                        data={field as any}
                        onChanged={handleChange}
                        props={form.getInputProps(`${index}`)}
                      />
                    )
                  }
                </Fragment>
              );
            })}
            <Group position='center' pt={10}>
              <AnimatedButton
                iconAwesome={faXmark}
                text='Annuler'
                onClick={() => {close(); form.reset(); fetchNui('supv:modal:submit', null)}}
                color='red.6'
                args={false}
                isDisabled={getData?.canCancel === false || undefined}
              />
              <AnimatedButton
                iconAwesome={faCheck}
                text='Valider'
                onClick={() => handleSubmit()}
                color='teal.6'
                args={true}
              />
            </Group>
          </form>
        </Stack>
      </Modal>
    </>
  );
};

export default ModalCustom;
