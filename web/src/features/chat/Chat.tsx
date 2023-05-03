import React, { useState, useEffect, useRef, forwardRef, KeyboardEvent, UIEvent } from 'react';
import { Container, Paper, Button, Text, Grid, Autocomplete, Group, MantineColor, SelectItemProps, Divider } from '@mantine/core';
import { useListState } from '@mantine/hooks';

import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faCheck, faXmark, faTimes, faList, faVolumeMute, faVolumeUp } from '@fortawesome/free-solid-svg-icons';
import EmojiReaction from './Reactions'

interface Message {
  id: string;
  username: string | null;
  content: string;
  timestamp: string;
  reactions: { [key: string]: number };
}

interface ItemProps extends SelectItemProps {
  color: MantineColor;
  description: string;
  icon: any;
}

const COMMANDS = [
  { label: 'Help', description: 'Afficher l\'aide', icon: faCheck, value: '/help' },
  { label: 'List', description: 'Liste des utilisateurs', icon: faList, value: '/list' },
  { label: 'Mute', description: 'Mettre en sourdine', icon: faVolumeMute, value: '/mute' },
  { label: 'Unmute', description: 'Désactiver la sourdine', icon: faVolumeUp, value: '/unmute' },
  { label: 'Clear', description: 'Vider les messages du chat', icon: faTimes, value: '/clear' },
];

const data = COMMANDS.map((item) => ({ ...item, value: item.value }));

const AutoCompleteItem = forwardRef<HTMLDivElement, ItemProps>(
  ({ description, value, icon, ...others }: ItemProps, ref) => (
    <div ref={ref} {...others}>
      <Group noWrap>
        <FontAwesomeIcon icon={icon} size="lg" style={{ marginRight: 8 }} />

        <div>
          <Text>{value}</Text>
          <Text size="xs" color="dimmed">
            {description}
          </Text>
        </div>
      </Group>
    </div>
  )
);

// work for chronium only not finish yet
const scrollbarStyle = `
  ::-webkit-scrollbar {
    width: 2px;
    maxHeight: 200px;
  }
  
  ::-webkit-scrollbar-track {
    background-color: #f1f1f1;
  }
  
  ::-webkit-scrollbar-thumb {
    background-color: #888;
    border-radius: 4px;
  }
  
  ::-webkit-scrollbar-thumb:hover {
    background-color: #555;
  }
`;

const ScrollbarStyle: React.FC = () => {
  return <style>{scrollbarStyle}</style>;
};

const ChatText: React.FC = () => {
  const [message, setMessage] = useState<string>('');
  const [messages, handlers] = useListState<Message>([]);
  const [autoScroll, setAutoScroll] = useState(true);
  const anchorRef = useRef<HTMLDivElement>(null);
  const messagesContainerRef = useRef<HTMLDivElement>(null);
  const [scrollTimeout, setScrollTimeout] = useState<NodeJS.Timeout | null>(null);

  const [filteredCommands, setFilteredCommands] = useState(COMMANDS);

  const scrollToBottom = () => {
    if (autoScroll) {
      anchorRef.current?.scrollIntoView({ behavior: 'smooth' });
    }
  };

  const handleScroll = (e: UIEvent<HTMLDivElement>) => {
    const element = e.currentTarget;
    const atBottom = Math.ceil(element.scrollHeight - element.scrollTop) === element.clientHeight;

    if (atBottom !== autoScroll) {
      setAutoScroll(atBottom);
    }
  };

  const sendMessage = () => {
    if (message.trim() !== '') {
      if (message.startsWith('/')) {
        // Exécuter la fonction correspondant à la commande
        handleCommand(message);
      } else {
        handlers.append({ id: 'à changer' || '', username: 'SUP2Ak' || '', content: message, timestamp: new Date().toLocaleTimeString(), reactions: {} });
        scrollToBottom();
      }
      setMessage('');
    }
  };

  const handleCommand = (command: string) => {
    const commandWithoutSlash = command.slice(1); // Enlever le '/'
    const commandArgs = commandWithoutSlash.split(' '); // Diviser la chaîne de caractères en un tableau d'arguments

    if (commandArgs[0] === 'clear') {
      handlers.setState([]); // reset
    } else {
      alert(`Commande : ${commandArgs[0]}, Arguments : ${commandArgs.slice(1).join(', ')}`);
    }

    //alert(`Commande : ${commandArgs[0]}, Arguments : ${commandArgs.slice(1).join(', ')} , args1: ${commandArgs[1]}, args2: ${commandArgs[2]}}`);
  };

  const handleKeyPress = (e: KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      sendMessage();
    }
  };

  useEffect(() => {
    if (autoScroll) {
      if (scrollTimeout) {
        clearTimeout(scrollTimeout);
      };
      const timeout = setTimeout(() => {
        scrollToBottom();
      }, 1000);
      setScrollTimeout(timeout);
    }
  }, [messages]);

  const handleInputChange = (value: string) => {
    setMessage(value);
    if (value.startsWith('/')) {
      setFilteredCommands(
        data.filter((command) =>
          command.value.toLowerCase().includes(value.slice(1).toLowerCase())
        )
      );
    } else {
      setFilteredCommands([]);
    }
  };

  const handleReactionClick = (messageIndex: number, reaction: string) => {
    const updatedMessages = [...messages];
    const message = updatedMessages[messageIndex];

    if (message.reactions && message.reactions[reaction]) {
      message.reactions[reaction] -= 1;
    } else {
      message.reactions = { ...message.reactions, [reaction]: 1 };
    }

    handlers.setItem(messageIndex, message);
  };

  return (
    <>
      <ScrollbarStyle />
      <Container style={{ top: 10, left: 10, position: 'fixed' }}>
        <Paper style={{ padding: '16px'/*, backgroundColor: 'rgba(0,0,0,0.75)'*/ }} shadow="xl">
          <Grid gutter="xs">
            <Grid.Col span={12}>
              <Text align="center" size="xl">
                supv_core Chat
              </Text>
            </Grid.Col>
          </Grid>
          <Divider />
          <Grid gutter="xs">
            <Grid.Col span={12}>
              <div style={{ maxHeight: '300px', overflowY: 'auto', width: 500 }} onScroll={handleScroll} ref={messagesContainerRef}>
                {messages.map((msg, index) => (
                  <Text key={index} style={{ wordWrap: 'break-word', maxWidth: '99%', userSelect: 'text' }}>
                    <b>{msg.timestamp}</b><br />{msg.username}: {msg.content}
                    <EmojiReaction reactions={msg.reactions} onReactionClick={(reaction: string) => handleReactionClick(index, reaction)} />
                  </Text>
                ))}
                <div ref={anchorRef} />
              </div>
            </Grid.Col>
          </Grid>
          <Divider />
          <Grid gutter="xs">
            <Grid.Col span={8}>
              <Autocomplete
                placeholder="Ecrivez votre message..."
                value={message}
                data={filteredCommands}
                itemComponent={AutoCompleteItem}
                onChange={(value) => handleInputChange(value)}
                onKeyDown={handleKeyPress}
              />
            </Grid.Col>
            <Grid.Col span={4}>
              <Button onClick={sendMessage} fullWidth>
                Envoyer
              </Button>
            </Grid.Col>
          </Grid>
        </Paper>
      </Container>
    </>
  );
};

export default ChatText;