// import React, { useState } from 'react';
// import EmojiPicker, { Theme } from 'emoji-picker-react';
// import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
// import { faSmile } from '@fortawesome/free-regular-svg-icons';
// import { Button, useMantineColorScheme } from '@mantine/core';
// import { useConfig } from '../../providers/ConfigProvider';
// import { ConfigEmojiPicker } from '../../dev/config';

// interface EmojiPickerProps {
//     onSelect: (emoji: Object) => void;
// }

// const EmojiPickerButton: React.FC<EmojiPickerProps> = ({ onSelect }) => {
//     const [showEmojiPicker, setShowEmojiPicker] = useState(false);
//     const {colorScheme} = useMantineColorScheme();
//     //const { config, setConfig } = useConfig();
//     const config = {
//       emojiPicker: ConfigEmojiPicker
//     }
//     const dark = colorScheme === 'dark';

//     const handleSelectEmoji = (emoji: any) => {
//         setShowEmojiPicker(false);
//         onSelect(emoji.emoji);
//     };

//     config.emojiPicker.theme = dark ? Theme.DARK : Theme.LIGHT;
    
//     let color: string = dark ? '#fff' : '#000';
//     //setConfig(config);
//     return (
//         <>
//             <div style={{ position: 'relative' }}>
//                 <Button
//                     style={{
//                         width: 40,
//                         height: 40,
//                         display: 'flex',
//                         alignItems: 'center',
//                         justifyContent: 'center',
//                         backgroundColor: 'transparent',
//                     }}
//                     onClick={() => setShowEmojiPicker(!showEmojiPicker)}
//                 >
//                     <FontAwesomeIcon icon={faSmile} style={{ paddingBottom: 5, color: color}} />
//                 </Button>
//                 {showEmojiPicker && (
//                     <div
//                         style={{
//                             position: 'absolute',
//                             top: '100%',
//                             left: 0,
//                             transform: 'translateY(10px)',
//                         }}
//                     >
//                         <EmojiPicker onEmojiClick={handleSelectEmoji} theme={config.emojiPicker.theme} {...config} />
//                     </div>
//                 )}
//             </div>
//         </>
//     );
// };

// export default EmojiPickerButton;
