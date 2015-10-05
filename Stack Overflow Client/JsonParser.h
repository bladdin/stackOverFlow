//
//  JsonParser.h
//  Stack Overflow Client
//
//  Created by Benjamin Laddin on 10/4/15.
//  Copyright © 2015 Benjamin Laddin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileJSONParser : NSObject


+(NSArray *)profilesFromJson:(NSDictionary *)jsonInfo;


@end
