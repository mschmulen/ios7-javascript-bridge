//
//  ViewController.m
//  javascriptIPad
//
//  Created by Matt Schmulen on 10/2/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "ViewController.h"
#import "JavaScriptCodeBlock.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableViewJavaScriptCodeBlocks;
@property (weak, nonatomic) IBOutlet UITextView *textViewJavaScriptCode;
@property (weak, nonatomic) IBOutlet UITextView *textViewJavascriptConsoleOut;

@property ( strong, nonatomic) NSMutableArray *tableData;

//Current Context
@property (strong, nonatomic) JSContext *context;

//Current javaScriptCode
@property (strong, nonatomic) JavaScriptCodeBlock *currentJavaScriptCode;

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

- (NSMutableArray *) tableData
{
    if ( !_tableData){
        
        _tableData = [[NSMutableArray alloc] init];
        
        JavaScriptCodeBlock *blockIntro = [JavaScriptCodeBlock alloc];
        blockIntro.name = @"intro";
        blockIntro.javaScriptSourceFile = @"intro";
        [_tableData addObject:blockIntro];
        
        JavaScriptCodeBlock *blockFilter = [JavaScriptCodeBlock alloc];
        blockFilter.name = @"filter";
        blockFilter.javaScriptSourceFile = @"filter";
        [_tableData addObject:blockFilter];
        
        JavaScriptCodeBlock *blockMap = [JavaScriptCodeBlock alloc];
        blockMap.name = @"map";
        blockMap.javaScriptSourceFile = @"map";
        [_tableData addObject:blockMap];
        
        JavaScriptCodeBlock *blogFilterMap = [JavaScriptCodeBlock alloc];
        blogFilterMap.name = @"filter + map";
        blogFilterMap.javaScriptSourceFile = @"filterMap";
        [_tableData addObject:blogFilterMap];
       
        JavaScriptCodeBlock *blockReduce = [JavaScriptCodeBlock alloc];
        blockReduce.name = @"reduce";
        blockReduce.javaScriptSourceFile = @"reduce";
        [_tableData addObject:blockReduce];
        
        JavaScriptCodeBlock *blockFilterMapReduce = [JavaScriptCodeBlock alloc];
        blockFilterMapReduce.name = @"filter + map + reduce";
        blockFilterMapReduce.javaScriptSourceFile = @"filterMapReduce";
        [_tableData addObject:blockFilterMapReduce];
        
        /*
        JavaScriptCodeBlock *block2 = [JavaScriptCodeBlock alloc];
        block2.name = @"sortBubble";
        block2.javaScriptSourceFile = @"sortBubble";
        [_tableData addObject:block2];
        
        JavaScriptCodeBlock *block3 = [JavaScriptCodeBlock alloc];
        block3.name = @"sortMerge";
        block3.javaScriptSourceFile = @"sortMerge";
        [_tableData addObject:block3];
        
        JavaScriptCodeBlock *block4 = [JavaScriptCodeBlock alloc];
        block3.name = @"insertion sort";
        block3.javaScriptSourceFile = @"sortInsertion";
        [_tableData addObject:block4];

        JavaScriptCodeBlock *block5 = [JavaScriptCodeBlock alloc];
        block3.name = @"selection sort";
        block3.javaScriptSourceFile = @"sortSelection";
        [_tableData addObject:block5];
        
        JavaScriptCodeBlock *block6 = [JavaScriptCodeBlock alloc];
        block3.name = @"binary tree";
        block3.javaScriptSourceFile = @"dataStructureBinaryTree";
        [_tableData addObject:block6];

        JavaScriptCodeBlock *block7 = [JavaScriptCodeBlock alloc];
        block3.name = @"heap";
        block3.javaScriptSourceFile = @"dataStructureHeap";
        [_tableData addObject:block7];
        
        JavaScriptCodeBlock *blockλ = [JavaScriptCodeBlock alloc];
        block.name = @"λ";
        block3.javaScriptSourceFile = @"λ";
        [_tableData addObject:block];
         */
        
    }
    return _tableData;
};


- (JSContext *) context
{
    if ( !_context) _context = [[JSContext alloc] init];
    return _context;
};

- (void) logger:(NSString *)logMessage
{
    //NSLog(logMessage);
    [self.textViewJavascriptConsoleOut setText: [NSString stringWithFormat: @"%@\n%@", self.textViewJavascriptConsoleOut.text, logMessage] ];
    
    //set the console out to the bottom of the view
    //CGRect caretRect = [self.textViewJavascriptConsoleOut caretRectForPosition:self.textViewJavascriptConsoleOut.endOfDocument];
    //[self.textViewJavascriptConsoleOut scrollRectToVisible:caretRect animated:YES];
}

- (NSString *) loadCurrentJavaScriptCodeFromFile
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:self.currentJavaScriptCode.javaScriptSourceFile ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    
    //set the text in the view
    [[self textViewJavaScriptCode] setText: jsCode ];
    //clear the consoleOut
    self.textViewJavascriptConsoleOut.text = @"";
    
    return jsCode;
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
}

- ( void) evaluateJavaScriptInCodeWindow
{
    JSValue * value = [self.context evaluateScript: [[self textViewJavaScriptCode] text]];
    //[self logger: [ NSString stringWithFormat:@"JavaScript context return value : %@", value] ];
    
    //set the console out to the bottom of the view
    CGRect caretRect = [self.textViewJavascriptConsoleOut caretRectForPosition:self.textViewJavascriptConsoleOut.endOfDocument];
    [self.textViewJavascriptConsoleOut scrollRectToVisible:caretRect animated:YES];
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
   self.textViewJavascriptConsoleOut.text = @"";
}

- (IBAction)actionExecute:(id)sender {
    [self evaluateJavaScriptInCodeWindow];
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


// UITableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [[ [self.tableData objectAtIndex:indexPath.row] class] isSubclassOfClass:[JavaScriptCodeBlock class]])
    {
        JavaScriptCodeBlock *model = (JavaScriptCodeBlock *)[self.tableData objectAtIndex:indexPath.row];
        self.currentJavaScriptCode = model;
        
        [self loadCurrentJavaScriptCodeFromFile];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if ( [[ [self.tableData objectAtIndex:indexPath.row] class] isSubclassOfClass:[JavaScriptCodeBlock class]])
    {
        JavaScriptCodeBlock *model = (JavaScriptCodeBlock *)[self.tableData objectAtIndex:indexPath.row];
        cell.textLabel.text = model.name;
    }
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self resetScriptContext];
    
    self.currentJavaScriptCode = [self.tableData objectAtIndex:0];
    
    //turn of Auto Correct
    [[self textViewJavaScriptCode] setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [self loadCurrentJavaScriptCodeFromFile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
