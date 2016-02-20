//
//  NSArray.h
//  SugarCRMRemoteApp
//
//  Created by Enrique Ortega Cardoso on 2/18/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Enumerable)

- (NSArray *) mappedArrayWithBlock:(id(^)(id obj))block;

@end
