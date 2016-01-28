//
//  VendeplusAPI.m
//  VendeplusRemoteData
//
//  Created by Enrique Ortega Cardoso on 1/24/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import "SugarCrmAPIRepository.h"

@implementation SugarCrmAPIRepository


- (void) requestTokenWithUserName:(NSString *)userName andPassword:(NSString *)password{
    
    //Oauth data
    NSDictionary *postDictData = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"" ,nil];
    
    NSURL *url = [NSURL URLWithString:@"/rest/v10/oauth2/token"]; //SugarCRM url
    
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDictData options:0 error:&error];

    [self SugarCRMApiCallForURL:url httpMethod:@"POST" withData:postData success:^(NSDictionary *responseDict) {
        NSLog(@"acces_token: %@",[responseDict objectForKey:@"access_token"]);
    } failure:^(NSError *error) {
        NSLog(@"%@",[error description]);
    }];
    
}

-(NSArray *) getRegistersFromModule:(enum SugarCrmModules)module{
    NSString *SelectedModule = [self APImethodForModule:module];
    return [NSArray arrayWithObject:@1];
}

- (NSString *) APImethodForModule:(enum  SugarCrmModules)module {
    NSString *moduleApi = nil;
    
    switch (module) {
        case prospectsModule:
            return moduleApi = @"Leads";
            break;
        case contactsModule:
            return moduleApi = @"Contacts";
            break;
        case policiesModule:
            return moduleApi = @"Policies";
            break;
        default:
            break;
    }
}

- (void) SugarCRMApiCallForURL:(NSURL *)url httpMethod:(NSString *)method withData:(NSData *)httpBodyData success:(void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:method];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:httpBodyData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        
        NSDictionary *responseDictData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        success(responseDictData);
        
    }];
    [postDataTask resume];
}

- (void) SugarCRMApiCallForURL:(NSURL *)url httpMethod:(NSString *)method useAccessToken:(BOOL)useToken success:(void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:method];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    if (useToken) {
        [request addValue:@"OAuth-token" forHTTPHeaderField:OauthObj.accessToken];
    }
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        
        NSDictionary *responseDictData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        success(responseDictData);
        
    }];
    [postDataTask resume];
}


@end
