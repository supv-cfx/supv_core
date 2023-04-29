import { useDisclosure } from '@mantine/hooks';
import { Dialog, Group, Button, Text, Title, Divider } from '@mantine/core';
import { fetchNui } from "../../utils/fetchNui";
import { useNuiEvent } from '../../hooks/useNuiEvent';
import {useState} from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faCheck, faXmark } from '@fortawesome/free-solid-svg-icons';
import type { DialogProps } from '../../typings/Dialog';

const DialogComponent: React.FC = () => {
    const [state, setState] = useState<DialogProps>({title: '', subtitle: '', description: ''});
    const [opened, { toggle, close }] = useDisclosure(false);

    const AnimatedButton = (iconAwesome: any, text: string, closed: Function, args: boolean, color: string) => {
        const [isHovered, setIsHovered] = useState(false);
      
        return (
          <Button
            onMouseEnter={() => setIsHovered(true)}
            onMouseLeave={() => setIsHovered(false)}
            rightIcon={
              <FontAwesomeIcon
                icon={iconAwesome}
                shake={isHovered}
                style={{ transition: "transform 0.5s" }}
              />
            }
            color={color}
            onClick={() => closed(args)}
          >
            {text}
          </Button>
        );
    }

    useNuiEvent<DialogProps>('supv:dialog:opened', (data) => {
        setState({title: data.title, description: data.description, subtitle: data.subtitle});
        toggle();
    });
    
    const CloseDialog = (button: boolean) => {
        close();
        fetchNui('supv:dialog:closed', button)
    };

    return (
        <>
            <Dialog transition={"skew-down"} withBorder opened={opened} withCloseButton onClose={() => CloseDialog(false)} size="lg" radius="md" position={{top: '20%', right: '45%'}}>
                <Title order={1} align='center' mb="xs" underline={true}> {state.title} </Title>
                <Title order={2} align={!state.title ? 'center' : 'left'} mb="xs" weight={1} italic={true}> {state.subtitle} </Title>
                <Divider />
                <Text  align={!state.subtitle && !state.title ? 'center' : 'left'} size="sm" mb="xs" weight={500} italic={true}>
                    {state.description}
                </Text>

                <Group align="center" position='center'>
                    {AnimatedButton(faXmark, 'Annuler', CloseDialog, false, 'red')}
                    {AnimatedButton(faCheck, 'Valider', CloseDialog, true, 'green')}
                </Group>
            </Dialog>
        </>  
    );
}

export default DialogComponent;