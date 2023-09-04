export interface NotificationConfigProviderProps {
    container: {
        position: any | string;	
        width: string | number;
        maxWidth: number;
        minWidth: number;
        height: string | number;
        backgroundColor?: string;
        background: string;
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