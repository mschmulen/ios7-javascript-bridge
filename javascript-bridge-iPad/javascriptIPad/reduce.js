consoleLog(" reduce in JavaScript ");

consoleLog("Apply a function against an accumulator and each value of the array (from left-to-right) as to reduce it to a single value.");

var reduced = [8,1,7,4,6,5,9].reduce(
    function(previousValue, currentValue, index, array){
      return previousValue + currentValue;
    });

consoleLog( reduced );

