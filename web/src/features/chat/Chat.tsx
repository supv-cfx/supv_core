import React, { useState, useRef, KeyboardEvent } from 'react';
import { Container, Paper, Text, Grid, Divider, Input, Popover, ScrollArea, Burger, Menu } from '@mantine/core';
import { useListState, useDisclosure } from '@mantine/hooks';
import { IconDefinition } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faCheck, faTimes, faList, faVolumeMute, faVolumeUp, faArrowUp, faArrowDown, faArrowsLeftRight, faTrashArrowUp } from '@fortawesome/free-solid-svg-icons';
import EmojiReaction from './Reactions'
import EmojiPickerButton from './Emoji';

interface Message {
  id: string;
  username: string | null;
  content: string;
  timestamp: string;
  reactions: { [key: string]: number };
}

interface Argument {
  name: string;
  type: string;
  optional?: boolean;
}

interface CommandProps {
  label: string;
  description: string;
  icon: IconDefinition;
  value: string;
  arguments?: Argument[];
}

// Seulement pour tester
const COMMANDS: CommandProps[] = [
  { label: 'Help', description: 'Afficher l\'aide', icon: faCheck, value: '/help' },
  { label: 'List', description: 'Liste des utilisateurs', icon: faList, value: '/list' },
  { label: 'Mute', description: 'Mettre en sourdine', icon: faVolumeMute, value: '/mute', arguments: [{ name: 'playerId', type: 'number' }, { name: 'duration', type: 'number', optional: true }] },
  { label: 'Unmute', description: 'Désactiver la sourdine', icon: faVolumeUp, value: '/unmute', arguments: [{ name: 'playerId', type: 'number' }] },
  { label: 'Clear', description: 'Vider les messages du chat', icon: faTimes, value: '/clear' },
];

const data = COMMANDS.map((item) => ({ ...item, value: item.value }));

interface PopoverItemProps {
  command: CommandProps;
  onClose: () => void;
  onSelect: (value: string) => void;
}

const PopoverItem = ({ command, onClose, onSelect }: PopoverItemProps) => {
  const [isHovered, setIsHovered] = useState(false);

  let label = command.value;
  if (command.arguments) {
    const args = command.arguments.map((arg) => `[${arg.name}: ${arg.type}]`).join(' ');
    label += ` ${args}`;
  }

  const handleMouseEnter = () => {
    setIsHovered(true);
  };

  const handleMouseLeave = () => {
    setIsHovered(false);
  };

  const itemStyle = {
    padding: '8px',
    backgroundColor: isHovered ? 'rgba(24, 100, 171, 0.5)' : 'transparent', // Changer la couleur de fond en fonction du survol
  };

  return (
    <div
      className="command-item"
      style={itemStyle}
      onClick={() => {
        onSelect(command.value);
        //onClose();
      }}
      onMouseEnter={handleMouseEnter}
      onMouseLeave={handleMouseLeave}
    >
      <Text size="sm" color="dimmed"> {command.description} </Text>
      <div style={{ display: 'flex', alignItems: 'center' }}>
        <FontAwesomeIcon icon={command.icon} style={{ marginRight: '8px' }} />
        <Text>{command.value}</Text>
      </div>
      {command.arguments && (
        <Text size="sm" color="dimmed"> {label} </Text>
      )}
    </div>
  );
};

