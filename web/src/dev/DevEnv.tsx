import React, { useState } from 'react';
import { ActionIcon, Tooltip, Drawer, Stack, Divider, Button } from '@mantine/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faWrench } from '@fortawesome/free-solid-svg-icons';

import { debugDialog } from './debug/dialog';

const DevTool: React.FC = () => {

    const [opened, setOpened] = useState<boolean>(false);

    return (
        <>
            <Tooltip label="Dev Tool" position="left">
                <ActionIcon
                    variant="outline"
                    color="gray"
                    onClick={() => setOpened(true)}
                    style={{ position: 'fixed', bottom: 20, right: 20, zIndex: 1000 }}
                >
                    <FontAwesomeIcon icon={faWrench} />
                </ActionIcon>
            </Tooltip>

            <Drawer opened={opened} onClose={() => setOpened(false)} title="tool dev" padding="md" size={300}>
                <Stack spacing="md">
                    <Divider />
                    <Button variant="outline" color="blue" fullWidth onClick={() => {debugDialog(); setOpened(false)}}>Dialog</Button>
                </Stack>
            </Drawer>
        </>
    )
}

export default DevTool;