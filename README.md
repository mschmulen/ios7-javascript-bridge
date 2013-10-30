
![Image](https://github.com/mschmulen/ios7-javascript-bridge/blob/master/screenshots/splash700x400.png?raw=true)


### A Brief History of JavaScript Bridges in Mobile

In 2009 [Appcelerator's Titanium ]( http://www.appcelerator.com ) 0.8 Version changed from a 'Hybrid web container' based approach similar to 
[Phone Gap / Cordova]( http://cordova.apache.org ) 
to full 'Native binding'. The change required Titanium developers to re-architect their code and remove HTML as the top-level implementation.  Developers wrote their app’s in pure JavaScript.  The value to developers and Appcelerator is Titanium JavaScript applications running on iOS ( and eventually Android) could get nearly all of the benefits of applications written in native Objective-C without having to learn Objective-C.

The technology strategy was a smashing success for the following reasons:

- Appcelerator did not redefine the native iPhone look and feel  

Titanium Apps leveraged Apples native Human Interface Guideline ( HIG ).  The iPhones Look and Feel was a major differentiator and the first 'feature' a user saw when opening the mobile app.  Look and feel was core to the iPhones success, and the applications that conformed to it.  Since Titanium controls and components matched nearly one for one with the equivalent iOS libraries ( ti.label = UILabel, ti.TableView = UITableView ) Titanium iOS apps were nearly indistinguishable from their native counterparts.

- The JavaScript Bridge strategy was then implemented on other mobile device's (Android soon followed originally leveraging Rhino and then later V8, and later Blackberry and Tizen). 

This gave developers a unified open language to build applications with and opened the door for code-reuse across the 2 leading mobile platforms; without sacrificing features.

- Titanium SDK could be extended to support additional native features and components. Since the bridge binding technology was open; developers could extend the platform and give access to additional features that Appcelerator did not support, such as access to CoreData or BlueTooth;

The Appcelerator community exploded and the number of ‘Powered by Titanium’ Apps proliferated.

Today Appcelerator is not alone in this Strategy.  [Xamarin Mono ](http://www.xamarin.com) has an implementation that binds at the CLR level; giving C# developers the same benefits.  [Ruby Motion](http://www.rubymotion.com/) does the same for Ruby developers.  The popular gaming platform Unity provides similar access without needing to write native language apps. Node.js binds to the server with V8 runtime at the core LibUV libraries.

JavaScript Bridges are powerful, because they give developer communities access and the opportunity for code reuse.

Apple's iOS7 is the first iOS operating system to officially support JavaScript as a mobile development language in Apples XCode tool chain.

Apple's iOS7 support of JavaScript inline with your Objective-C code validates JavaScript as the leading (and only) non proprietary language that is supported within the iOS development environment by the device manufacturer.

### Apple Support for a Native iOS Objective-C to JavaScript bridge is amazing for 3 reasons

1. Gives developers direct access to JavaScript Bridge technology without leveraging 3rd party SDK’s such as Appcelerator, or Cordova (Phone Gap).
2. JavaScript is the first non Apple proprietary language (Objective-C ) to be supported in the Native iOS XCode tool chain.
3. It's easy to get started, and composites well with Objective-C language apps.

You can checkout the WWDC introduction "Integrating JavaScript into Native Apps" session on [Apple's developer network] (https://developer.apple.com/wwdc/videos/?id=615 )

At a high level JavaScriptCore allows for wrapping of standard JavaScript objects into Objective-C (the code used for iOS apps) and also allowing JavaScript to interact with native iOS objects and code.

### Getting Started

If you want to see the technology in action you can download the sample project here [iOS7 Native JavaScript iPad app](https://github.com/mschmulen/ios7-javascript-bridge) , and run it on your iPad device simulator.


####iOS7 Native JavaScript iPad App

![Image](https://github.com/mschmulen/ios7-javascript-bridge/raw/master/screenshots/image1.png?raw=true)

You can change the JavaScript directly in the green text field and select the "execute JavaScript code" button to run the code to see your JavaScript execute in the Native iOS7 bridge.

The Sample Application preloads a UITextView with a JavaScript context and script and also adds some native Objective-C function blocks that you can call from within your JavaScript context.  You can edit the code in the app and execute your script on the device.

## Overview of the JavaScriptCore API

According to Apple, the goal of the JavaScript bridge API is to provide automatic, safe and high fidelity use of JavaScript.  Three main classes that iOS developers can use to compose heterogeneous language native applications are JSVirtualMachine, [JSContext](https://developer.apple.com/library/mac/documentation/JavaScriptCore/Reference/JSContextRef_header_reference/Reference/reference.html#//apple_ref/doc/uid/TP40011494) and JSValue.

###JSVirtualMachine
The JSVirtualMachine class is a Light weight single thread JavaScript virtual machine.  Your app can instantiate multiple JS virtual machines in your app to support multi-threading.

###JSContext
Within any given JSVirtualMachine you can have an arbitrary number of JSContexts allowing you to execute JavaScript scripts and give access to global objects.

###JSValue

JSValue is a strong reference to a JavaScript value in a specific JS Context ( StrongReferenced to the JSContext it is associated or instantiated with)

A JSValue is immutable, so you can’t modify it in Objective-C ( similar to NSString ) and therefore you cant change the value in your Objective-C code and expect it to be changed in yourJavaScript execution. Likewise, changes to Objective-C values in JavaScript must be copied across the bridge boundry of the two execution environments.

JSValue automatically wraps many JavaScript value types, including language primitives and object types.  There are some additional helper methods for common use cases such as NSArray and NSDictionary.

A listing of some of the supported objects that are automatically bridged for you.

- Objective-C type = JavaScript type
- id = Wrapper object 
- Class = Constructor object
- nil = undefined
- NSNull = null
- NSString = string
- NSNumber = number, boolean
- NSDictionary = Object object
- NSArray = Array object
- NSDate = Date object
- NSBlock = Function object

### Simple Execution

Writing your first JavaScript can be done in as little as 2 lines of code:

1. Create a JavaScript context by allocating and initializing a new JSContext.
1. Evaluate your JavaScript script code in the JSContext with the evaluate message.

```objc
//#import <JavaScriptCore/JavaScriptCore.h>

JSContext *context = [[JSContext alloc] init];
JSValue *result = [context evaluateScript:@"2 + 8"];
NSLog(@"2 + 8 = %d", [result toInt32]);
```

### Objective-C → JavaScript

Surfacing native Objective-C Objects is also very simple. Check out the Source Code example to see how to make your Objective-C functional blocks available to your JavaScript script.

```objc
//execute factorial in native Obj-C , Logger(@"5! = %@", factorial(5) );
    self.context[@"factorial"] = ^(int x) {
        int factorial = 1;
        for (; x > 1; x--) {
            factorial *= x;
        }
        return factorial;
    };
```

The [JavaScript iPad example](https://github.com/mschmulen/ios7-javascript-bridge/tree/master/javascript-bridge-iPad) surfaces 3 native functions:

- [consoleLog](https://github.com/mschmulen/ios7-javascript-bridge/blob/master/javascript-bridge-iPad/javascriptIPad/ViewController.m#L83)
- [factorial](https://github.com/mschmulen/ios7-javascript-bridge/blob/master/javascript-bridge-iPad/javascriptIPad/ViewController.m#L88)
- [setBackgroundColor](https://github.com/mschmulen/ios7-javascript-bridge/blob/master/javascript-bridge-iPad/javascriptIPad/ViewController.m#L97)

You can also surface custom Objective-C objects with the JSExport protocol to make the entire object available in you JavaScript Context.(Calling Objective-C Methods From JavaScript)[https://developer.apple.com/library/mac/documentation/AppleApplications/Conceptual/SafariJSProgTopics/Tasks/ObjCFromJavaScript.html]

### Wrapping Up

You can find detailed information regarding Memory Management, Threading and Using JavaScriptCore with a WebView at the Apple Developer documentation.

The combination of JavaScript support in your native iOS client and the proliferation of JavaScript server technology Node.js makes for exciting opportunities in "asymmetric" JavaScript code re-use for your native iOS App, web client and of course backend Node.js server.

If you make an interesting app leveraging the JavaScript Bridge make sure and post your links below so I can follow up.

If you have any questions on how JavaScript can accelerate your mobile development efforts drop us a line at [Node Republic] (http://strongloop.com/node-republic) !








