//
//  JsonParser.m
//  Stack Overflow Client
//
//  Created by Benjamin Laddin on 10/4/15.
//  Copyright © 2015 Benjamin Laddin. All rights reserved.
//

#import "JsonParser.h"
#import "Profile.h"


@implementation ProfileJSONParser


+(NSMutableArray *)profilesFromJson:(NSDictionary *)jsonInfo {
  NSLog(@"json: %@",jsonInfo);
  
  NSArray *profiles = [[NSArray alloc] init];
  NSMutableArray *profilez = [[NSMutableArray alloc] init];
  
  profiles = jsonInfo[@"items"];
  for(NSDictionary *item in profiles) {
    Profile *profile = [[Profile alloc] init];
    profile.profileName = item[@"display_name"];
    profile.profileImage = item[@"profile_image"];
    profile.reputation = item[@"reputation"];
    [profilez addObject:profile];
  }
  
  return profilez;
}
@end