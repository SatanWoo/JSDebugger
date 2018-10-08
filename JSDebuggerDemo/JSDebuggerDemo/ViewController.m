//
//  ViewController.m
//  JSDebuggerDemo
//
//  Created by z on 2018/10/3.
//  Copyright © 2018年 SatanWoo. All rights reserved.
//

#import "ViewController.h"
#import "TestAssociateObject.h"
#import <JSDebugger/JSDebugger.h>
#import <objc/runtime.h>

@interface ViewController ()
{
    char *testStr;
}

@property (nonatomic, strong) UILabel *testLabel;
@property (nonatomic, strong) JDLocalFileObserver *fileWatcher;
@property (nonatomic, strong) TestAssociateObject *associateObject;
@property (nonatomic) int testInt;
@property (nonatomic) double testDouble;

//- (void)test:(NSNumber *)first,...NS_REQUIRES_NIL_TERMINATION;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[JDEngine engine] start];
    
    self.testLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 100, 150, 50)];
    self.testLabel.text = @"Try JSDebugger!";
    self.testLabel.textColor = [UIColor orangeColor];
    
    self.associateObject = [[TestAssociateObject alloc] init];
    
    self.associateObject.associateInt = 5;
    
    //id val = objc_getAssociatedObject(self.associateObject, (void *)@"assoicateKey");
    
    [self.view addSubview:self.testLabel];
    
    NSString *jsFilePathOnMac = @"/Users/z/Documents/Github/JSDebugger/JSDebuggerDemo/demo.js"; // @SatanWoo: There is one copy in your project
    
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [[JDEngine engine] evaluateScriptAtPath:[[NSBundle mainBundle] pathForResource:@"demo" ofType:@"js"]];
}


+ (void)test:(int)first,...NS_REQUIRES_NIL_TERMINATION
{
    va_list list;
    
    //遍历开始
    
    va_start(list, first);
    
    NSLog(@"base address is %p and value is %d", &first, first);
    
    int arg;
    
    while ((arg = va_arg(list, int))) {
        NSLog(@"当前参数:%d 地址:%p" , arg, &arg);
    }
    
    va_end(list);
}

+ (void)printNSArray:(NSArray *)array
{
    NSLog(@"array is %@", array);
}

- (void)printName:(NSString *)name
{
    NSLog(@"name is %@", name);
}

- (int *)allocAddressWithInt
{
    self.testInt = 20;
    return &_testInt;
}

- (double *)allocAddressWithDouble
{
    self.testDouble = 30.7;
    return &_testDouble;
}

- (char *)allocAddressWithChar
{
    testStr = "jkjskjsd\0";
    return testStr;
}

- (void)testDoublePointer:(double *)doubleP
{
    NSLog(@"value is %g", *doubleP);
}

- (void)testIntPointer:(int *)intP
{
    NSLog(@"value is %d", *intP);
}

- (void)testCString:(char *)charP
{
    NSLog(@"value is %s", charP);
}

- (void)print
{
    NSLog(@"self get assoicate int is %ld", (long)self.associateObject.associateInt);
}

- (void)printNumb:(NSNumber *)val
{
    NSLog(@"val is %@", val);
}

@end
