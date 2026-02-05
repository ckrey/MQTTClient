//
//  MQTTTransport.m
//  MQTTClient
//
//  Created by Christoph Krey on 05.01.16.
//  Copyright © 2016-2025 Christoph Krey. All rights reserved.
//

#import "MQTTTransport.h"

#import "MQTTLog.h"

@implementation MQTTTransport
@synthesize state;
@synthesize runLoop;
@synthesize runLoopMode;
@synthesize delegate;
@synthesize host;
@synthesize port;
@synthesize allowUntrustedCertificates;
@synthesize certificates;
@synthesize tls;

- (instancetype)init {
    self = [super init];
    self.state = MQTTTransportCreated;
    self.runLoop = [NSRunLoop currentRunLoop];
    self.runLoopMode = NSRunLoopCommonModes;
    self.host = @"localhost";
    self.port = 1883;
    self.tls = false;
    self.allowUntrustedCertificates = false;
    self.certificates = nil;

    return self;
}

- (void)open {
    MQTTLogError("MQTTTransport is abstract class");
}

- (void)close {
    MQTTLogError("MQTTTransport is abstract class");
}

- (BOOL)send:(NSData *)data {
    MQTTLogError("MQTTTransport is abstract class");
    return FALSE;
}

+ (NSArray *)clientCertsFromP12:(NSString *)path passphrase:(NSString *)passphrase {
    if (!path) {
        MQTTLogDefault("[MQTTTransport] no p12 path given");
        return nil;
    }

    NSData *pkcs12data = [[NSData alloc] initWithContentsOfFile:path];
    if (!pkcs12data) {
        MQTTLogDefault("[MQTTTransport] reading p12 failed");
        return nil;
    }

    if (!passphrase) {
        MQTTLogDefault("[MQTTTransport] no passphrase given");
        return nil;
    }
    CFArrayRef keyref = NULL;
    OSStatus importStatus = SecPKCS12Import((__bridge CFDataRef)pkcs12data,
                                            (__bridge CFDictionaryRef)@{(__bridge id)kSecImportExportPassphrase: passphrase},
                                            &keyref);
    if (importStatus != noErr) {
        MQTTLogDefault("[MQTTTransport] Error while importing pkcs12 [%d]", (int)importStatus);
        return nil;
    }

    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(keyref, 0);
    if (!identityDict) {
        MQTTLogDefault("[MQTTTransport] could not CFArrayGetValueAtIndex");
        return nil;
    }

    SecIdentityRef identityRef = (SecIdentityRef)CFDictionaryGetValue(identityDict,
                                                                      kSecImportItemIdentity);
    if (!identityRef) {
        MQTTLogDefault("[MQTTTransport] could not CFDictionaryGetValue");
        return nil;
    };

    SecCertificateRef cert = NULL;
    OSStatus status = SecIdentityCopyCertificate(identityRef, &cert);
    if (status != noErr) {
        MQTTLogDefault("[MQTTTransport] SecIdentityCopyCertificate failed [%d]", (int)status);
        return nil;
    }

    NSArray *clientCerts = @[(__bridge id)identityRef, (__bridge id)cert];
    return clientCerts;
}

@end
