consoleLog("Lets run some JavaScript in our Native App ! ");

consoleLog("How about a simple JavaScript Algorithm ");

var stringArray = ["Hello","Objective-C", "Welcome", "JavaScript"];
for (i=0;i< stringArray.length;i++)
{
    consoleLog( stringArray[i] );
}

var factorialResult = factorial( 6 );
consoleLog( "6! = " + factorialResult );


consoleLog(" Change the Color of this View ");
setBackgroundColor();