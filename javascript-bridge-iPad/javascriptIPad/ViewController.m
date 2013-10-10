//
//  ViewController.m
//  javascriptIPad
//
//  Created by Matt Schmulen on 10/2/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textViewJavaScriptCode;
@property (weak, nonatomic) IBOutlet UITextView *textViewJavascriptConsoleOut;

//Current Context
@property (strong, nonatomic) JSContext *context;

@property (weak, nonatomic) IBOutlet UITextField *textFieldCommandTerminal;

//Core BlueTooth properties
@property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;
#define ADVERTISEMENT_NAME @"JavaScriptActivatedIBeacon"
#define SERVICE_ID         @"21451111-CC21-49C1-BCC1-B51A70111130"
#define CHARASTERISTIC_ID  @"B1DA1111-EE1D-1D11-1331-1B11E111D1C0"
#define MAX_MTU 20

@end

@implementation ViewController

static NSString *javaScriptCode = @"consoleLog(\"Lets run some JavaScript in our Native App ! \"); \n"
    " \n"
    "var stringArray = [\"Hello\",\"Objective-C\", \"Welcome\", \"JavaScript\"]; \n"
    "for (i=0;i< stringArray.length;i++) \n"
    "{ \n"
    "   consoleLog( stringArray[i] );\n"
    "} \n"
    " \n"
    "consoleLog(\" Change the Color of this View \"); \n"
    "setBackgroundColor(); \n"
    " \n";
    //"consoleLog(Lets run some JavaScript in our Native App ! \"); \n"
    //"advertiseAsiBeacon(\"JavaScriptiBeacon\",\"2145B0A7-CC2E-49C2-BCCA-B55A703CD030\"); \n"
    //" \n";

- (JSContext *) context
{
    if ( !_context) _context = [[JSContext alloc] init];
    return _context;
};

- (void) logger:(NSString *)logMessage
{
    
    NSLog(logMessage);
    
    [self.textViewJavascriptConsoleOut setText: [NSString stringWithFormat: @"%@\n%@", logMessage, self.textViewJavascriptConsoleOut.text] ];
}

- ( void) preLoadJavaScriptGlobalScopeVariablesAndFunctions
{
    //Preload Global JavaScript Variables and Functions
    
    //global variables
    self.context[@"version"] = @1;
    
    //global functions
    [self.context evaluateScript:@"var square = function(x) {return x*x;}"];
};

- ( void) preLoadObjectiveCBlockFunctions
{
    //consoleLog
    self.context[@"consoleLog"] = ^(NSString *message) {
        [self logger: message];
    };
    
    //execute factorial in native Obj-C , Logger(@"5! = %@", factorial(5) );
    self.context[@"factorial"] = ^(int x) {
        int factorial = 1;
        for (; x > 1; x--) {
            factorial *= x;
        }
        return factorial;
    };
    
    //UI stuff
    self.context[@"setBackgroundColor"] = ^()  // Logger(@"sum2 = %@", sum2(4,5)
    {
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *newColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        [self.view setBackgroundColor: newColor ];
    };
    
    //advertiseAsiBeacon( "JavaScript Activated IBeacon", "1111B0A7-CC11-49C2-BCCA-B55A703CD111" );
    self.context[@"advertiseAsiBeacon "] = ^(NSString *advertisementName, NSString *serviceID)
    {
        NSLog( @" advertisementName : %@", advertisementName );
        NSLog( @" serviceID : %@", serviceID );
        
        [self.peripheralManager startAdvertising:@{CBAdvertisementDataLocalNameKey: ADVERTISEMENT_NAME, CBAdvertisementDataServiceUUIDsKey: @[[CBUUID UUIDWithString:SERVICE_ID]]}];
    };
    
}

- ( void) executeJavaScriptInCodeWindow
{
    JSValue * value = [self.context evaluateScript: [[self textViewJavaScriptCode] text]];
    //[self logger: [ NSString stringWithFormat:@"JavaScript context return value : %@", value] ];
}

- ( void ) resetScriptContext
{
    NSLog(@"resetScriptContext");
    [self preLoadJavaScriptGlobalScopeVariablesAndFunctions];
    [self preLoadObjectiveCBlockFunctions];
}



//ACTIONS

- (IBAction)actionRefreshScriptList:(id)sender {
    NSLog(@"Referesh the scripts");
}

- (IBAction)actionCommandTerminal:(id)sender {
    
    if ( self.textFieldCommandTerminal != nil )
    {
        //NSLog(@"Executing Command Terminal %@", self.textFieldCommandTerminal.text);
        JSValue * value = [self.context evaluateScript:self.textFieldCommandTerminal.text];
        if ( value )
        [self logger: [ NSString stringWithFormat:@"%@", value] ];
        self.textFieldCommandTerminal.text = nil;
    }
}

- (IBAction)actionClearConsoleOut:(id)sender {
    
   //[[[self textViewJavascriptConsoleOut] text] initWithString:@"..."];
   self.textViewJavascriptConsoleOut.text = @"";
}

- (IBAction)actionExecute:(id)sender {

    //[self loadJavaScriptContextAndCode];
    [self executeJavaScriptInCodeWindow];
}

// BLE Stuff
- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service
                    error:(NSError *)error
{
    if (error != nil) {
        return;
    }
    
    NSLog(@"Start advertising.");
    [self.peripheralManager startAdvertising:@{CBAdvertisementDataLocalNameKey: ADVERTISEMENT_NAME,
                                               CBAdvertisementDataServiceUUIDsKey: @[[CBUUID UUIDWithString:SERVICE_ID]]}];
}


-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    
    if(peripheral.state ==  CBPeripheralManagerStatePoweredOn)
    {
        CBMutableService *service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:SERVICE_ID]
                                                                   primary:YES];
        self.transferCharacteristic =
        [[CBMutableCharacteristic alloc]
         initWithType:[CBUUID UUIDWithString:CHARASTERISTIC_ID]
         properties:CBCharacteristicPropertyNotify
         value:nil
         permissions:CBAttributePermissionsReadable];
        
        service.characteristics = @[self.transferCharacteristic];
        [self.peripheralManager addService:service];
    }
    else
    {
        NSLog(@"Peripheral Manager did change state");
    }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self resetScriptContext];
    [[self textViewJavaScriptCode] setText: javaScriptCode];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
