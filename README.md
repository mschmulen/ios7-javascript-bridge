## Intro to Apple's new iOS7 native JavaScript bridge


Apple Support for a Native iOS Objective-C to JavaScript bridge is amazing for 3 reasons:

1. This gives developers direct access to JavaScript Bridge technology without leveraging 3rd party SDK’s such as Appcelerator, or Cordova (Phone Gap).
2. JavaScript is the first non Apple proprietary language (Objective-C ) to be supported in the Native iOS XCode tool chain.
3. It's very easy to get started.

You can checkout the WWDC introduction "Integrating JavaScript into Native Apps" session on [Apple's developer network] (https://developer.apple.com/wwdc/videos/?id=615 )

### Getting Started

If you want to see the technology in action you can download the sample project here https://github.com/mschmulen/ios7-javascript-bridge , and run it on your iPad device simulator.

![Image](screenshots/image1.png?raw=true)


You can change the JavaScript directly into the blue text field and select the "execute JavaScript code" button to run the code to see the technology in action.

The Sample Application preloads a UITextView with a JavaScript context and script and also adds some native Objective-C function blocks that you can call from within your JavaScript context.  You can edit the code in the app and execute your script on the device.

### Overview

iOS7 is the first iPhone and iPad operating system to officially support JavaScript as a mobile development language from Apples XCode tool chain.

Several other cross platform technology tools have been created over the years to provide similar functionality:

- [Appcelerator's Titanium ]( http://www.appcelerator.com ) provides a very similar bridge technology to build Native iOS Apps with JavaScript
- [Phone Gap's, Cordova]( http://cordova.apache.org ) popular hybrid bridge for using HTML views inside a native container
- [ImpactJS]( http://cordova.apache.org ) is a game oriented javascript bridge configuration.
- Even Zynga has a solution [jsbindings ] (https://github.com/zynga/jsbindings)
- Additional companies such as Xamarin and Ruby Motion do the same for C# and Ruby languages.  

Apples iOS7 support of JavaScript inline with your Objective-C code validates JavaScript as the leading ( and only ) non proprietary language that is supported within the iOS development environment by the device manufacturer.

At a high level JavaScriptCore allows for wrapping of standard JavaScript objects into Objective-C (the code used for iOS apps) and also allowing JavaScript to interact with native iOS objects and code.

## Overview of the JavaScriptCore API

The goals of the JavaScript bridge API according to Apple are to provide: Automatic, Safe and high fidelity use of JavaScript.  Three main classes that iOS developers can use to compose heterogeneous language native applications are JSVirtualMachine, [JSContext](https://developer.apple.com/library/mac/documentation/JavaScriptCore/Reference/JSContextRef_header_reference/Reference/reference.html#//apple_ref/doc/uid/TP40011494) and JSValue.

###JSVirtualMachine
the JSVirtualMachine class is a Light weight single thread JavaScript virtual machine.  Your app can instantiate multiple JS virtual machines in your app to support multithreading.

###JSContext
Within any given JSVirtualMachine you can have an arbitrary number of JSContexts allowing you to execute JavaScript scripts and give access to global objects.

###JSValue
	Strong Reference to a Javascript Value associated with a specific JSContext ( StrongReferenced to the JSContext it is associated or instantiated with)

A JSValue is immutable, so you can’t modify it in Objective-C ( similar to NSString ) so you cant change the value in your Objective-C code and expect it to be changed in yourJavaScript execution. Likewise, you can’t change the value of the variable a in JavaScript and expect your Objective-C JSValue to change. Each time a change is made, the value must be copied across the boundary of the two execution environments.

JSValue automatically wraps many JavaScript value types, including language primitives and object types.  There are some additional helper methods for common use cases such as NSArray and NSDictionary.

A listing of some of the supported objects that are automatically bridged for you:
- Objective-C type => JavaScript type
- id => Wrapper object 
- Class => Constructor object
- nil => undefined
- NSNull => null
- NSString => string
- NSNumber => number, boolean
- NSDictionary => Object object
- NSArray => Array object
- NSDate  => Date object
- NSBlock => Function object

### Simple Execution

Writing your first JavaScript is can be done in 2 lines of code:
1. Create a JavaScript context by allocating and initializing a new JSContext
2. Evaluate your JavaScript script code in the JSContext with the evaluate message

```objc
//#import <JavaScriptCore/JavaScriptCore.h>

JSContext *context = [[JSContext alloc] init];
JSValue *result = [context evaluateScript:@"2 + 8"];
NSLog(@"2 + 2 = %d", [result toInt32]);
```

### Objective-C → JavaScript

Surfacing native Objective-C Objects is also very simple, check out the Source code example to see how to make your Objective-C functional blocks available to your JavaScript script.

`
//execute factorial in native Obj-C , Logger(@"5! = %@", factorial(5) );
    self.context[@"factorial"] = ^(int x) {
        int factorial = 1;
        for (; x > 1; x--) {
            factorial *= x;
        }
        return factorial;
    };
`

The example surfaces 3 native functions:
- consoleLog
- factorial
- setBackgroundColor
- advertiseAsiBeacon

You can also surface custom Objective-C objects with the JSExport protocol to make the entire object available in you JavaScript Context.[Calling Objective-C Methods From JavaScript] (https://developer.apple.com/library/mac/documentation/AppleApplications/Conceptual/SafariJSProgTopics/Tasks/ObjCFromJavaScript.html)

### Whats Next

You can find detailed information regarding Memory Management, Threading and using JavaScriptCore with a WebView on the [Apple Developer portal] (https://developer.apple.com).

The combination of JavaScript support in your native iOS client and the proliferation of JavaScript server technology Node.js makes for exciting opportunities in "asymmetric" JavaScript code re-use for your native iOS App, web client and of course backend Node.js server.

If you make an interesting app leveraging the JavaScript Bridget make sure and post your links below so I can follow up.

If you have any questions on how JavaScript can accelerate your mobile development efforts drop us a line at [Node Republic] (http://strongloop.com/node-republic) !









