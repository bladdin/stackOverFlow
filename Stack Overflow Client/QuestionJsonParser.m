//
//  QuestionJsonParser.m
//  Stack Overflow Client
//
//  Created by Benjamin Laddin on 10/4/15.
//  Copyright © 2015 Benjamin Laddin. All rights reserved.
//

#import "QuestionJsonParser.h"
#import "Question.h"

@implementation QuestionJSONParser

+(NSArray *)questionsResultsFromJSON:(NSDictionary *)jsonInfo {
  NSMutableArray *questions = [[NSMutableArray alloc] init];
  NSArray *items = jsonInfo[@"items"];
  for(NSDictionary *item in items) {
    Question *question = [[Question alloc] init];
    question.title = item[@"title"];
    NSDictionary *owner = item[@"owner"];
    question.displayName= owner[@"display_name"];
    question.avatarURL = owner[@"profile_image"];
    [questions addObject:question];
  }
  return questions;
}

+(NSObject *)profileResultsFromJSON:(NSDictionary *)jsonProfileInfo{
  NSObject *userProfile = [[NSObject alloc]init];
  
  
  return userProfile;
}

@end
