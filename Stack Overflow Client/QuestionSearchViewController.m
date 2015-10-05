//
//  QuestionSearchViewController.m
//  Stack Overflow Client
//
//  Created by Benjamin Laddin on 9/15/15.
//  Copyright (c) 2015 Benjamin Laddin. All rights reserved.
//

#import "QuestionSearchViewController.h"
#import "StackOverflowService.h"
#import <AFNetworking.h>
#import "Errors.h"
#import "QuestionJSONParser.h"
#import "QuestionTableViewCell.h"
#import "Question.h"


@interface QuestionSearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSString *search;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *jsonData;


@end

@implementation QuestionSearchViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.searchBar.delegate = self;

  
  
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
  self.search = searchBar.text;
  [self.view endEditing:YES];
  
  
  [StackOverflowService questionsForSearchTerm:self.search completionHandler:^(NSArray *results, NSError *error) {
    
    if (error) {
      NSLog(@"error: %@", error);
      
    } else {
      self.jsonData = [[NSMutableArray alloc]init];
      
      dispatch_group_t imagesGroup = dispatch_group_create();
      dispatch_queue_t imageQueue = dispatch_queue_create("com.benladdin.stackoverflows", DISPATCH_QUEUE_CONCURRENT);
      
      for (Question *question in results) {
        
        dispatch_group_async(imagesGroup, imageQueue, ^{

          Question *questionObj = [[Question alloc]init];
          questionObj.title = question.title;
          
          NSURL *avatarImageURL = [NSURL URLWithString:question.avatarURL];
          questionObj.displayName = question.displayName;
          NSData *imagefromurl = [NSData dataWithContentsOfURL:avatarImageURL];
          questionObj.profileImage = [UIImage imageWithData:imagefromurl];
          [self.jsonData addObject:questionObj];
          NSLog(@"Counting: %lu",(unsigned long)self.jsonData.count);
          
        });
        
        
      }
      
      dispatch_group_notify(imagesGroup, dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Finished Images" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"Yippie" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
          [alert dismissViewControllerAnimated:true completion:nil];
        }];
        [alert addAction:done];
        [self presentViewController:alert animated:true completion:nil];
        
        NSLog(@"%lu",(unsigned long)self.jsonData.count);
        NSLog(@"%lu",(unsigned long)results.count);
        [self.tableView reloadData];
      }
                            );}
  }];}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  Question *searched = self.jsonData[indexPath.row];
  cell.Title.text = searched.title;
  cell.Name.text = searched.displayName;
  cell.imageView.image = searched.profileImage;
  return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.jsonData.count;
}


@end
