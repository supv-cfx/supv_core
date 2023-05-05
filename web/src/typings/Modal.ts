export interface ModalProps {
    type: string // type of the modal (confirm, input, etc..) !important

    title?: string; // title of the modal used in all types

    // used by : confirm
    subtitle?: string; // subtitle of the modal
    description?: string; // description of the modal
}