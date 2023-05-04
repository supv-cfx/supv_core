import React, { useState } from 'react';
import EmojiPicker, { Theme, Categories } from 'emoji-picker-react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faSmile } from '@fortawesome/free-regular-svg-icons';
import { Button } from '@mantine/core';

interface EmojiPickerProps {
    onSelect: (emoji: Object) => void;
}


// A mettre plus tard dans le config : interface.cfg et l'inclure dans le ConfigProvider!
const config = { // https://www.npmjs.com/package/emoji-picker-react
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


const EmojiPickerButton: React.FC<EmojiPickerProps> = ({ onSelect }) => {
    const [showEmojiPicker, setShowEmojiPicker] = useState(false);

    const handleSelectEmoji = (emoji: any) => {
        setShowEmojiPicker(false);
        onSelect(emoji.emoji);
    };

    return (
        <>
            <div style={{ position: 'relative' }}>
                <Button
                    style={{
                        width: 40,
                        height: 40,
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        backgroundColor: 'transparent',
                    }}
                    onClick={() => setShowEmojiPicker(!showEmojiPicker)}
                >
                    <FontAwesomeIcon icon={faSmile} style={{ paddingBottom: 5 }} />
                </Button>
                {showEmojiPicker && (
                    <div
                        style={{
                            position: 'absolute',
                            top: '100%',
                            left: 0,
                            transform: 'translateY(10px)',
                        }}
                    >
                        <EmojiPicker onEmojiClick={handleSelectEmoji} {...config} />
                    </div>
                )}
            </div>
        </>
    );
};

export default EmojiPickerButton;
