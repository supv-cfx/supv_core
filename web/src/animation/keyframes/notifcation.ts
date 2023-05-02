import { keyframes } from '@mantine/core'

type Animation = {
    [key: string]: {
        enter: any;
        exit: any;
    }
}

export const Top: Animation = {
    slide: {
        enter: keyframes({
            from: {
                opacity: 0,
                transform: 'translateY(-30px)',
            },
            to: {
                opacity: 1,
                transform: 'translateY(0px)',
            },
        }),
        exit: keyframes({
            from: {
                opacity: 1,
                transform: 'translateY(0px)',
            },
            to: {
                opacity: 0,
                transform: 'translateY(-100%)',
            },
        }),
    },
    slideInElliptic: {
        enter: keyframes({
            from: {
                transform: 'translateY(-600px) rotateX(-30deg) scale(0)',
                transformOrigin: '50% 100%',
                opacity: 0,
            },
            to: {
                transform: 'translateY(0) rotateX(0) scale(1)',
                transformOrigin: '50% 1400px',
                opacity: 1,
            },
        }),
        exit: keyframes({
            from: {
                transform: 'translateY(0) rotateX(0) scale(1)',
                transformOrigin: '50% 1400px',
                opacity: 1,
            },
            to: {
                transform: 'translateY(-600px) rotateX(-30deg) scale(0)',
                transformOrigin: '50% 100%',
                opacity: 0,
            },
        })

    },
}

export const Bottom: Animation = {
    slide: {
        enter: keyframes({
            from: {
                opacity: 0,
                transform: 'translateY(30px)',
            },
            to: {
                opacity: 1,
                transform: 'translateY(0px)',
            },
        }),
        exit: keyframes({
            from: {
                opacity: 1,
                transform: 'translateY(0px)',
            },
            to: {
                opacity: 0,
                transform: 'translateY(100%)',
            },
        })
    }
}

export const Left: Animation = {
    slide: {
        enter: undefined,
        exit: keyframes({
            from: {
                opacity: 1,
                transform: 'translateX(0px)',
            },
            to: {
                opacity: 0,
                transform: 'translateX(-100%)',
            },
        })
    }
}

export const Right: Animation = {
    slide: {
        enter: undefined,
        exit: keyframes({
            from: {
                opacity: 1,
                transform: 'translateX(0px)',
            },
            to: {
                opacity: 0,
                transform: 'translateX(100%)',
            },
        })
    }
}