import { useDisclosure } from '@mantine/hooks';
import { Dialog, Group, Button, Text, Title } from '@mantine/core';
import { debugData } from "../../utils/debugData";
import { fetchNui } from "../../utils/fetchNui";
import { useNuiEvent } from '../../hooks/useNuiEvent';
import {useState} from 'react';
import { isEnvBrowser } from '../../utils/misc';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faCheck, faXmark } from '@fortawesome/free-solid-svg-icons';
import type { DialogProps } from '../../typings/Dialog';

debugData([
    {
      action: 'setVisible',
      data: true,
    }
])

const Browser = (toggle: any) => {
    if (isEnvBrowser()) {
        return (
            <Group position="center">
                <Button onClick={toggle}>Toggle dialog</Button>
            </Group>
        );
    }
}

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

const DialogComponent: React.FC = () => {
    const [state, setState] = useState<DialogProps>({title: '', subtitle: '', description: ''});
    const [opened, { toggle, close }] = useDisclosure(false);

    useNuiEvent('supv:dialog:opened', (data) => {
        if (!opened) {
            setState({title: data.title, description: data.description ?? '', subtitle: data.subtitle ?? ''});
            toggle();
        } else {
            close();
        };
    });
    
    const CloseDialog = (data: boolean) => {
        close();
        if (isEnvBrowser()) return
        fetchNui('supv:dialog:closed', data)
    };

    return (
        <>
            {Browser(toggle)}

            <Dialog transition={"skew-down"} withBorder opened={opened} withCloseButton onClose={() => CloseDialog(false)} size="lg" radius="md" position={{top: '20%', right: '45%'}}>
                <Title order={1} align='center' mb="xs" underline={true}> {(state.title) || (isEnvBrowser() && "Titre")} </Title>
                <Title order={2} mb="xs" weight={1} italic={true}> {(state.subtitle) || (isEnvBrowser() && "Sous titre")} </Title>
                <Text size="sm" mb="xs" weight={500} italic={true}>
                    {(state.description) || (isEnvBrowser() && "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum")}
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

