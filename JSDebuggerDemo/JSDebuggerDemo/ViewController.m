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

//- (void)test:(NSNumber *)first,...NS_REQUIRES_NIL_TERMINATION;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ViewController test:7, 8, 9, nil];
    
    [[JDEngine engine] start];
    
    /*
    
    NSNumber *number = [NSNumber numberWithInt:5];
    NSNumber *number2 = [NSNumber numberWithInt:20];
    NSNumber *number3 = [NSNumber numberWithInt:30];
    
    *(void **)address = (__bridge void *)number;
    *(void **)(address + sizeof(void *)) = (__bridge void *)number2;
    *(void **)(address + 2 * sizeof(void *)) = (__bridge void *)number3;
    
    [self test:(__bridge NSNumber *)(address), nil];*/
    
    
    void *address = malloc(sizeof(int) * 3);
    
    *(int *)address = 50;
    *(int *)(address + sizeof(int)) = 10;
    *(int *)(address + 2 * sizeof(int)) = 20;
    
    //[self printAddress:address];
    
    free(address);
    //NSArray *arr = [NSArray arrayWithObjects:@(1), @(2), @(3), nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[JDEngine engine] evaluateScriptAtPath:[[NSBundle mainBundle] pathForResource:@"demo" ofType:@"js"]];
    });
    
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

- (void)printAddress:(void *)address
{
    id n1 = (__bridge id)(*(void**)address);
    id n2 = (__bridge id)(*(void**)(address + sizeof(void *)));
    id n3 = (__bridge id)(*(void**)(address + 2 * sizeof(void *)));
    
    NSLog(@"number 1 is %@", n1);
                          
    NSLog(@"number 2 is %@", n2);
    NSLog(@"number 3 is %@", n3);
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

/*- (void)test:(NSNumber *)first,...NS_REQUIRES_NIL_TERMINATION
{
    va_list list;
    
    //遍历开始
    
    va_start(list, first);
    
    NSLog(@"base address is %p", &first);
    
    //知道读取到下一个时nil时结束递增
    
    for (NSNumber *str = first; str != nil; str = va_arg(list, NSNumber*)) {
        
        NSLog(@"%@",str);
        
    }
    
    //结束遍历
    
    va_end(list);
}*/

@end
