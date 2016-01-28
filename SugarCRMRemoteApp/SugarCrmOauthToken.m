//
//  VendeplusOauthToken.m
//  VendeplusRemoteData
//
//  Created by Enrique Ortega Cardoso on 1/24/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import "SugarCrmOauthToken.h"

@implementation SugarCrmOauthToken

- (void) FillWithDictionaryData:(NSDictionary *)data{
    _accessToken = [data objectForKey:@"access_token"];
    _refreshToken = [data objectForKey:@"refresh_token"];
    _accessTokenExpires = [data objectForKey:@"expires_in"];
    _refreshTokenExpires = [data objectForKey:@"refresh_expires_in"];
    _downloadToken = [data objectForKey:@"download_token"];
    _scope = [data objectForKey:@"scope"];
    _tokenType = [data objectForKey:@"token_type"];
}

@end
