//
//  Profile.h
//  Stack Overflow Client
//
//  Created by Benjamin Laddin on 10/4/15.
//  Copyright © 2015 Benjamin Laddin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Profile : NSObject

@property (strong, nonatomic) NSString *profileName;
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) NSString *reputation;

@end
