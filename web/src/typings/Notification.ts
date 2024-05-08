import { CSSProperties } from 'react';
import { IconProp } from '@fortawesome/fontawesome-svg-core';
import { MantineColor, MantineGradient, MantineSize } from '@mantine/styles';
import { FontAwesomeIconProps } from '@fortawesome/react-fontawesome';

type IconStyle = {
  animation?: string;
  color?: CSSProperties;
  style?: CSSProperties;
}

export interface BadgeProps {
  type?: 'avatar' | 'icon'
  name?: IconProp;
  src?: string;
  alt?: string;
  color?: MantineColor | FontAwesomeIconProps['color'];
  size?: MantineSize | FontAwesomeIconProps['size'];
  style?: CSSProperties;
  animation?: 'beat' | 'fade' | 'flip' | 'spin' | 'pulse' | 'shake';
  text: string;
  radius?: MantineSize;
  variant?: 'filled' | 'outline' | 'light' | 'dot';
  position?: 'left' | 'right';
  mr?: number;
  ml?: number;
  mt?: number;
  mb?: number;
  m?: number;
  colorIcon?: MantineColor | FontAwesomeIconProps['color'];
  imageProps?: Record<string, any>;
  gradient?: MantineGradient;
}

export interface NotificationItemsProps {
	dur: number;
	id: string;
	visible?: boolean;
	data: NotificationProps;
}

export interface NotificationProps {
  image?: string;
  title?: string;
  id?: string;
  key?: number | string;
  description?: string;
  dur?: number | 3000; // default: 3000
  type?: string; 
  duration?: number | 3000; // default: 3000
  icon?: IconProp; // default: check on type
  color?: string; // default: check on type
  closable?: boolean; // default: false (not semi-implementation)
  border?: boolean; // default: false (not semi-implementation)
  iconStyle?: IconStyle;
  style?: CSSProperties;
  animation?: Animation;
  badge?: BadgeProps;
}

export interface Minimap {
  x: number;
  y: number;
  w: number;
  h: number;
  expanded: boolean;
}

export interface MinimapProps {
  name: 'x' | 'y' | 'w' | 'h' | 'expanded';
  value: number | boolean;
}

/*export type BadgeIconProps = {
  name: IconProp;
  color?: FontAwesomeIconProps['color'];
  size?: FontAwesomeIconProps['size'];
  style?: CSSProperties;
  animation?: 'beat' | 'fade' | 'flip' | 'spin' | 'pulse' | 'shake';
}

export type BadgeAvatarProps = {
  src: string;
  alt?: string;
  mr?: number;
  ml: number;
  mt?: number;
  mb?: number;
  m?: number;
  size?: MantineSize;
  variant?: 'outline' | 'light' | 'filled' | 'gradient'
  imageProps: Record<string, any>,
  radius?: MantineSize;
  gradient?: MantineGradient;
}

export interface BadgeSectionPropsAvatar {
  data: BadgeAvatarProps
}

export interface BadgeSectionPropsIcon {
  data: BadgeIconProps
}

type Animation = {
  enter: string;
  exit: string;
}

*/