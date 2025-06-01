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

/** 
 * Implement a function that calculates the prep
 * time of a lasagna based on layers and time to 
 * prep them.
 * 
 * @param {array} layers Layers by name
 * @param {number} time Time to prep each layer
 * @returns {number} 
 */
export function preparationTime(layers, time) {
    if (time) { // If time exists, TRUTHY
        return layers.length * time; 
    }
    return layers.length * 2; // if no time param, use the default of 2.
}

/**
 * Calculate the ingredient amounts of noodles and sauce in a lasagana layers list or recipe.
 * 
 * @param {array} layers 
 * @returns 
 */
export function quantities(layers) {
    let n = 0; // noodles count in g
    let s = 0; // sauce count in L
    for (let a in layers) {
        switch (layers[a]) {
            case 'noodles':
                n += 50;
                break;
            case 'sauce':
                s += 0.2;
                break;
        }
    }
    let o = {
        noodles: n,
        sauce: s
    }
    return o;
}

/**
 * Modify the personal list to add the secret ingredient.
 * The secret ingredient is the last element of their 
 * object.
 * 
 * @param {object} fList Friends list
 * @param {object} mList My list
 * 
 */
export function addSecretIngredient(fList, mList) {
    mList.push(fList[fList.length - 1]);
}

/**
 * 
 * @param {object} recipe // Recipe for 2
 * @param {number} portions // How many people you need to feed
 * @returns 
 */

export function scaleRecipe(recipe, portions) {
    const O = {}; // This is where we will make the final scaled recipe
    const S = portions / 2; //The recipe is for 2 people, so the scale needs to reflect that.
    for (let key in recipe) { // Go through all the key pairs
        O[key] = recipe[key] * S; // Add the key pair from the recipe with the scaler applied.
    }
    return O; 
}