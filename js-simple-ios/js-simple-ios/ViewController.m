//
//  ViewController.m
//  js-simple-ios
//
//  Created by Matt Schmulen on 10/21/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "ViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textViewJavaScriptCode;
@property (weak, nonatomic) IBOutlet UITextView *textViewOutput;

@end

@implementation ViewController
- (IBAction)actionExecuteJavaScript:(id)sender {
    
    JSContext *context = [[JSContext alloc] init];
    JSValue *result = [context evaluateScript:self.textViewJavaScriptCode.text];
    
    //show the output of the evaluations
    NSLog(@"script output = %d", [result toInt32]);
    
    //clear and then show the output in the output text view
    self.textViewOutput.text = @"";
    [self.textViewOutput setText: [NSString stringWithFormat: @"%d", [result toInt32] ] ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *jsCode = @"2 + 7";
    self.textViewJavaScriptCode.text = jsCode;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
