import { Theme, Categories } from 'emoji-picker-react';

export const ConfigEmojiPicker = { // https://www.npmjs.com/package/emoji-picker-react
    previewConfig: {
        defaultEmoji: '1f60a',
        defaultCaption: "What's your mood?",
        showPreview: true,

    },
    searchPlaceholder: 'Recherche des emojis', // Not working ?
    categories: [
        { name: 'Récent', category: Categories.SUGGESTED },
        { name: 'Smileys & People', category: Categories.SMILEYS_PEOPLE },
        { name: 'Animals & Nature', category: Categories.ANIMALS_NATURE },
        { name: 'Food & Drink', category: Categories.FOOD_DRINK },
        { name: 'Travel & Places', category: Categories.TRAVEL_PLACES },
        { name: 'Activities', category: Categories.ACTIVITIES },
        { name: 'Objects', category: Categories.OBJECTS },
        { name: 'Symbols', category: Categories.SYMBOLS },
        { name: 'Flags', category: Categories.FLAGS }
    ],
    theme: Theme.DARK
};