// @ts-check
//
// The line above enables type checking for this file. Various IDEs interpret
// the @ts-check directive. It will give you helpful autocompletion when
// implementing this exercise.

/**
 * Calculates the total bird count.
 *
 * @var {number} c bird counter
 * @param {number[]} birdsPerDay
 * @returns {number} total bird count
 */
export function totalBirdCount(birdsPerDay) {
  let c = 0; // Stores the bird count
  for (let i = 0; i < birdsPerDay.length; i++) { // Cycle through all the days
    c += birdsPerDay[i]; // Add the bird count to the total
  }
  return c;
}

/**
 * Calculates the total number of birds seen in a specific week.
 *
 * @param {number[]} birdsPerDay
 * @param {number} week
 * @returns {number} birds counted in the given week
 */
export function birdsInWeek(birdsPerDay, week) {
  let c = 0; // Stores the bird count
  week = week * 7;
  for (let i = 0; i < week; i++) { // Cycle through all the days in that week
    c += birdsPerDay[i + week]; // Add the bird count to the total
  }
  return c;
}

/**
 * Fixes the counting mistake by increasing the bird count
 * by one for every second day.
 *
 * @param {number[]} birdsPerDay
 * @returns {number[]} corrected bird count data
 */
export function fixBirdCountLog(birdsPerDay) {
  for (let i = 1; i < birdsPerDay.length / 2; i++) { // Cycle every odd day
    birdsPerDay[i]++; // add one to that day
  }
    return birdsPerDay;
}
