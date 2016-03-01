//
//  VendeplusAPI.h
//  VendeplusRemoteData
//
//  Created by Enrique Ortega Cardoso on 1/24/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRASugarCRMOauthToken.h"

extern NSString * const SRASugarRemoteServiceAuthRequiredNotification;

typedef void (^SRASugarCRMRemoteServiceSuccess)(NSData *data);
typedef void (^SRASugarCRMRemoteServiceFailure)(NSError *error);

@interface SRASugarCRMRemoteService : NSObject

#pragma mark - Singleton access

+ (SRASugarCRMRemoteService *)sharedInstance;

#pragma mark - Authentication

- (NSString *) signInWithUserName:(NSString *)userName password:(NSString *)password ServerURL:(NSURL *) serverURL success:(void (^)(NSDictionary *OauthData))success failure:(SRASugarCRMRemoteServiceFailure)failure;

- (NSString *) signOutUserWithSuccess:(void(^)())success failure:(SRASugarCRMRemoteServiceFailure)failure;

#pragma mark - Single Record Operations

/**
 * Fetch a specific record asynchronously. If successful, the 'success' block is invoked
 * otherwise the the 'failure' block is invoked
 * @param module The module that has the record
 * @param recordID The record to fetch
 * @param success The callback block for a successful fetch
 * @param failure The callback block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *) fetchRecordFromModule:(NSString *)module
                        withRecordID:(NSString *)recordID
                             success:(void(^)(NSDictionary *recordData))success
                             failure:(SRASugarCRMRemoteServiceFailure)failure;

/**
 * Update a specific record asynchronously. If successful, the 'success' block is invoked
 * otherwise the the 'failure' block is invoked
 * @param module The module that has the record
 * @param recordID The record to update
 * @param success The callback block for a successful fetch
 * @param failure The callback block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *) updateRecordFromModule:(NSString *)module
                         withRecordID:(NSString *)recordID
                       withRecordData:(NSDictionary *)recordData
                             success:(void(^)(NSDictionary *recordData))success
                             failure:(SRASugarCRMRemoteServiceFailure)failure;

/**
 * Delete a specific record asynchronously. If successful, the 'success' block is invoked
 * otherwise the the 'failure' block is invoked
 * @param module The module that has the record
 * @param recordID The record to delete
 * @param success The callback block for a successful fetch
 * @param failure The callback block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *) deleteRecordFromModule:(NSString *)module
                         withRecordID:(NSString *)recordID
                              success:(void(^)())success
                              failure:(SRASugarCRMRemoteServiceFailure)failure;

/**
 * Create a record asynchronously. If successful, the 'success' block is invoked
 * otherwise the the 'failure' block is invoked
 * @param module The module that will keep the record
 * @param recordData The data of the new record
 * @param success The callback block for a successful fetch
 * @param failure The callback block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *) createRecordFromModule:(NSString *)module
                         withRecordData:(NSDictionary *)recordData
                              success:(void(^)(NSDictionary *recordData))success
                              failure:(SRASugarCRMRemoteServiceFailure)failure;

#pragma mark - multiple Record Operations

/**
 * Fetch records asynchronously. If successful, the 'success' block is invoked
 * otherwise the the 'failure' block is invoked
 * @param module The module to fetch records from
 * @param URLArguments arguments to pass in the URL
 * @param success The callback block for a successful fetch
 * @param failure The callback block for a failed fetch
 * @return A NSString identifier for the operation, suitable for canceling with
 * -cancelRequestWithIdentifier:
 */
- (NSString *) fetchRecordsFromModule:(NSString *)module
                        withArguments:(NSDictionary *)URLArguments
                             success:(void(^)(NSDictionary *recordData))success
                             failure:(SRASugarCRMRemoteServiceFailure)failure;

/**
 * The current server this service instance is pointed at. This
 * method will be nil if -isUserSignedIn returns NO
 */
- (NSURL *)ServerRoot;


@end
