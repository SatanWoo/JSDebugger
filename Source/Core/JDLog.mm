//
//  JDFLog.m
//  JSDebugger
//
//  Created by JunyiXie on 3/10/2018.
//

#import "JDLog.h"
#import <fstream>

static std::ofstream _JDOut;
@implementation JDLog

+ (JDLog *)shared
{
  static dispatch_once_t onceToken;
  static JDLog *_log;
  dispatch_once(&onceToken, ^{
    _log = [[JDLog alloc] init];
  });
  return _log;
}

- (void)dealloc
{
    _JDOut.close();
}

- (instancetype)init {
  if (self = [super init]) {
    if ([_filePath isEqualToString:@""] || _filePath == nil) {
      _filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"JDOut.log"];
    }
    JDLog(@"JDOut.log path: %@",_filePath);
    _JDOut.open(_filePath.UTF8String,std::ios::out | std::ios::ate);
  }
  return self;
}

#pragma mark Log
- (void)outputLog:(NSString *)logstr {
  _JDOut << logstr.UTF8String << std::endl;
}

@end
