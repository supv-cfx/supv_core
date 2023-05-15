import React, { useState } from 'react';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { useDisclosure } from '@mantine/hooks';
//import { createStyles } from "@mantine/core";
import type { ModalProps } from '../../typings';
import { useConfig } from '../../providers/ConfigProvider';

import { OpenModalConfirm, OpenModalCustom } from './modals';

//import { fetchNui } from "../../utils/fetchNui";

const ModalWrapper: React.FC = () => {
  const { config } = useConfig();
  //const useStyles = createStyles((theme) => ({...config.modalsStyles}));
  //const { classes } = useStyles();
  const [data, setData] = useState<ModalProps>({ type: '' });
  const [opened, { close, open }] = useDisclosure(false);

  useNuiEvent('supv:modal:opened', async (data) => {
    if (
      data.type === 'confirm' &&
      !data.description &&
      !data.title &&
      !data.subtitle
    )
      return;
    setData(data);
    await new Promise((resolve) => setTimeout(resolve, 200));
    open();
  });

  return (
    <>
      {data.type === 'custom' && (
        <OpenModalCustom
          title={data.title}
          options={data.options}
          handleClose={close}
          open={opened && data.type === 'custom'}
        />
      )}
      {data.type === 'confirm' && (
        <OpenModalConfirm
          title={data.title}
          subtitle={data.subtitle}
          description={data.description}
          handleClose={close}
          open={opened && data.type === 'confirm'}
        />
      )}
    </>
  );
};

export default ModalWrapper;
