//
//  ViewController.h
//  javascriptIPad
//
//  Created by Matt Schmulen on 10/2/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

//CBCentralManagerDelegate, CBPeripheralDelegate
@interface ViewController : UIViewController <CBPeripheralManagerDelegate>

- (void) logger:(NSString *)logMessage;

//Core BlueTooth
- (IBAction)actionConnect:(id)sender;
- (IBAction)actionPeripheral:(id)sender;

@end
