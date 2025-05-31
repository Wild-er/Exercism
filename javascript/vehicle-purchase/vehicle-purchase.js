// @ts-check
//
// The line above enables type checking for this file. Various IDEs interpret
// the @ts-check directive. It will give you helpful autocompletion when
// implementing this exercise.

/**
 * Determines whether or not you need a license to operate a certain kind of vehicle.
 *
 * @param {string} kind
 * @returns {boolean} whether a license is required
 */
export function needsLicense(kind) {
  if (kind === 'car' || kind === 'truck') {
    return true; 
  }
  return false; //  no license required, not  a vehicle
}

/**
 * Helps choosing between two options by recommending the one that
 * comes first in dictionary order.
 * @var {number} choice
 * @param {string} option1
 * @param {string} option2
 * @returns {string} a sentence of advice which option to choose
 */
export function chooseVehicle(option1, option2) {
  if (option1 < option2) { // See what is alphabetically first
    option2 = option1; // Set both options to that. We always use option 2
  } 
  return option2 + " is clearly the better choice."; // Option 2 is always the alphabetical 1st.
}

/**
 * Calculates an estimate for the price of a used vehicle in the dealership
 * based on the original price and the age of the vehicle.
 * < 3yrs old = 80% initial
 * Middle = 70%
 * > 10yrs = 50%
 *
 * @param {number} originalPrice
 * @param {number} age
 * @returns {number} expected resell price in the dealership
 */
export function calculateResellPrice(originalPrice, age) {
  if (age < 3) {
    return originalPrice * 0.8; // 80% of the price
  } 
  if ( age >= 10) {
    return originalPrice * 0.5; // 80% of the price
  }
  return originalPrice * 0.7 // 70% of the price.
  ;
}
