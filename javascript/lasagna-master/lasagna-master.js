/// <reference path="./global.d.ts" />
// @ts-check

/**
 * Implement the functions needed to solve the exercise here.
 * Do not forget to export them so they are available for the
 * tests. Here an example of the syntax as reminder:
 * @param minutes Amount of time left to cook
 * @returns {string} Cooking message
 *
 */
export function cookingStatus(minutes) {
if (minutes === 0) {
    return 'Lasagna is done.'
}
else if (minutes > 0) {
    return 'Not done, please wait.'
}
return 'You forgot to set the timer.'
 }

export function preperationTime(layers, time) {
    if (time) {
        return layers.length * time;
    }
    return layers.length * 2;
}
