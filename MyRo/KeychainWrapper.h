//
//  KeychainWrapper.h
//
//  Created by Aadesh Patel.
//  Copyright (c) 2016 Aadesh Patel. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Wrapper class for keychain cache storage and retrieval
@interface KeychainWrapper : NSObject

/// Shared instance of keychain for the application
+ (KeychainWrapper *)sharedKeychain;

/**
 Initializes an instance of keychain with the supplied group name
 
 - parameter group: Group name for keychain
 
 - returns: Instance of keychain
 */
- (instancetype)initWithGroup:(NSString *)group;

/**
 Saves data to keychain cache for the given key
 
 @param key Unique key that maps to the supplied data
 @param data Data to be stored for the unique key provided
 */
- (void)setData:(NSData *)data
         forKey:(NSString *)key;

/**
 Attempts to retrieve data from keychain cache for the supplied key
 
 @param key Key to retrieve the data for
 
 @returns NSData object that the supplied key maps to. But if the key does not exist
            then it will return nil
 */
- (NSData *)dataForKey:(NSString *)key;

@end
