//
// This is only a SKELETON file for the 'Gigasecond' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

/**
 * Date passed to us will be in milliseconds.
 * 
 * We need to find the day that is 1,000,000,000 ahead of that.
 * 
 * 1e+9 seconds = 1e+12 miliseconds
 * 
 * 
 * 
 * @param {*} date 
 * @returns {string} UTC date a gigasecond later
 */

export const gigasecond = (date) => {
  return Date.UTC(date + 1e+12); // Return the date a gigasecond later, in the UTC format expected
};
