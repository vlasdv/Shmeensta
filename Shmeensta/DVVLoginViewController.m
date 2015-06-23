//
//  DVVLoginViewController.m
//  Shmeensta
//
//  Created by Dmitrii Vlasov on 23.06.15.
//  Copyright (c) 2015 Dmitry Vlasov. All rights reserved.
//

#import "DVVLoginViewController.h"
#import "DVVFeedTableViewController.h"

@interface DVVLoginViewController ()

@property (strong, nonatomic) UIWebView *webView;

@end

@implementation DVVLoginViewController

static NSString *clientID = @"3836f2581032482483b7120bdf405f64";
static NSString *redirectURI = @"ig3836f2581032482483b7120bdf405f64://authorize";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![self accessTokenReceived]) {
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:webView];
        webView.delegate = self;
        self.webView = webView;
        
        [self receiveAccessToken];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    if ([self accessTokenReceived]) {

        [self showFeed];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)accessTokenReceived {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"accessToken"] != nil;
}

- (void)showFeed {
    
    DVVFeedTableViewController *vc = [[DVVFeedTableViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];

}

- (void)receiveAccessToken {
    
    NSString *stringURL = [NSString stringWithFormat:@"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token", clientID, redirectURI];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *accessToken;
    
    NSString *query = [[request URL] description];
    NSRange accessTokenRange = [query rangeOfString:@"#access_token="];
    
    NSLog(@"%@", query);
    
    if (accessTokenRange.location != NSNotFound) {
        accessToken = [query substringFromIndex:(accessTokenRange.location + accessTokenRange.length)];
        
        NSLog(@"%@", accessToken);
        
        self.webView.delegate = nil;
        [userDefaults setObject:accessToken forKey:@"accessToken"];
        
        DVVFeedTableViewController *vc = [[DVVFeedTableViewController alloc] init];
        [self presentViewController:vc animated:NO completion:nil];
    }
    
    return YES;
    
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
