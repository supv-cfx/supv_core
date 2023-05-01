export interface NotificationConfigProviderProps {
    container: {
        width: string | number;
        maxWidth: number;
        minWidth: number;
        height: string | number;
        backgroundColor: string;
        fontFamily: string;
    },
    title: {
        fontWeight: number;
        lineHeight: string;
        color: string;
    },
    description: {
        fontSize: number;
        color: string;
        fontFamily: string;
        lineHeight: string;
    },
    descriptionOnly: {
        fontSize: number;
        color: string;
        fontFamily: string;
        lineHeight: string;
    },
}