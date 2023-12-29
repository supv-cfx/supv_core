import React, { useState } from 'react';
import {
  ActionIcon,
  Tooltip,
  Drawer,
  Stack,
  Divider,
  Button,
  Flex,
  Text
} from '@mantine/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import {
  faWrench,
  faArrowLeft,
  faArrowRight,
} from '@fortawesome/free-solid-svg-icons';
import { debugNotification } from './debug/notifcation';
import { debugModalsConfirm } from './debug/modals/confirm';
import { debugModalsCustom } from './debug/modals/custom';
import { debugResourceManager } from './debug/resource';
import { debugCosshairTool } from './debug/crosshairTool';

interface Props {
  text: string;
  Clicked: () => void;
  color: string;
  isDisabled?: boolean;
}

const AnimatedButtons: React.FC<Props> = ({
  text,
  Clicked,
  color,
  isDisabled
}) => {
  const [isHovered, setIsHovered] = useState(false);

  return (
    <Button
      disabled={isDisabled}
      variant='outline'
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      color={isHovered ? color : 'blue'}
      onClick={Clicked}
    >
      {text}
    </Button>
  );
};

const DevTool: React.FC = () => {
  const [opened, setOpened] = useState<boolean>(false);
  const [side, setSide] = useState<'left' | 'right'>('right');

  return (
    <>
      <Tooltip label='Open [supv] Tool' position={'right'}>
        <ActionIcon
          variant='outline'
          color='gray'
          onClick={() => setOpened(true)}
          style={{ position: 'fixed', bottom: 20, right: 20, zIndex: 1000 }}
        >
          <FontAwesomeIcon icon={faWrench} />
        </ActionIcon>
      </Tooltip>

      <Drawer
        opened={opened}
        onClose={() => setOpened(false)}
        title='sublime core tool dev'
        padding='md'
        size={300}
        position={side === 'left' ? 'right' : 'left'}
      >
        <Stack spacing='md'>
          <Button
            rightIcon={<FontAwesomeIcon icon={faArrowRight} />}
            leftIcon={<FontAwesomeIcon icon={faArrowLeft} />}
            variant='outline'
            color='orange'
            size='xs'
            fullWidth
            onClick={() => setSide(side === 'left' ? 'right' : 'left')}
          >
            Side
          </Button>
          <Divider />
          <Flex
            bg='dark.3'
            gap='xs'
            style={{ borderRadius: 4}}
            justify='center'
            align='center'
            direction='row'
            wrap='wrap'
          >
            <Text>Modal: </Text>
            <AnimatedButtons text='Confirm' Clicked={() => {debugModalsConfirm(); setOpened(false)}} color='dark.9'/>
            <AnimatedButtons text='Custom' Clicked={() => {debugModalsCustom(); setOpened(false)}} color='dark.9'/>
          </Flex>
          <Button
            variant='outline'
            color='red'
            fullWidth
            onClick={() => debugNotification()}
          >
            Notication
          </Button>
          <Button
            variant='outline'
            color='yellow'
            fullWidth
            onClick={() => {debugResourceManager(); setOpened(false)}}
          >
            Resource Manager
          </Button>
          <Button
            variant='outline'
            color='teal'
            fullWidth
            onClick={() => {debugCosshairTool(); setOpened(false)}}
          >
            Crosshair Tool
          </Button>
        </Stack>
      </Drawer>
    </>
  );
};

export default DevTool;
