//
//  VendeplusAPI.h
//  VendeplusRemoteData
//
//  Created by Enrique Ortega Cardoso on 1/24/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SugarCrmOauthToken.h"

enum SugarCrmModules{
    contactsModule = 1,
    policiesModule = 2,
    prospectsModule = 3,
};

@interface SugarCrmAPIRepository : NSObject {
    SugarCrmOauthToken *OauthObj;
}

- (void) requestTokenWithUserName: (NSString *)userName andPassword:(NSString *) password;
- (NSArray *) getRegistersFromModule:(enum SugarCrmModules) module;
- (NSArray *) getRegistersFromModule:(enum SugarCrmModules) module whitParameters:(enum SugarCrmAPICallParameters) parameters;

@end
