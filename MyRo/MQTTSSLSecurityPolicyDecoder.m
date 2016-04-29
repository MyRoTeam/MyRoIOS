//
// MQTTSSLSecurityPolicyDecoder.m
// MQTTClient.framework
//
// Copyright (c) 2013-2015, Christoph Krey
//

#import "MQTTSSLSecurityPolicyDecoder.h"

#ifdef LUMBERJACK
#define LOG_LEVEL_DEF ddLogLevel
#import <CocoaLumberjack/CocoaLumberjack.h>
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif
#else
#define DDLogVerbose NSLog
#define DDLogWarn NSLog
#define DDLogInfo NSLog
#define DDLogError NSLog
#endif

@interface MQTTSSLSecurityPolicyDecoder()
@property (nonatomic) BOOL securityPolicyApplied;

@end

@implementation MQTTSSLSecurityPolicyDecoder

- (instancetype)init {
    self = [super init];
    self.securityPolicy = nil;
    self.securityDomain = nil;
    
    return self;
}

- (BOOL)applySSLSecurityPolicy:(NSStream *)readStream withEvent:(NSStreamEvent)eventCode{
    if(!self.securityPolicy){
        return YES;
    }

    if(self.securityPolicyApplied){
        return YES;
    }

    SecTrustRef serverTrust = (__bridge SecTrustRef) [readStream propertyForKey: (__bridge NSString *)kCFStreamPropertySSLPeerTrust];
    if(!serverTrust){
        return NO;
    }

    self.securityPolicyApplied = [self.securityPolicy evaluateServerTrust:serverTrust forDomain:self.securityDomain];
    return self.securityPolicyApplied;
}

- (void)stream:(NSStream*)sender handleEvent:(NSStreamEvent)eventCode {
    
    if (eventCode &  NSStreamEventHasBytesAvailable) {
        DDLogVerbose(@"[MQTTCFSocketDecoder] NSStreamEventHasBytesAvailable");
        if (![self applySSLSecurityPolicy:sender withEvent:eventCode]){
            self.state = MQTTCFSocketDecoderStateError;
            self.error = [NSError errorWithDomain:@"MQTT"
                                             code:errSSLXCertChainInvalid
                                         userInfo:@{NSLocalizedDescriptionKey: @"Unable to apply security policy, the SSL connection is insecure!"}];
        }
    }
    
    [super stream:sender handleEvent:eventCode];
}

@end
