//
//  QuestionTableViewCell.h
//  Stack Overflow Client
//
//  Created by Benjamin Laddin on 10/4/15.
//  Copyright © 2015 Benjamin Laddin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *Image;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *Title;

@end