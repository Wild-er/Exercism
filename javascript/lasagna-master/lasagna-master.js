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

export function addSecretIngredient(fList, mList) {
    mList.push(fList[fList.length - 1]);
}

export function scaleRecipe(recipe, portions) {
    for (let i in recipe) {
        recipe[i] *= portions;
    }
    return recipe;
}