//
//  VendeplusOauthToken.h
//  VendeplusRemoteData
//
//  Created by Enrique Ortega Cardoso on 1/24/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SugarCrmOauthToken : NSObject

@property (nonatomic, weak) NSString* accessToken;
@property (nonatomic, weak) NSString* refreshToken;
@property (nonatomic, weak) NSString* tokenType;
@property (nonatomic, weak) NSString* refreshTokenExpires;
@property (nonatomic, weak) NSString* accessTokenExpires;
@property (nonatomic, weak) NSString* downloadToken;
@property (nonatomic, weak) NSString* scope;

- (void) FillWithDictionaryData: (NSDictionary *) data;

@end
