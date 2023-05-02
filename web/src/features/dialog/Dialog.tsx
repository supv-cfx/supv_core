import { useDisclosure } from '@mantine/hooks';
import { Dialog, Group, Button, Text, Title, Divider } from '@mantine/core';
import { fetchNui } from "../../utils/fetchNui";
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { Children, useState } from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faCheck, faXmark } from '@fortawesome/free-solid-svg-icons';
import type { DialogProps } from '../../typings/Dialog';
import ReactMarkdown from 'react-markdown';
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter';
import { materialDark } from 'react-syntax-highlighter/dist/esm/styles/prism';

// Need rewrite code and not use Dialog from Mantine, but modal from Mantine or create a new component persnalized

const DialogComponent: React.FC = () => {
  const [state, setState] = useState<DialogProps>({ title: '', subtitle: '', description: '' });
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
    setState({ title: data.title, description: data.description, subtitle: data.subtitle });
    toggle();
  });

  const CloseDialog = (button: boolean) => {
    close();
    fetchNui('supv:dialog:closed', button)
  };

  return (
    <>
      <Dialog transition={"skew-down"} withBorder opened={opened} withCloseButton onClose={() => CloseDialog(false)} size="lg" radius="md" position={{ top: '20%', right: '45%' }} style={{width: 'fit-content'}}>
        <Title order={1} align='center' mb="xs" underline={true}> {state.title} </Title>
        <Title order={2} align={!state.title ? 'center' : 'left'} mb="xs" weight={1} italic={true}> {state.subtitle} </Title>
        <Divider />
        <ReactMarkdown
          children={state.description}
          components={{
            code({ node, inline, className, children, ...props }) {
              const match = /language-(\w+)/.exec(className || '')
              return !inline && match ? (
                <SyntaxHighlighter
                  {...props}
                  children={String(children).replace(/\n$/, '')}
                  style={materialDark}
                  language={match[1]}
                  PreTag="div"
                />
              ) : (
                <code {...props} className={className}>
                  {children}
                </code>
              )
            },
            //text({ node, ...props }) { // Need to fix this or useless?
            //  return (
            //    <Text
            //      {...Children}
            //      size="sm"
            //      mb="xs"
            //      weight={500}
            //      italic={true}
            //      align={!state.subtitle && !state.title ? 'center' : 'left'}
            //    />
            //  );
            //}
          }}
        />
        <Group align="center" position='center'> {/* Need personalized icon */}
          {AnimatedButton(faXmark, 'Annuler', CloseDialog, false, 'red')}
          {AnimatedButton(faCheck, 'Valider', CloseDialog, true, 'green')}
        </Group>
      </Dialog>
    </>
  );
}

export default DialogComponent;
/* keep this for later or maybe not?
<Text  align={!state.subtitle && !state.title ? 'center' : 'left'} size="sm" mb="xs" weight={500} italic={true}>
    {state.description}
</Text>
*/