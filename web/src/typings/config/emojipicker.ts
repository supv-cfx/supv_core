import { Categories, Theme } from "emoji-picker-react";

interface PreviewConfig {
    defaultEmoji: string;
    defaultCaption: string;
    showPreview: boolean;
}

export interface EmojiPickerProps {
    previewConfig: PreviewConfig,
    searchPlaceholder: string,
    categories: Array<{ name: string, category: Categories }>,
    theme: Theme
}