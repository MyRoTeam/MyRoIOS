//
//  KeychainWrapper.m
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

#import "KeychainWrapper.h"

@interface KeychainWrapper()

@property (nonatomic) NSString *service;
@property (nonatomic) NSString *group;

@end

@implementation KeychainWrapper

+ (KeychainWrapper *)sharedKeychain {
    static dispatch_once_t onceToken = 0;
    static KeychainWrapper *keychain = nil;
    
    dispatch_once(&onceToken, ^{
        keychain = [[KeychainWrapper alloc] initWithGroup:nil];
    });
    
    return keychain;
}

static NSString *const kServiceName = @"MyRo";

- (instancetype)initWithGroup:(NSString *)group
{
    if (self = [super init]) {
        self.service = kServiceName;
        
        if (group)
            self.group = group;
    }
    
    return self;
}

- (NSMutableDictionary *)prepareDictionaryForKey:(NSString *)key
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:(__bridge id)kSecClassGenericPassword
                   forKey:(__bridge id)kSecClass];
    
    NSData *itemID = [key dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:itemID forKey:(__bridge id)kSecAttrGeneric];
    [dictionary setObject:itemID forKey:(__bridge id)kSecAttrAccount];
    [dictionary setObject:self.service forKey:(__bridge id)kSecAttrService];
    //[dictionary setObject:(__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly
    //               forKey:(__bridge id)kSecAttrAccessible];
    
    if (self.group) {
        [dictionary setObject:self.group forKey:(__bridge id)kSecAttrAccessGroup];
    }
    
    return dictionary;
}

- (void)setData:(NSData *)data
         forKey:(NSString *)key
{
    NSMutableDictionary *dictionary = [self prepareDictionaryForKey:key];
    [dictionary setObject:data
                   forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    
    if (status == errSecDuplicateItem) {
        [dictionary removeObjectForKey:(__bridge id)kSecValueData];
        OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)dictionary, (__bridge CFDictionaryRef)@{ (__bridge id)kSecValueData : data });
        
        if (status != errSecSuccess) {
            NSLog(@"Error Saving Item To Keychain");
        }
    } else {
        NSLog(@"Error Saving Item To Keychain");
    }
}

- (NSData *)dataForKey:(NSString *)key
{
    NSMutableDictionary *dictionary = [self prepareDictionaryForKey:key];
    
    [dictionary setObject:(__bridge id)kSecMatchLimitOne
                   forKey:(__bridge id)kSecMatchLimit];
    [dictionary setObject:(__bridge id)kCFBooleanTrue
                   forKey:(__bridge id)kSecReturnData];
    
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)dictionary, &result);
    if (status != errSecSuccess) {
        NSLog(@"STATUS: %d", status);
        NSLog(@"Error Retrieving Item For Key: %@", key);
        return nil;
    }
    
    return (__bridge NSData *)result;
}

@end
