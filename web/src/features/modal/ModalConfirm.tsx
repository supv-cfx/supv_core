import { Modal, Title, Divider, Group, Text } from '@mantine/core';
import { faCheck, faXmark } from '@fortawesome/free-solid-svg-icons';
import ReactMarkdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import { fetchNui } from '../../utils/fetchNui';
import AnimatedButton from './components/buttons';


export interface ModalConfirmProps {
    title?: string;
    subtitle?: string;
    description?: string;
    handleClose: () => void;
}
  
export const OpenModalConfirm: React.FC<ModalConfirmProps> = ({ title, subtitle, description, handleClose }) => {

    const handleConfirm = (value: boolean) => {
        //console.log(value, 'value')
        fetchNui('supv:modal:closed', value);
        handleClose();
    }

    return (
        <Modal opened={true} onClose={handleClose} size="md" padding="md" radius="md" shadow="md">
            <Title order={1} align='center' mb="xs" underline={true}> {title} </Title>
            <Title order={2} align={!title ? 'center' : 'left'} mb="xs" weight={1} italic={true}> {subtitle} </Title>
            <Divider />
            {description && (subtitle || title) ? (
                <ReactMarkdown
                    children={description}
                    remarkPlugins={[remarkGfm]}
                />
            ) : (
                <Text align={!subtitle && !title ? 'center' : 'left'} size="sm" mb="xs" weight={500} italic={true}>
                    {description}
                </Text>
            )}
            <Divider />
            <Group align="center" position='center'> {/* Need personalized icon */}
                <AnimatedButton iconAwesome={faXmark} text='Annuler' onClick={handleConfirm} color='red' args={false}/>
                <AnimatedButton iconAwesome={faCheck} text='Valider' onClick={handleConfirm} color='green' args={true}/>
            </Group>
        </Modal>
    );
}

export default OpenModalConfirm;