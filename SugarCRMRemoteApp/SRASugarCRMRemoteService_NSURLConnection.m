

//
//  SRASugarCRMRemoteService_NSURLConnection.m
//  SugarCRMRemoteApp
//
//  Created by Enrique Ortega Cardoso on 2/18/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import "SRASugarCRMRemoteService_NSURLConnection.h"
#import "SRASugarCRMRemoteService_SubClassMethods.h"
#import "SRASugarCRMRemoteService_NSURLConnection_Request.h"
#import "NSArray+Enumerable.h"

@interface SRASugarCRMRemoteService_NSURLConnection () <SRASugarCRMRemoteService_NSURLConnection_RequestDelegate>

@end

@implementation SRASugarCRMRemoteService_NSURLConnection

- (NSString *) submitRequestWithURL:(NSURL *)URL method:(NSString *)httpMethod accessToken:(NSString *)accessToken body:(NSDictionary *)bodyDict expectedStatus:(NSInteger)expectedStatus success:(SRASugarCRMRemoteServiceSuccess)success failure:(SRASugarCRMRemoteServiceFailure)failure
{
    NSLog(@"%@",[URL absoluteString]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:httpMethod];
    
    if (bodyDict) {
        [request setHTTPBody:[self formEncodedParameters:bodyDict]];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    if (accessToken) {
        [request addValue:accessToken forHTTPHeaderField:@"OAuth-Token"];
    }
    
    SRASugarCRMRemoteService_NSURLConnection_Request *connectionRequest = [[SRASugarCRMRemoteService_NSURLConnection_Request alloc]
                                                                          initWithRequest:request
                                                                          expectedStatusCode:expectedStatus
                                                                          success:success
                                                                          failure:failure
                                                                          delegate:self];
    
    NSString *connectionID = [connectionRequest uniqueIdentifier];
    [self.requests setObject:connectionRequest forKey:connectionID];
    return connectionID;
}

#pragma mark - cancellation

- (void) cancelRequestWithIdentifier:(NSString *)identifier
{
    SRASugarCRMRemoteService_NSURLConnection_Request *request = [self.requests objectForKey:identifier];
    if (request) {
        [request cancel];
        [self.requests removeObjectForKey:identifier];
    }
}


#pragma mark - private helpers

- (NSData *) formEncodedParameters:(NSDictionary *)parameters
{
    NSArray *pairs = [parameters.allKeys mappedArrayWithBlock:^id(id obj) {
        return [NSString stringWithFormat:@"%@=%@",
                [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],
                [parameters[obj] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }];
    
    NSString *formBody = [pairs componentsJoinedByString:@"&"];
    
    return [formBody dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - SRASugarCRMRemoteService_NSURLConnectionRequest_Delegate

- (void) requestDidComplete:(SRASugarCRMRemoteService_NSURLConnection_Request *)request
{
    [self.requests removeObjectForKey:[request uniqueIdentifier]];
}




@end
