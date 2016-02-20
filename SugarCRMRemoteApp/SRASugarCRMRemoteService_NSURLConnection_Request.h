//
//  SRASugarRemoteService_NSURLConnection_Request.h
//  SugarCRMRemoteApp
//
//  Created by Enrique Ortega Cardoso on 2/19/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SRASugarCRMRemoteService_NSURLConnection_RequestDelegate;

@interface SRASugarCRMRemoteService_NSURLConnection_Request : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>


/**
 * Initialize a new instance
 * @param request A NSURLRequest for the underlying connection to execute
 * @param statusCode The expected HTTP status code signaling successful execution
 * @param success The callback block to execute upon successful completion
 * @param failure The failure block to execute if the connection fails for any reason
 */

- (instancetype) initWithRequest:(NSURLRequest *)request expectedStatusCode:(NSInteger)statusCode success:(SRASugarCRMRemoteServiceSuccess)success failure:(SRASugarCRMRemoteServiceFailure)failure delegate:(id<SRASugarCRMRemoteService_NSURLConnection_RequestDelegate>)delegate;

- (void) cancel;

- (void) restart;

- (NSString *) uniqueIdentifier;


@end


@protocol SRASugarCRMRemoteService_NSURLConnection_RequestDelegate <NSObject>

- (void) requestDidComplete:(SRASugarCRMRemoteService_NSURLConnection_Request *)request;

@end
