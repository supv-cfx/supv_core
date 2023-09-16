import React, { useState } from 'react';
import { Modal, Divider, Group, Text, Stack } from '@mantine/core';
import { useDisclosure } from '@mantine/hooks';
import { faCheck, faXmark } from '@fortawesome/free-solid-svg-icons';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { fetchNui } from '../../utils/fetchNui';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import AnimatedButton from './components/buttons';
import type { ModalConfirmProps } from '../../typings';

const ModalConfirm: React.FC = () => {
  const [values, setValues] = useState<ModalConfirmProps>({});
  const [opened, { close, open }] = useDisclosure(false);

  const handleConfirm = async (value: boolean) => {
    close();
    await new Promise((resolve) => setTimeout(resolve, 200));
    fetchNui('supv:modal:confirm', value);
  };

  useNuiEvent<ModalConfirmProps>('supv:modal:opened-confirm', async (data) => {
    if (!data.title && !data.description) return;
    setValues(data);
    await new Promise((resolve) => setTimeout(resolve, 200));
    open();
  });

  return (
    <>
      <Modal
        opened={opened}
        onClose={close}
        centered
        withCloseButton={false}
        closeOnClickOutside={false}
        closeOnEscape={false}
        transitionProps={ (values.transition && {transition: values.transition.name, duration: values.transition.duration || 100, timingFunction: values.transition.timingFunction || 'ease-in-out'}) || undefined}
        title={values.title}
        size={values.size || 'md'}
        styles={{ 
          header: { background: 'linear-gradient(45deg, rgba(7, 18, 39, 0.94) 25%, rgba(8, 25, 56, 0.94) 50%, rgba(14, 44, 100, 0.86) 100%)', },
          title: {fontFamily: 'Yellowtail', textAlign: 'center', width: '100%', fontSize: 20, color: 'white'},
          body: { background: 'rgba(0,0,0,0.5)'},
        }}
        style={{
          background: 'linear-gradient(45deg, rgba(7, 18, 39, 0.94) 25%, rgba(8, 25, 56, 0.94) 50%, rgba(14, 44, 100, 0.86) 100%)',
        }}
        withOverlay={values.withOverlay || false}
      >
        <Divider variant='solid' />
        <Stack spacing='xs'>
          {values.description && values.title ? (
            <ReactMarkdown
              children={values.description}
              remarkPlugins={[remarkGfm]}
            />
          ) : (
            <Text
              align={!values.title ? 'center' : 'left'}
              size='sm'
              mb='xs'
              weight={500}
              italic={true}
            >
              {values.description}
            </Text>
          )}
          <Group align='center' position='center'>
            <AnimatedButton
              iconAwesome={faXmark}
              text='Annuler'
              onClick={handleConfirm}
              color='red.6'
              args={false}
            />
            <AnimatedButton
              iconAwesome={faCheck}
              text='Valider'
              onClick={handleConfirm}
              color='teal.6'
              args={true}
            />
          </Group>
        </Stack>
      </Modal>
    </>
  );
};

export default ModalConfirm;
