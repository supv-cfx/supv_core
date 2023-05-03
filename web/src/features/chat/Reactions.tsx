import { useState } from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faSmile, faLaugh, faHeart, faThumbsUp, faAngry } from '@fortawesome/free-regular-svg-icons';

interface EmojiReactionProps {
  reactions: { [key: string]: number };
  onReactionClick: (reaction: string, operation: number) => void;
}

const EmojiReaction: React.FC<EmojiReactionProps> = ({ reactions, onReactionClick }) => {
  const [hoveredReaction, setHoveredReaction] = useState<string | null>(null);

  const handleReactionClick = (reaction: string) => {
    if (reactions[reaction]) {
      onReactionClick(reaction, -1);
    } else {
      onReactionClick(reaction, 1);
    }
  };

  const handleMouseEnter = (reaction: string) => {
    setHoveredReaction(reaction);
  };

  const handleMouseLeave = () => {
    setHoveredReaction(null);
  };

  const getReactionCount = (reaction: string) => {
    return reactions[reaction] || 0;
  };

  const getColor = (reaction: string) => {
    switch (reaction) {
      case 'thumbs-up':
        return reactions[reaction] || hoveredReaction === reaction ? '#007aff' : '#888';
      case 'heart':
        return reactions[reaction] || hoveredReaction === reaction ? '#ff4d4f' : '#888';
      case 'laugh':
        return reactions[reaction] || hoveredReaction === reaction ? '#ffd60a' : '#888';
      case 'angry':
        return reactions[reaction] || hoveredReaction === reaction ? '#ff5349' : '#888';
      default:
        return '#888';
    }
  };
  
  return (
    <div style={{ display: 'flex', alignItems: 'center', userSelect: 'none'}}>
      <FontAwesomeIcon
        icon={faThumbsUp}
        style={{ cursor: 'pointer', marginRight: 8 }}
        onClick={() => handleReactionClick('thumbs-up')}
        onMouseEnter={() => handleMouseEnter('thumbs-up')}
        onMouseLeave={handleMouseLeave}
        beat={hoveredReaction === 'thumbs-up'}
        color={getColor('thumbs-up')}
      />
      <span style={{ fontSize: '0.8em' }}>{getReactionCount('thumbs-up')}</span>
      <FontAwesomeIcon
        icon={faHeart}
        style={{ cursor: 'pointer', marginLeft: 8, marginRight: 8 }}
        onClick={() => handleReactionClick('heart')}
        onMouseEnter={() => handleMouseEnter('heart')}
        onMouseLeave={handleMouseLeave}
        beat={hoveredReaction === 'heart'}
        color={getColor('heart')}
      />
      <span style={{ fontSize: '0.8em' }}>{getReactionCount('heart')}</span>
      <FontAwesomeIcon
        icon={faLaugh}
        style={{ cursor: 'pointer', marginLeft: 8, marginRight: 8 }}
        onClick={() => handleReactionClick('laugh')}
        onMouseEnter={() => handleMouseEnter('laugh')}
        onMouseLeave={handleMouseLeave}
        beat={hoveredReaction === 'laugh'}
        color={getColor('laugh')}
      />
      <span style={{ fontSize: '0.8em' }}>{getReactionCount('laugh')}</span>
      <FontAwesomeIcon
        icon={faAngry}
        style={{ cursor: 'pointer', marginLeft: 8, marginRight: 8 }}
        onClick={() => handleReactionClick('angry')}
        onMouseEnter={() => handleMouseEnter('angry')}
        onMouseLeave={handleMouseLeave}
        beat={hoveredReaction === 'angry'}
        color={getColor('angry')}
      />
      <span style={{ fontSize: '0.8em' }}>{getReactionCount('angry')}</span>
    </div>
  );
};

export default EmojiReaction;
