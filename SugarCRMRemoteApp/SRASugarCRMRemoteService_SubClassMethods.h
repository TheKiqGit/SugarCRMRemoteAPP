//
//  SRASugarCRMRemoteService_SubClassMethods.h
//  SugarCRMRemoteApp
//
//  Created by Enrique Ortega Cardoso on 2/18/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRASugarCRMRemoteService (SubClassMethods)

@property (nonatomic, strong) NSURL *tempServerRoot;
@property (nonatomic, strong, readonly) NSMutableDictionary *requests;
@property (nonatomic, strong, readonly) NSMutableArray *requestsPendingAuthentication;

@end
