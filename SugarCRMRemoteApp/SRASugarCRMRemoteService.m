//
//  VendeplusAPI.m
//  VendeplusRemoteData
//
//  Created by Enrique Ortega Cardoso on 1/24/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import "SRASugarCRMRemoteService.h"
#import "SRASugarCRMRemoteService_NSURLConnection.h"


NSString * const SRASugarRemoteServiceAuthRequiredNotification = @"SRASugarCRMRemoteServiceAuthenticationRequiredNotification";
/*
 * The user-defaults keys for the URL of the last server the user authenticated, 
 * for the user token data and
 */

static NSString * const SRALastServerURLKey = @"LastServerURL";
static NSString * const SRACurrentUserTokenKey = @"CurrentTokenData";

static SRASugarCRMRemoteService *sharedInstance;

@interface SRASugarCRMRemoteService ()

@property (nonatomic, strong) SRASugarCRMOauthToken *currentToken;
@property (nonatomic, strong) NSURL *tempServerRoot;
@property (nonatomic, strong) NSURL *ServerRoot;
@property (nonatomic, strong) NSMutableDictionary *requests;

@end

@implementation SRASugarCRMRemoteService

+ (SRASugarCRMRemoteService *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SRASugarCRMRemoteService_NSURLConnection alloc]init];
    });
    
    return sharedInstance;
}

- (instancetype) init
{
    if (self = [super init]) {
        self.requests = [NSMutableDictionary dictionary];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *serverRootString = [defaults stringForKey:SRALastServerURLKey];
        if (serverRootString) {
            self.ServerRoot = [NSURL URLWithString:serverRootString];
        }
        
        NSDictionary *userTokenDict = [defaults objectForKey:SRACurrentUserTokenKey];
        if (userTokenDict) {
            self.currentToken = [[SRASugarCRMOauthToken alloc] initWithDictionary:userTokenDict];
        }
    }
    return self;
}

#pragma mark - authentication

- (NSString *)signInWithUserName:(NSString *)userName password:(NSString *)password ServerURL:(NSURL *)serverURL success:(void (^)(NSDictionary *))success failure:(SRASugarCRMRemoteServiceFailure)failure
{
    self.tempServerRoot = serverURL;
    //Oauth data
    NSDictionary *postDictData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"password", @"grant_type",
                                  @"Tecnisys", @"client_id",
                                  @"OAtecnisys2014", @"client_secret",
                                  userName, @"username",
                                  password, @"password",
                                  @"base", @"platform",
                                  nil];
    
    return [self submitPOSTPath:@"oauth2/token"
                           body:postDictData
                 expectedStatus:200
                        success:^(NSData *data) {
                            NSError *error = nil;
                            NSDictionary *tokenDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                            if (tokenDict && [tokenDict isKindOfClass:[NSDictionary class]]) {
                                self.currentToken = [[SRASugarCRMOauthToken alloc] initWithDictionary:tokenDict];
                                self.tempServerRoot = nil;
                                self.ServerRoot = serverURL;
                                
                                [self persistServerRootAndOauthToken];
                                
                                if (success != NULL) {
                                    success([self.currentToken dictionaryRepresentation]);
                                }
                            }
                            else {
                                if (failure != NULL) {
                                    failure(error);
                                }
                            }
                        }
                        failure:^(NSError *error) {
                            self.tempServerRoot = nil;
                            if (failure != NULL) {
                                failure(error);
                            }
                        }];
}

- (NSString *)signOutUserWithSuccess:(void (^)())success failure:(SRASugarCRMRemoteServiceFailure)failure
{
    return [self submitPOSTPath:@"/oauth2/logout"
                           body:nil
                 expectedStatus:200
                        success:^(NSData *data){
                            self.tempServerRoot = nil;
                            self.currentToken = nil;
                            
                            [self persistServerRootAndOauthToken];
                            
                            if (success != NULL) {
                                success(success);
                            }
                        }
                        failure:failure];
    
    
}

- (BOOL)isUserSignedIn
{
    return self.ServerRoot != nil;
}

#pragma mark - record operations

- (NSString *)fetchRecordFromModule:(NSString *)module withRecordID:(NSString *)recordID success:(void (^)(NSDictionary *))success failure:(SRASugarCRMRemoteServiceFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"/%@/%@", module, recordID];
    return [self submitGETPath:path
                       success:^(NSData *data) {
                           NSError *error = nil;
                           NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                           
                           if (response && [response isKindOfClass:[NSDictionary class]]) {
                               if (success != NULL) {
                                   success(response);
                               }
                           }
                           else {
                               if (failure != NULL) {
                                   failure(error);
                               }
                           }
                       }
                       failure:failure];
            
}

- (NSString *) createRecordFromModule:(NSString *)module withRecordData:(NSDictionary *)recordData success:(void (^)(NSDictionary *))success failure:(SRASugarCRMRemoteServiceFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"/%@", module];
    return [self submitPOSTPath:path
                           body:recordData
                 expectedStatus:200
                        success:^(NSData *data) {
                            NSError *error = nil;
                            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                            
                            if (response && [response isKindOfClass:[NSDictionary class]]) {
                                if (success != NULL) {
                                    success(response);
                                }
                            }
                            else {
                                if (failure != NULL) {
                                    failure(error);
                                }
                            }
                        }
                        failure:failure];
}

