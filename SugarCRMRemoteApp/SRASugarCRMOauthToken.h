//
//  VendeplusOauthToken.h
//  VendeplusRemoteData
//
//  Created by Enrique Ortega Cardoso on 1/24/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRASerializable.h"

extern NSString * const accessTokenKey;
extern NSString * const refreshTokenKey;
extern NSString * const tokenTypeKey;
extern NSString * const refreshTokenExpiresKey;
extern NSString * const accessTokenExpiresKey;
extern NSString * const downloadTokenKey;
extern NSString * const scopeKey;

@interface SRASugarCRMOauthToken : NSObject <SRASerializable>

@property (nonatomic, copy, readonly) NSString* accessToken;
@property (nonatomic, copy, readonly) NSString* refreshToken;
@property (nonatomic, copy, readonly) NSString* tokenType;
@property (nonatomic, copy, readonly) NSString* refreshTokenExpiresIn;
@property (nonatomic, copy, readonly) NSString* accessTokenExpiresIn;
@property (nonatomic, copy, readonly) NSString* downloadToken;
@property (nonatomic, copy, readonly) NSString* scope;

+ (instancetype) SugarCRMOauthTokenWithAuthentificationData:(NSDictionary *)authData;

@end
