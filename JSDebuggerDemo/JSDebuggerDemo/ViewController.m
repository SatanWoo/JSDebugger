//
//  ViewController.m
//  JSDebuggerDemo
//
//  Created by z on 2018/10/3.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "ViewController.h"
#import <JSDebugger/JSDebugger.h>

@interface ViewController ()
@property (nonatomic, strong) UILabel *testLabel;
@property (nonatomic, strong) JDLocalFileObserver *fileWatcher;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[JDEngine engine] start];
    
    self.testLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 100, 150, 50)];
    self.testLabel.text = @"Try JSDebugger!";
    self.testLabel.textColor = [UIColor orangeColor];
    
    [self.view addSubview:self.testLabel];
    
    NSString *jsFilePathOnMac = @"/Users/z/Desktop/test/demo.js"; // @SatanWoo: There is one copy in your project
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:jsFilePathOnMac]) {
        self.fileWatcher = [[JDLocalFileObserver alloc] initWithFilePath:jsFilePathOnMac changeBlock:^{
            NSLog(@"[mingyi]::found mac wzq.js change");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[JDEngine engine] evaluateScriptAtPath:jsFilePathOnMac];
            });
        }];
        [self.fileWatcher start];
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)printNSArray:(NSArray *)array
{
    NSLog(@"array is %@", array);
}


@end
