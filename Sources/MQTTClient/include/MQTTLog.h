//
//  MQTTLog.h
//  MQTTClient
//
//  Created by Christoph Krey on 10.02.16.
//  Copyright © 2016-2026 Christoph Krey. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OSLog/OSLog.h>

@interface MQTTLog : NSObject
 
+ (MQTTLog * _Nonnull )sharedInstance;
@property (nonatomic, nonnull, strong, readonly) os_log_t os_log;

#ifdef DEBUG
#define MQTTLogDebug(format, ...) os_log_debug(MQTTLog.sharedInstance.os_log, format, ##__VA_ARGS__)
#else
#define MQTTLogDebug(format, ...)
#endif
#define MQTTLogInfo(format, ...) os_log_info(MQTTLog.sharedInstance.os_log, format, ##__VA_ARGS__)
#define MQTTLogDefault(format, ...) os_log(MQTTLog.sharedInstance.os_log, format, ##__VA_ARGS__)
#define MQTTLogError(format, ...) os_log_error(MQTTLog.sharedInstance.os_log, format, ##__VA_ARGS__)
#define MQTTLogFault(format, ...) os_log_fault(MQTTLog.sharedInstance.os_log, format, ##__VA_ARGS__)

@end
