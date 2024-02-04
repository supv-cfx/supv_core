// Will return whether the current environment is in a regular browser
// and not CEF
export const isEnvBrowser = (): boolean => !(window as any).invokeNative;

// Basic no operation function
export const noop = () => {};

// Math Random
export const MathRandom = (min?: number, max?: number) => {
  min = min || 0
  max = max || 100
  return Math.floor(Math.random() * (max - min + 1) + min)
};