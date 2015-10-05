//
//  MyProfileViewController.m
//  Stack Overflow Client
//
//  Created by Benjamin Laddin on 9/15/15.
//  Copyright (c) 2015 Benjamin Laddin. All rights reserved.
//


#import "MyProfileViewController.h"
#import "StackOverflowService.h"
#import "JSONParser.h"
#import "Profile.h"

@interface MyProfileViewController ()
@property (retain, nonatomic) IBOutlet UIImageView *imageOfProfile;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *reputationLabel;
@property (retain, nonatomic) NSMutableArray *profiles;
@property (nonatomic) BOOL isDownloading;

@end

@implementation MyProfileViewController



- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.profiles = [[NSMutableArray alloc]init];
  
  [StackOverflowService completionHandlerForUser:^(NSArray *results, NSError *error) {
    
    if(error){
      NSLog(@"error: %@", error);
    }
    else{
      
      for (Profile *profile in results){
        self.isDownloading = true;
        Profile *myProfile = [[Profile alloc]init];
        myProfile.profileName = profile.profileName;
        myProfile.avatarURL = [NSString stringWithFormat:@"%@",profile.profileImage ];
        myProfile.reputation = profile.reputation;
        NSURL *profileURL = [NSURL URLWithString:myProfile.avatarURL];
        NSData *imageFromURL = [NSData dataWithContentsOfURL:profileURL];
        myProfile.profileImage = [UIImage imageWithData:imageFromURL];
        [self.profiles addObject: myProfile];
        [myProfile release];
      }
      Profile *myProfile = self.profiles[0];
      self.imageOfProfile.image = myProfile.profileImage;
      [self.nameLabel setText:myProfile.profileName];
      [self.reputationLabel setText:[NSString stringWithFormat:@"%@", myProfile.reputation]];
      self.isDownloading = false;
    }
  }
   ];
  [self.profiles release];
  
  
}


//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
//  BOOL newValue = [(NSNumber *) change[NSKeyValueChangeNewKey]boolValue];
//  if (newValue){
//  }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
