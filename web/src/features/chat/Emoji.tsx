import React, { useState } from 'react';
import EmojiPicker, { Theme } from 'emoji-picker-react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faSmile } from '@fortawesome/free-regular-svg-icons';
import { Button } from '@mantine/core';

interface EmojiPickerProps {
    onSelect: (emoji: Object) => void;
}

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
                        <EmojiPicker onEmojiClick={handleSelectEmoji} theme={Theme.DARK} />
                    </div>
                )}
            </div>
        </>
    );
};

export default EmojiPickerButton;
