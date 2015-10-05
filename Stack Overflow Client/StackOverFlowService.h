//
//  StackOverFlowService.h
//  Stack Overflow Client
//
//  Created by Benjamin Laddin on 10/4/15.
//  Copyright © 2015 Benjamin Laddin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StackOverflowService : NSObject

+ (void)questionsForSearchTerm:(NSString *)searched completionHandler:(void (^)(NSArray *results, NSError *error))completionHandler;

+ (void)completionHandlerForUser:(void (^) (NSArray *result, NSError *error))completionHandlerForUser;


@end
