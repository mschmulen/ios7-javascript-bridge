consoleLog("Filter in JavaScript ");

consoleLog("Creates a new array with all elements that pass the test implemented by the provided function.");

function oddNumber(element) {
    return element % 2;
}

var filtered = [8,1,7,4,6,5,9].filter(oddNumber);

consoleLog("filter result: " + filtered );