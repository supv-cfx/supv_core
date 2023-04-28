import {v4 as uuidv4} from 'uuid';

/**
 * Generate a random token for the server to use.
 * @returns {string} token
 */
const generateToken: string = uuidv4();

export const token: string = generateToken