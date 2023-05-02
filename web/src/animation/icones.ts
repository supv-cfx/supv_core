export const iconeAnimation = (anim: string) => {
    switch (anim) {
        case 'beat':
        case 'spin':
        case 'fade':
        case 'pulse':
        case 'shake':
        case 'tada':
        case 'flip':
            return true;
        default:
            return false;
    };
};