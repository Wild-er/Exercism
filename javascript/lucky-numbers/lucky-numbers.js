// @ts-check

/**
 * Calculates the sum of the two input arrays.
 *
 * @param {number[]} array1
 * @param {number[]} array2
 * @returns {number} sum of the two arrays
 */
export function twoSum(array1, array2) {
  return Number(String(array1.join(''))) + Number(String(array2.join(''))); // Make the arrays strings while joining them, convert to numbers, add them.
}

/**
 * Checks whether a number is a palindrome.
 *
 * @param {number} value
 * @returns {boolean} whether the number is a palindrome or not
 */
export function luckyNumber(value) {
  let s = String(value); // Make it a string so we can work with it easily
  return s === s.split('').reverse().join(''); // Split the string into an array of chars, Reverse the order, join it back togethers to a string. OG s === s if palindrome
}

/**
 * Determines the error message that should be shown to the user
 * for the given input value.
 *
 * @param {string|null|undefined} input
 * @returns {string} error message
 */
export function errorMessage(input) {
  let n = Number(input);
  if (n < 0 || n > 0 ) { // valid number
    return '';
  }
  else if (input === null || input === undefined || input === '') { // Check for an empty field
    return 'Required field';
  }
  return 'Must be a number besides 0' // bad input
}
