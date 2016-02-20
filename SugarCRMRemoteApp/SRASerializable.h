//
//  SRASerializable.h
//  SugarCRMRemoteApp
//
//  Created by Enrique Ortega Cardoso on 2/1/16.
//  Copyright © 2016 Enrique Ortega Cardoso. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SRASerializable <NSObject>

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end