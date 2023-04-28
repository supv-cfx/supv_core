const exp: any = (global as any).exports;

import {token} from "./token";

/**
 * Generate a random token for the server to use.
 * @returns {string} token 
*/
exp('token', () => {
    return token;
});