consoleLog("iOS7 supports JavaScript in our Native App !");

var stringArray = ["Hello","JavaScript", "From", "iOS7"];
for (i=0;i< stringArray.length;i++)
{
    consoleLog( stringArray[i] );
}

consoleLog("JavaScript code can call Native Objective-C methods ");

consoleLog("3 Obj-C methods have been made available in this JavaScript Context");

consoleLog(" 'consoleLog(string)' ");
consoleLog(" 'factorial(number)' ");
consoleLog(" 'setBackgroundColor(number)' ");

var factorialResult = factorial( 6 );
consoleLog( "6! = " + factorialResult );

consoleLog(" 'setBackgroundColor' will change the view background ");
setBackgroundColor();