consoleLog("Bubble Sort in JavaScript ");
var array = [8,1,7,4,6,5,9];

function sortBubble( array )
{
    for (var i = 0 ; i < array.length; i ++ )
    {
        var temp;
        for ( var j = i ; j > 0 ; j -- )
        {
            if ( array[j] < array [i] )
            {
                temp = array[j];
                array[j] = array[j - 1];
                array[j-1] = temp;
            }
        }//end for inner loop
    }//end for outer loop
    return array;
} //end bubble Sort

consoleLog("pre sorted array "  + array );
consoleLog("post sorted array "  + sortBubble(array) );