/*
import { debugData } from "../../utils/debugData";
import type {ModalProps} from "../../typings";

export const debugDialog = () => {
  debugData([
    {
      action: 'supv:modal:opened',
      data: {
        type: 'confirm',
        title: 'Dialog title',
        subtitle: 'Mon code snippet',
        description:`
A paragraph with *emphasis* and **strong importance**.
> A block quote with ~strikethrough~ and a URL: https://reactjs.org.

* Lists
* [ ] todo
* [x] done

A table:

| a | b |
| - | - |
        `
        } as ModalProps,
      }
  ]);     
}

/*
  /*debugData([
      {
        action: 'supv:dialog:opened',
        data: {
          /*title: 'Dialog title',
          subtitle: 'Lorem Ipsum',
          description: 'Contrary to popular.',
        } as DialogProps,
      }
  ]);*/

 /*`
~~~tsx
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
              <Button variant='outline' color='red' fullWidth onClick={() => debugNotification()}>Notication</Button>
          </Stack>
      </Drawer>
  </>
);
~~~       
`,*/