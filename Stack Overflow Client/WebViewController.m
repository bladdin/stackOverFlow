//
//  WebViewController.m
//  Stack Overflow Client
//
//  Created by Benjamin Laddin on 10/1/15.
//  Copyright © 2015 Benjamin Laddin. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>


@interface WebViewController ()<WKNavigationDelegate>


@end

@implementation WebViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  
  WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.frame];
  [self.view addSubview:webView];
  webView.navigationDelegate = self;
  
  
  
  NSString *baseURL = @"https://stackexchange.com/oauth/dialog";
  NSString *clientID = @"5704";
  NSString *redirectURI = @"https://stackexchange.com/oauth/login_success";
  NSString *finalURL = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",baseURL,clientID,redirectURI];
  
  [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:finalURL]]];
  
  NSLog(@"finalURL:%@",finalURL);
  
  
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  
  if ([navigationAction.request.URL.path isEqualToString:@"/oauth/login_success"]) {
    NSString *fragmentStr = navigationAction.request.URL.fragment;
    NSArray *components = [fragmentStr componentsSeparatedByString:@"&"];
    NSString *fullToken = components.firstObject;
    NSString *token = [fullToken componentsSeparatedByString:@"="].lastObject;
    
    NSString *key = @"CgpZqTucZe1ss79*9iGu3g((";
    if (token) {
      
      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
      [userDefaults setObject:token forKey:@"token"];
      [userDefaults setObject:key forKey:@"key"];
      [self dismissViewControllerAnimated:true completion:nil];
      NSLog(@"Success");
    }
    else {
      NSLog(@"error");
    }
  }
  decisionHandler(WKNavigationActionPolicyAllow);
  
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