-(NSString *) updateRecordFromModule:(NSString *)module withRecordID:(NSString *)recordID withRecordData:(NSDictionary *)recordData success:(void (^)(NSDictionary *))success failure:(SRASugarCRMRemoteServiceFailure)failure
{
    NSString *path = [NSString stringWithFormat:@"/%@/%@", module, recordID];
    return [self submitPUTPath:path
                           body:recordData
                 expectedStatus:200
                        success:^(NSData *data) {
                            NSError *error = nil;
                            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                            
                            if (response && [response isKindOfClass:[NSDictionary class]]) {
                                if (success != NULL) {
                                    success(response);
                                }
                            }
                            else {
                                if (failure != NULL) {
                                    failure(error);
                                }
                            }
                        }
                        failure:failure];
}

-(NSString *) deleteRecordFromModule:(NSString *)module withRecordID:(NSString *)recordID success:(void (^)())success failure:(SRASugarCRMRemoteServiceFailure)failure{
    NSString *path = [NSString stringWithFormat:@"/%@/%@", module, recordID];
    return [self submitDELETEPath:path success:success failure:failure];
}


#pragma mark - fetching multiple records

- (NSString *) fetchRecordsFromModule:(NSString *)module withArguments:(NSDictionary *)URLArguments success:(void (^)(NSDictionary *))success failure:(SRASugarCRMRemoteServiceFailure)failure
{
    NSString *path;
    if (URLArguments) {
        path = [NSString stringWithFormat:@"/%@?%@", module,[URLArguments description]];
    }
    else {
        path = [NSString stringWithFormat:@"/%@", module];
    }
    
    return [self submitGETPath:path
                       success:^(NSData *data) {
                           NSError *error = nil;
                           NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                           
                           if (responseData && [responseData isKindOfClass:[NSDictionary class]]) {
                               if (success != NULL) {
                                   success(responseData);
                               }
                               
                           }
                           else {
                               if (failure != NULL) {
                                   NSError *error = [NSError errorWithDomain:@"SugarRemoteApp"
                                                                        code:0
                                                                    userInfo:@{NSLocalizedDescriptionKey: @"API returned invalid response"}];
                                   failure(error);
                               }
                           }
                       }
                       failure:failure];
}

#pragma mark - Abstract methods

- (NSString *) submitRequestWithURL:(NSURL *)URL method:(NSString *)httpMethod accessToken:(NSString *)accessToken body:(NSDictionary *)bodyDict expectedStatus:(NSInteger)expectedStatus success:(SRASugarCRMRemoteServiceSuccess)success failure:(SRASugarCRMRemoteServiceFailure)failure
{
    NSAssert(NO, @"%s must be implemented in subclass", __PRETTY_FUNCTION__);
    return nil;
}

- (void) cancelRequestWithIdentifier:(NSString *)identifier
{
    NSAssert(NO, @"%s must be implemented in subclass", __PRETTY_FUNCTION__);
}

#pragma mark - Request Helpers

- (void) persistServerRootAndOauthToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.ServerRoot.absoluteString forKey:SRALastServerURLKey];
    [defaults setObject:[self.currentToken dictionaryRepresentation] forKey:SRACurrentUserTokenKey];
    [defaults synchronize];
}

- (NSURL *) SugarURLWithPath:(NSString *)path
{
    NSURL *root = self.ServerRoot ?: self.tempServerRoot;
    NSString *APIPath = @"rest/v10/";
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", APIPath, path] relativeToURL:root];
}

- (NSString *) submitGETPath:(NSString *)path success:(SRASugarCRMRemoteServiceSuccess)success failure:(SRASugarCRMRemoteServiceFailure)failure
{
    NSURL *URL = [self SugarURLWithPath:path];
    return [self submitRequestWithURL:URL method:@"GET" accessToken:self.currentToken.accessToken body:nil expectedStatus:200 success:success failure:failure];
}

- (NSString *) submitDELETEPath:(NSString *)path success:(SRASugarCRMRemoteServiceSuccess)success failure:(SRASugarCRMRemoteServiceFailure)failure
{
    NSURL *URL = [self SugarURLWithPath:path];
    return [self submitRequestWithURL:URL method:@"DELETE" accessToken:self.currentToken.accessToken body:nil expectedStatus:200 success:success failure:failure];
}

- (NSString *) submitPOSTPath:(NSString *)path body:(NSDictionary *)bodyDict expectedStatus:(NSInteger)expectedStatus success:(SRASugarCRMRemoteServiceSuccess)success failure:(SRASugarCRMRemoteServiceFailure)failure
{
    NSURL *URL = [self SugarURLWithPath:path];
    return [self submitRequestWithURL:URL method:@"POST" accessToken:self.currentToken.accessToken body:bodyDict expectedStatus:expectedStatus success:success failure:failure];
}

- (NSString *) submitPUTPath:(NSString *)path body:(NSDictionary *)bodyDict expectedStatus:(NSInteger)expectedStatus success:(SRASugarCRMRemoteServiceSuccess)success failure:(SRASugarCRMRemoteServiceFailure)failure
{
    NSURL *URL = [self SugarURLWithPath:path];
    return [self submitRequestWithURL:URL method:@"PUT" accessToken:self.currentToken.accessToken  body:bodyDict expectedStatus:expectedStatus success:success failure:failure];
    
}






@end
