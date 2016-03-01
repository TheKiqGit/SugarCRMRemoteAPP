//
//  VendeplusOauthToken.m
//  VendeplusRemoteData
//
//  Created by Enrique Ortega Cardoso on 1/24/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import "SRASugarCRMOauthToken.h"

NSString * const SRAAccessTokenKey = @"access_token";
NSString * const SRARefreshTokenKey = @"refresh_token";
NSString * const SRATokenTypeKey = @"token_type";
NSString * const SRARefreshTokenExpiresInKey = @"refresh_expires_in";
NSString * const SRAAccessTokenExpiresInKey = @"expires_in";
NSString * const SRADownloadTokenKey = @"download_token";
NSString * const SRAScopeKey = @"scope";

@interface SRASugarCRMOauthToken()

@property (nonatomic, copy, readwrite) NSString* accessToken;
@property (nonatomic, copy, readwrite) NSString* refreshToken;
@property (nonatomic, copy, readwrite) NSString* tokenType;
@property (nonatomic, copy, readwrite) NSString* refreshTokenExpiresIn;
@property (nonatomic, copy, readwrite) NSString* accessTokenExpiresIn;
@property (nonatomic, copy, readwrite) NSString* downloadToken;
@property (nonatomic, copy, readwrite) NSString* scope;

@end


@implementation SRASugarCRMOauthToken

+ (instancetype) SugarCRMOauthTokenWithAuthentificationData:(NSDictionary *)authData {
    return [[[self class] alloc] initWithDictionary:authData];
}

- (instancetype) initWithDictionary:(NSDictionary *)dictData{
    self = [self init];
    if (self) {
        [self FillWithDictionaryData:dictData];
    }
    return self;
}

- (void)FillWithDictionaryData:(NSDictionary *)dict{
    self.accessToken = [dict valueForKey:SRAAccessTokenKey];
    self.refreshToken = [dict valueForKey:SRARefreshTokenKey];
    self.accessTokenExpiresIn = [NSString stringWithFormat:@"%@", [dict valueForKey:SRAAccessTokenExpiresInKey]];
    self.refreshTokenExpiresIn = [NSString stringWithFormat:@"%@",[dict valueForKey:SRARefreshTokenExpiresInKey]];
    self.downloadToken = [dict valueForKey:SRADownloadTokenKey];
    self.scope = ([[dict valueForKey:SRAScopeKey] class] != [NSNull class]) ? [dict valueForKey:SRAScopeKey] : @"";
    self.tokenType = [dict valueForKey:SRATokenTypeKey];
}

- (NSDictionary *)dictionaryRepresentation
{
    NSDictionary *dict =  @{
             SRAAccessTokenKey: self.accessToken,
             SRARefreshTokenKey: self.refreshToken,
             SRAAccessTokenExpiresInKey: self.accessTokenExpiresIn,
             SRARefreshTokenExpiresInKey: self.refreshTokenExpiresIn,
             SRATokenTypeKey: self.tokenType,
             SRADownloadTokenKey: self.downloadToken,
             SRAScopeKey: self.scope
             };
    return dict;
}

@end
