//
//  introViewController.m
//  javascriptIPad
//
//  Created by Matt Schmulen on 11/4/13.
//  Copyright (c) 2013 Matt Schmulen. All rights reserved.
//

#import "introViewController.h"

@interface introViewController ()

@property ( strong, nonatomic) NSArray *pages;

@end

@implementation introViewController
- (IBAction)actionClose:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupPages {
    
    //set up three pages, each with a different background color
    UIViewController *a = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    a.view.backgroundColor = [UIColor redColor];
    UIViewController *b = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    b.view.backgroundColor = [UIColor greenColor];
    UIViewController *c = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    c.view.backgroundColor = [UIColor blueColor];
    _pages = @[a, b, c];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (nil == viewController) {
        return _pages[0];
    }
    NSInteger idx = [_pages indexOfObject:viewController];
    NSParameterAssert(idx != NSNotFound);
    if (idx >= [_pages count] - 1) {
        // we're at the end of the _pages array
        return nil;
    }
    // return the next page's view controller
    return _pages[idx + 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (nil == viewController) {
        return _pages[0];
    }
    NSInteger idx = [_pages indexOfObject:viewController];
    NSParameterAssert(idx != NSNotFound);
    if (idx <= 0) {
        // we're at the end of the _pages array
        return nil;
    }
    // return the previous page's view controller
    return _pages[idx - 1];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPages];
    self.dataSource = self;
    
    // set the initially visible page's view controller... otherwise you won't see anything.
    [self setViewControllers:@[_pages[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
