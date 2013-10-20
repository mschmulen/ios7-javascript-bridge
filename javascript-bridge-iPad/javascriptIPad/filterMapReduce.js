consoleLog("Filter + Map + Reduce in JavaScript ");

var numbers = [8,1,7,4,6,5,9];

function oddNumber(element) {
    return element % 2;
}

var filtered = numbers.filter(oddNumber);

consoleLog( mappped );

var mappped = filtered.map(Math.sqrt);

consoleLog( mappped );



//[0, 1, 2, 3, 4].reduceRight(function(previousValue, currentValue, index, array) {
//                            return previousValue + currentValue;
//                           }, 10);

//var reduced = mappped.Reduce(Math.sqrt);
//consoleLog( reduced );


