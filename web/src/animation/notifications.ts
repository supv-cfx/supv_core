import * as Animation from './keyframes/notifcation';

export const SelectAnime = (enterAnim:string|undefined, exitAnime: string|undefined, enterPos: string, exitPos: string, enterFrom: string|undefined, exitTo: string|undefined) => {
    let posEnter, posExit;
    switch (enterPos) {
        case 'top':
            posEnter = Animation.Top[!enterAnim ? 'slideInElliptic' : enterAnim].enter;
            switch (enterFrom) {
                case 'top':
                    posEnter = Animation.Top[!enterAnim ? 'slide' : enterAnim].enter;
                    break;
                case 'left':
                    posEnter = Animation.Left[!enterAnim ? 'slide' : enterAnim].enter;
                    break;
                case 'right':
                    posEnter = Animation.Right[!enterAnim ? 'slide' : enterAnim].enter;
                    break;
                default:
                    posEnter = Animation.Top[!enterAnim ? 'slideInElliptic' : enterAnim].enter;
                break;
            }
            break;
        case 'bottom':
            posEnter = Animation.Bottom[!enterAnim ? 'slide' : enterAnim].enter;
            break;
        case 'left':
            posEnter = Animation.Left[!enterAnim ? 'slide' : enterAnim].enter;
            break;
        case 'right':
            posEnter = Animation.Right[!enterAnim ? 'slide' : enterAnim].enter;
        break;
        default:
            posEnter = Animation.Top['slide'].enter;
        break;
    }

    switch (exitPos) {
        case 'top':
            posExit = Animation.Top[!exitAnime ? 'slideInElliptic' : exitAnime].exit;
            switch (exitTo) {
                case 'top':

                    break;

                case 'left':

                    break;
                case 'right':
                    posExit = Animation.Right[!exitAnime ? 'slide' : exitAnime].exit
                    break;
                default:

                break;
            }
            break;
        case 'bottom':
            posExit = Animation.Bottom[!exitAnime ? 'slide' : exitAnime].exit;
            break;
        case 'left':
            posExit = Animation.Left[!exitAnime ? 'slide' : exitAnime].exit;
            break;
        case 'right':
            posExit = Animation.Right[!exitAnime ? 'slide' : exitAnime].exit;
        break;
        default:
            posExit = Animation.Top['slideInElliptic'].exit;
        break;
    }

    return {posEnter, posExit};
}