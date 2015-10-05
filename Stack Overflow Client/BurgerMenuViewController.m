//
//  BurgerMenuViewController.m
//  Stack Overflow Client
//
//  Created by Benjamin Laddin on 9/15/15.
//  Copyright (c) 2015 Benjamin Laddin. All rights reserved.
//

#import "BurgerMenuViewController.h"
#import "QuestionSearchViewController.h"
#import "MyQuestionsViewController.h"
#import "MyProfileViewController.h"
#import "WebViewController.h"

CGFloat const kburgerButtonHeight = 60.0;
CGFloat const kburgerButtonWidth = 60.0;
CGFloat const kburgerButtonXPosition = 8.0;
CGFloat const kburgerButtonYPosition = 8.0;
CGFloat const kburgerScreenDivider = 3.0;
NSTimeInterval const kSlideTime = 0.3;

@interface BurgerMenuViewController ()<UITableViewDelegate>
@property (strong, nonatomic) UIButton *burgerButton;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@property (strong, nonatomic) UIViewController *topViewController;
@property (strong,nonatomic) NSArray *viewControllers;


@end

@implementation BurgerMenuViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  UITableViewController *mainMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
  [self addChildViewController:mainMenuVC];
  mainMenuVC.view.frame = self.view.frame;
  [self.view addSubview:mainMenuVC.view];
  [mainMenuVC didMoveToParentViewController:self];
  mainMenuVC.tableView.delegate = self;
  
  UIViewController *searchQuestionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchQuestions"];
  [self addChildViewController:searchQuestionVC];
  searchQuestionVC.view.frame = self.view.frame;
  [self.view addSubview:searchQuestionVC.view];
  [searchQuestionVC didMoveToParentViewController:self];
  [self designateTopViewController:searchQuestionVC];
  
  MyQuestionsViewController *myQuestionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyQuestions"];
  MyProfileViewController *myProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfile"];
  self.viewControllers = @[searchQuestionVC,myQuestionsVC,myProfileVC];
  
  self.burgerButton = [[UIButton alloc]initWithFrame:CGRectMake(kburgerButtonXPosition, kburgerButtonYPosition, kburgerButtonWidth, kburgerButtonHeight)];
  [self.burgerButton setImage:[UIImage imageNamed:@"burger"] forState:UIControlStateNormal];
  [self.topViewController.view addSubview: self.burgerButton];
  [self.burgerButton addTarget:self action:@selector(burgerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  
  
  self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(topViewControllerPanned:)];
  [self.topViewController.view addGestureRecognizer:self.pan];
  
}

-(void)viewDidAppear:(BOOL)animated{
  
  [super viewDidAppear:animated];
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *token = [userDefaults stringForKey:@"token"];
  
  
  if (!token) {
    
    WebViewController *webVC = [[WebViewController alloc] init];
    [self presentViewController:webVC animated:true completion:nil];
    
  }
  
}




-(void)designateTopViewController:(UIViewController *)topViewController {
  self.topViewController = topViewController;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"%ld",(long)indexPath.row);
  
  UIViewController *newVC = self.viewControllers[indexPath.row];
  if (![newVC isEqual:self.topViewController]) {
    [self switchToViewController:newVC];
  }
  
}

-(void)topViewControllerPanned:(UIPanGestureRecognizer *)sender{
  
  CGPoint velocity = [sender velocityInView:self.topViewController.view];
  CGPoint translation = [sender translationInView:self.topViewController.view];
  
  
  if (sender.state == UIGestureRecognizerStateChanged) {
    if (velocity.x > 0) {
      self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translation.x, self.topViewController.view.center.y);
      [sender setTranslation:CGPointZero inView:self.topViewController.view];
    }
  }
}



-(void)switchToViewController:(UIViewController *)newVC{
  [UIView animateWithDuration:0.3 animations:^{
    
    self.topViewController.view.frame = CGRectMake(self.view.frame.size.width,self.topViewController.view.frame.origin.y,self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
    
  } completion:^(BOOL finished) {
    CGRect oldFrame = self.topViewController.view.frame;
    [self.topViewController willMoveToParentViewController:nil];
    [self.topViewController.view removeFromSuperview];
    [self.topViewController removeFromParentViewController];
    
    [self addChildViewController:newVC];
    newVC.view.frame = oldFrame;
    [self.view addSubview:newVC.view];
    [newVC didMoveToParentViewController:self];
    self.topViewController = newVC;
    
    [self.burgerButton removeFromSuperview];
    [self.topViewController.view addSubview:self.burgerButton];
    
    
    [UIView animateWithDuration:0.3 animations:^{
      self.topViewController.view.center = self.view.center;
    } completion:^(BOOL finished) {
      [self.topViewController.view addGestureRecognizer:self.pan];
      self.burgerButton.userInteractionEnabled = true;
    }];
  }];
}

-(void)burgerButtonPressed:(UIButton *)sender {
  [UIView animateWithDuration:kSlideTime animations:^{
    [self.view endEditing:true];
    self.topViewController.view.center = CGPointMake(self.view.center.x * kburgerScreenDivider, self.topViewController.view.center.y);
  } completion:^(BOOL finished) {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseMenu:)];
    [self.topViewController.view addGestureRecognizer:tap];
    sender.userInteractionEnabled = false;
    
  }];
}

-(void)tapToCloseMenu:(UITapGestureRecognizer *)tap {
  [self.topViewController.view removeGestureRecognizer:tap];
  [UIView animateWithDuration:0.3 animations:^{
    self.topViewController.view.center = self.view.center;
  } completion:^(BOOL finished) {
    self.burgerButton.userInteractionEnabled = true;
    
  }];
}

@end
