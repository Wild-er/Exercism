// @ts-check
//
// The line above enables type checking for this file. Various IDEs interpret
// the @ts-check directive. It will give you helpful autocompletion when
// implementing this exercise.

/**
 * Determines how long it takes to prepare a certain juice.
 *
 * @param {string} name
 * @returns {number} time in minutes
 */
export function timeToMixJuice(name) {
  switch (name) { // Compare the name agains the options, or default if no match.
    case 'Pure Strawberry Joy': 
      return 0.5;
    case 'Energizer':
    case 'Green Garden':
      return 1.5;
    case 'Tropical Island': 
      return 3;
    case 'All or Nothing': 
      return 5;
    default: 
      return 2.5;
  }
}

/**
 * Calculates the number of limes that need to be cut
 * to reach a certain supply.
 *
 * @param {number} wedgesNeeded
 * @param {string[]} limes
 * @returns {number} number of limes cut
 */
export function limesToCut(wedgesNeeded, limes) {
  let c = 0;
  while (wedgesNeeded > 0) {
    switch (limes[0]) {
      case 'medium':
        wedgesNeeded -= 8; // 8 slices for a medium
      case 'large':
        wedgesNeeded -= 10; // 10 slices for a small lime
      case 'small': 
        wedgesNeeded -= 6; // 6 slices for a small lime
      default: 
        break;
    }
    limes.shift();// Remove the tested lime.
    c++; // 1 more lime is now cut
  }
  return c;
}

/**
 * Determines which juices still need to be prepared after the end of the shift.
 *
 * @param {number} timeLeft
 * @param {string[]} orders
 * @returns {string[]} remaining orders after the time is up
 */
export function remainingOrders(timeLeft, orders) {
  while (timeLeft > 0)  {
    timeLeft -= timeToMixJuice(orders[0]); // Subtract the amount of time to make the next order
    orders.shift(); // Remove the first order made
  }
  return orders;
}
