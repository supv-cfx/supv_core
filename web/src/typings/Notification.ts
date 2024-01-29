import React from 'react';
import { ToastPosition } from 'react-hot-toast';
import { IconProp } from '@fortawesome/fontawesome-svg-core';

type Animation = {
  enter: string;
  exit: string;
}

type IconStyle = {
  animation?: string;
  color?: React.CSSProperties;
}

export interface NotificationProps {
  image?: string;
  title?: string;
  id?: string;
  key?: number | string;
  description?: string;
  dur?: number | 3000; // default: 3000
  type?: string; 
  duration: number | 3000; // default: 3000
  icon?: IconProp; // default: check on type
  position?: ToastPosition; // default: top-right
  color?: string; // default: check on type
  closable?: boolean; // default: false (not semi-implementation)
  border?: boolean; // default: false (not semi-implementation)
  iconStyle?: IconStyle;
  style?: React.CSSProperties;
  animation?: Animation;
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