import { Modal, Title, Divider, Group, Text } from '@mantine/core';
import { faCheck, faXmark } from '@fortawesome/free-solid-svg-icons';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import { fetchNui } from '../../../utils/fetchNui';
import AnimatedButton from '../components/buttons';
import React from 'react';

export interface ModalConfirmProps {
  title?: string;
  subtitle?: string;
  description?: string;
  handleClose: () => void;
  open: boolean;
}

export const OpenModalConfirm: React.FC<ModalConfirmProps> = ({
  title,
  subtitle,
  description,
  handleClose,
  open,
}) => {
  const handleConfirm = async (value: boolean) => {
    await new Promise((resolve) => setTimeout(resolve, 200));
    handleClose();
    fetchNui('supv:modal:closedCondirm', value);
  };

  return (
    <Modal
      opened={open}
      onClose={handleClose}
      size='md'
      padding='xs'
      centered
      transitionProps={{
        transition: 'scale-y',
        duration: 250,
        keepMounted: true,
        timingFunction: 'ease-in-out',
      }}
    >
      <Title order={1} align='center' mb='xs' underline={true}>
        {' '}
        {title}{' '}
      </Title>
      <Title
        order={2}
        align={!title ? 'center' : 'left'}
        mb='xs'
        weight={1}
        italic={true}
      >
        {' '}
        {subtitle}{' '}
      </Title>
      <Divider />
      {description && (subtitle || title) ? (
        <ReactMarkdown children={description} remarkPlugins={[remarkGfm]} />
      ) : (
        <Text
          align={!subtitle && !title ? 'center' : 'left'}
          size='sm'
          mb='xs'
          weight={500}
          italic={true}
        >
          {description}
        </Text>
      )}
      <Divider />
      <Group align='center' position='center'>
        {' '}
        {/* Need personalized icon */}
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
    </Modal>
  );
};
