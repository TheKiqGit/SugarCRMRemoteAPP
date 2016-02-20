//
//  NSArray.m
//  SugarCRMRemoteApp
//
//  Created by Enrique Ortega Cardoso on 2/18/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import "NSArray+Enumerable.h"

@implementation NSArray (Enumerable)

- (NSArray *)mappedArrayWithBlock:(id (^)(id))block
{
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self) {
        [temp addObject:block(obj)];
    }
    
    return temp;
}


@end
