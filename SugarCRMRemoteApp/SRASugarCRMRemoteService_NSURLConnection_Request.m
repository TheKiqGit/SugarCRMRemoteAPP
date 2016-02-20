//
//  SRASugarRemoteService_NSURLConnection_Request.m
//  SugarCRMRemoteApp
//
//  Created by Enrique Ortega Cardoso on 2/19/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//
#import "SRASugarCRMRemoteService.h"
#import "SRASugarCRMRemoteService_NSURLConnection_Request.h"


@interface SRASugarCRMRemoteService_NSURLConnection_Request()

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) SRASugarCRMRemoteServiceSuccess successCallback;
@property (nonatomic, strong) SRASugarCRMRemoteServiceFailure failureCallback;
@property (nonatomic, assign) NSInteger expectedStatusCode;
@property (nonatomic, assign) NSInteger actualStatusCode;
@property (nonatomic, weak) id<SRASugarCRMRemoteService_NSURLConnection_RequestDelegate> delegate;
@property (nonatomic, strong) NSString *uniqueIdentifier;

@end


@implementation SRASugarCRMRemoteService_NSURLConnection_Request

- (instancetype)initWithRequest:(NSURLRequest *)request expectedStatusCode:(NSInteger)statusCode success:(SRASugarCRMRemoteServiceSuccess)success failure:(SRASugarCRMRemoteServiceFailure)failure delegate:(id<SRASugarCRMRemoteService_NSURLConnection_RequestDelegate>)delegate
{
    if ((self = [super init])) {
        self.request = request;
        self.expectedStatusCode = statusCode;
        self.successCallback = success;
        self.failureCallback = failure;
        self.delegate = delegate;
        self.uniqueIdentifier = [[NSUUID UUID] UUIDString];
        [self initiateRequest];
    }
    
    return self;
}



- (void)initiateRequest
{
    self.response = nil;
    self.data = [NSMutableData data];
    self.actualStatusCode = NSNotFound;
    self.connection = [[NSURLConnection alloc]initWithRequest:self.request delegate:self];
}

- (void)cancel
{
    [self.connection cancel];
}

- (void)restart
{
    [self cancel];
    [self initiateRequest];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSURLRequest *request = [connection originalRequest];
    
    [connection cancel];
    NSLog(@"%@ %@ %li FAIL %@", [request HTTPMethod], [request URL], (long)self.expectedStatusCode, error);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.failureCallback(error);
    });
    
    [self.delegate requestDidComplete:self];
}

#pragma  mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.response = response;
    NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
    self.actualStatusCode = responseCode;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSURLRequest *request = [connection originalRequest];
    if ([self hasExpectedStatusCode]) {
        NSLog(@"%@ %@ %li SUCCESS",[request HTTPMethod], [request URL], (long)self.actualStatusCode);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.successCallback(self.data);
        });
    }
    else {
        NSLog(@"%@ %@ %li INVALID STATUS CODE",[request HTTPMethod], [request URL], (long)self.actualStatusCode);
        
        NSString *message = [NSString stringWithFormat:@"Unexpected Response code: %li", (long)self.actualStatusCode];
        
        if (self.data) {
            NSError *error = nil;
            id json = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error];
            if (json && [json isKindOfClass:[NSDictionary class]]) {
                NSString *errorMessage = [(NSDictionary *)json valueForKey:@"error_message"];
                if (errorMessage) {
                    message = errorMessage;
                }
            }
        }
        
        NSError *error = [NSError errorWithDomain:@"SugarCRMRemoteService" code:self.actualStatusCode userInfo:@{ NSLocalizedDescriptionKey: message}];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.failureCallback(error);
        });
        
    }
    [self.delegate requestDidComplete:self];
}

#pragma mark - Private helpers

- (void)appendData:(NSData *)data
{
    [self.data appendData:data];
}

- (BOOL)hasExpectedStatusCode
{
    if (self.expectedStatusCode != NSNotFound) {
        return self.expectedStatusCode == self.actualStatusCode;
    }
    
    return NO;
}


@end
