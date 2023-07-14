import React, { useState, Fragment } from 'react';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { useDisclosure } from '@mantine/hooks';
import { useForm } from '@mantine/form';
//import { useConfig } from '../../providers/ConfigProvider';
import { Stack, Group, Modal, Divider } from '@mantine/core';
import { faCheck, faXmark } from '@fortawesome/free-solid-svg-icons';
import { fetchNui } from "../../utils/fetchNui";
import AnimatedButton from './components/buttons';
import { InputField, SelectField, CheckboxField, DateInputField, PasswordField, SliderField, NumberField } from './components/custom';
import type { ModalPropsCustom, Option, _SelectProps } from '../../typings';

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
      form.setFieldValue(`${index}`, 
        {
          value :
            field.type === ('input' || 'select' || 'password' || 'date') ? field.default || '' 
            : field.type === 'checkbox' ? field.default || false
            : field.type === 'slider' ? field.default || 0
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
    form.setFieldValue(`${index}`, { value , required: isRequired, callback: callback});
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
        styles={{ title: { textAlign: 'center', width: '100%', fontSize: 16 }}}
        transitionProps={ (getData.transition && {transition: getData.transition.name, duration: getData.transition.duration || 100, timingFunction: getData.transition.timingFunction || 'ease-in-out'}) || undefined}
        title={getData.title}
        size={getData.size || 'xs'}
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
