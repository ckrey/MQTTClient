//
//  MQTTLog.m
//  MQTTClient
//
//  Created by Christoph Krey on 27/01/2026.
//
//

#import "MQTTLog.h"

@interface MQTTLog()
@property (nonatomic, nonnull, strong, readwrite) os_log_t os_log;
@end

@implementation MQTTLog
+ (MQTTLog *)sharedInstance {
    static dispatch_once_t once = 0;
    static id sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    self.os_log = os_log_create("de.ckrey", "MQTTClient");
    return self;
}

@end