const ChatText: React.FC = () => {
  const [message, setMessage] = useState<string>('');
  const [messages, handlers] = useListState<Message>([]);
  const viewport = useRef<HTMLDivElement | null>(null);
  const viewportCommands = useRef<HTMLDivElement | null>(null);
  const [opened, { toggle }] = useDisclosure(false);
  //const [emojiPickerOpen, setEmojiPickerOpen] = useState(false);
  const [filteredCommands, setFilteredCommands] = useState(COMMANDS);
  const [command, setCommand] = useState<string>('');

  const scrollToBottom = () => viewport.current?.scrollTo({ top: viewport.current.scrollHeight, behavior: 'smooth' });
  const scrollToCenter = () => viewport.current?.scrollTo({ top: viewport.current.scrollHeight / 2, behavior: 'smooth' });
  const scrollToTop = () => viewport.current?.scrollTo({ top: 0, behavior: 'smooth' });

  const sendMessage = () => {
    if (message.trim() !== '') {
      if (message.startsWith('/')) {
        // Exécuter la fonction correspondant à la commande
        handleCommand(message);
      } else {
        handlers.append({ id: 'à changer' || '', username: 'SUP2Ak' || '', content: message, timestamp: new Date().toLocaleTimeString(), reactions: {} });
        if (viewport.current && (viewport.current.scrollHeight - viewport.current.scrollTop <= (viewport.current.clientHeight + 200))) {
          scrollToBottom();
        }
      }
      setMessage('');
    }
  };

  const handleCommand = (command: string) => {
    const commandWithoutSlash = command.slice(1); // Enlever le '/'
    const commandArgs = commandWithoutSlash.split(' '); // Diviser la chaîne de caractères en un tableau d'arguments

    if (commandArgs[0] === 'clear') {
      handlers.setState([]); // reset
      setFilteredCommands([]);
      
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

  const handleInputChange = (value: string) => {
    setMessage(value);

    if (value.startsWith('/')) {
      const commandName = value.split(' ')[0];
      setCommand(commandName);
    } else {
      setCommand('');
    }

    if (command) {
      const matchingCommands = data.filter(
        (cmd) => cmd.value.startsWith(command.toLowerCase())
      );
      setFilteredCommands(matchingCommands);
    } else if (value.startsWith('/') && value.length === 1) {
      setFilteredCommands(data);
    } else {
      setFilteredCommands([]);
    }

    if (value === '') {
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

  const handleSelectEmoji = (emoji: Object) => {
    setMessage((prevMessage) => prevMessage + emoji);
    //setEmojiPickerOpen(false);
  };

  return (
    <>
      <Container style={{ top: 10, left: 10, position: 'fixed' }}>
        <Paper style={{ padding: '16px'/*, backgroundColor: 'rgba(0,0,0,0.75)'*/ }} shadow="xl">
          <Grid grow gutter="xs">
            <Grid.Col span={12} style={{ paddingBottom: 10 }}>
              <Text align="center" size="xl">
                🇫🇷 Nom du serveur 🇫🇷
              </Text>
            </Grid.Col>
          </Grid>
          <Divider />
          <Grid gutter="xs" style={{ paddingBottom: 10 }}>
            <Grid.Col span={12}>
              <ScrollArea.Autosize mah={300} viewportRef={viewport}>
                <div style={{ maxHeight: '300px', width: 500 }}>
                  {messages.map((msg, index) => (
                    <Text key={index} style={{ wordWrap: 'break-word', maxWidth: '99%', userSelect: 'text' }}>
                      <b>{msg.timestamp}</b><br />{msg.username}: {msg.content}
                      <EmojiReaction reactions={msg.reactions} onReactionClick={(reaction: string) => handleReactionClick(index, reaction)} />
                    </Text>
                  ))}
                </div>
              </ScrollArea.Autosize>
            </Grid.Col>
          </Grid>
          <Divider />
          <Grid style={{ display: 'flex', justifyContent: 'space-between' }}>
            <Grid.Col span={10} style={{ alignItems: 'center' }}>
              <Input
                placeholder="Ecrivez votre message..."
                value={message}
                onChange={(event) => handleInputChange(event.currentTarget.value)}
                onKeyDown={handleKeyPress}
                style={{ width: '100%' }}
              />
            </Grid.Col>
            <Grid.Col span={2} style={{ display: 'flex', justifyContent: 'center' }}>
            <EmojiPickerButton onSelect={handleSelectEmoji} />
              <Menu
                width={150}
                shadow="md"
                defaultOpened={opened}
                closeOnItemClick={false}
                onClose={toggle}
                position="right-start"
                transitionProps={{ transition: 'rotate-right', duration: 150 }}
              >
                <Menu.Target>
                  <Burger opened={opened} onClick={toggle} />
                </Menu.Target>
                <Menu.Dropdown>
                  <Menu.Label>Scroll</Menu.Label>
                  <Menu.Item
                    disabled={viewport.current && viewport.current.clientHeight < 300 ? true : false}
                    onClick={scrollToTop}
                    color="blue"
                    icon={<FontAwesomeIcon icon={faArrowUp} />}
                  >
                    Up
                  </Menu.Item>
                  <Menu.Item
                    disabled={viewport.current && viewport.current.clientHeight < 300 ? true : false}
                    onClick={scrollToCenter}
                    color="blue"
                    icon={<FontAwesomeIcon icon={faArrowsLeftRight} />}
                  >
                    Center
                  </Menu.Item>
                  <Menu.Item
                    disabled={viewport.current && viewport.current.clientHeight < 300 ? true : false}
                    onClick={scrollToBottom}
                    color="blue"
                    icon={<FontAwesomeIcon icon={faArrowDown} />}
                  >
                    Down
                  </Menu.Item>
                  <Menu.Label>Options</Menu.Label>
                  <Menu.Item
                    closeMenuOnClick
                    onClick={() => {
                      handlers.setState([]);
                    }}
                    color="red"
                    icon={<FontAwesomeIcon icon={faTrashArrowUp} />}
                  >
                    Clear
                  </Menu.Item>
                </Menu.Dropdown>
              </Menu>
            </Grid.Col>
          </Grid>

          <ScrollArea.Autosize mah={300} viewportRef={viewportCommands}>
            {filteredCommands.length > 0 && (
              <Popover
                //target={<div />}
                opened={Boolean(filteredCommands.length)}
                onClose={() => setFilteredCommands([])}
                position="bottom"
                withArrow
              >
                <div style={{ maxHeight: '300px' }}>
                  {filteredCommands.map((cmd) => (
                    <PopoverItem
                      key={cmd.label}
                      command={cmd}
                      onClose={() => setFilteredCommands([])}
                      onSelect={(value) => {
                        setMessage(value);
                        setFilteredCommands([cmd]);
                      }}
                    />
                  ))}
                </div>
              </Popover>
            )}
          </ScrollArea.Autosize>
        </Paper>
      </Container>
    </>
  );
};

export default ChatText;