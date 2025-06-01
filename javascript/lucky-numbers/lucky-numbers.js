// @ts-check

/**
 * Calculates the sum of the two input arrays.
 *
 * @param {number[]} array1
 * @param {number[]} array2
 * @returns {number} sum of the two arrays
 */
export function twoSum(array1, array2) {
  return Number(String(array1.join(''))) + Number(String(array1.join('')));
}

/**
 * Checks whether a number is a palindrome.
 *
 * @param {number} value
 * @returns {boolean} whether the number is a palindrome or not
 */
export function luckyNumber(value) {
  let s = String(value);
  let l = s.length; // length of the array
  let p1 = []; // first part of the palindrome
  let p2 = []; // second part fot he palindrome
  for (let a = 0; a < l / 2; a++) { // Take the first half
      p1.push(s[a]);
  }
  for (let a = l / 2; a < l; a++) { // Take the 2nd half
      p2.unshift(s[a]);
  }
  return p1 === p2; // Return a truthy value
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
  if (n < 0 || n > 0 ) {
    return '';
  }
  else if (input === null || input === undefined) {
    return 'Required field';
  }
  return 'Must be a number besides 0'
}
