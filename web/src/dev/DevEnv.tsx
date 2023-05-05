import React, { useState } from 'react';
import { ActionIcon, Tooltip, Drawer, Stack, Divider, Button } from '@mantine/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faWrench, faArrowLeft, faArrowRight } from '@fortawesome/free-solid-svg-icons';

import { debugModalsConfirm } from './debug/modals/confirm';
import { debugNotification } from './debug/notifcation';

const DevTool: React.FC = () => {
    const [opened, setOpened] = useState<boolean>(false);
    const [side, setSide] = useState<'left' | 'right'>('right');

    return (
        <>
            <Tooltip label="Open [supv] Tool" position={'right'}>
                <ActionIcon
                    variant="outline"
                    color="gray"
                    onClick={() => setOpened(true)}
                    style={{ position: 'fixed', bottom: 20, right: 20, zIndex: 1000 }}
                >
                    <FontAwesomeIcon icon={faWrench} />
                </ActionIcon>
            </Tooltip>

            <Drawer opened={opened} onClose={() => setOpened(false)} title="supv core tool dev" padding="md" size={300}
                position={side === 'left' ? 'right' : 'left'}
            >
                <Stack spacing="md">
                    <Button rightIcon={<FontAwesomeIcon icon={faArrowRight}/>} leftIcon={<FontAwesomeIcon icon={faArrowLeft}/>} 
                        variant="outline" color="orange" size='xs' fullWidth onClick={() => setSide(side === 'left' ? 'right' : 'left')}
                    >Side</Button>
                    <Divider />
                    <Button variant="outline" color="blue" fullWidth onClick={() => {debugModalsConfirm(); setOpened(false)}}>Dialog</Button>
                    <Button variant='outline' color='red' fullWidth onClick={() => debugNotification()}>Notication</Button>
                </Stack>
            </Drawer>
        </>
    )
}

export default DevTool;