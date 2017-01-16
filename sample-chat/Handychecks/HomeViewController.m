//
//  HomeViewController.m
//  Handychecks
//
//  Created by Shrishti Informatics on 12/6/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"GET STARTED";
    self.getStartedButton.layer.cornerRadius = 30.0f;
    self.getStartedButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.getStartedButton.layer.borderWidth = 2.0f;
    
    self.closeButton.layer.cornerRadius = 10.0f;
    self.messageView.layer.cornerRadius = 20.0f;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    UIButton *menu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
    [menu setImage:[UIImage imageNamed:@"menu_bar.png"] forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(toggleMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:menu];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    if([self.message isEqualToString:@""] || self.message == nil) {
        [self.messageView setHidden:YES];
    } else {
        [self.messageView setHidden:NO];
    }
}

- (IBAction)toggleMenu:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        nil;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)getStarted:(id)sender {
    ServiceRequestViewController *requestService;
    requestService = [[ServiceRequestViewController alloc] initWithNibName:@"ServiceRequestViewController" bundle:nil];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    [navigationController pushViewController:requestService animated:YES];
}

- (IBAction)close:(id)sender {
    [UIView animateWithDuration:0.5f animations:^{
        [self.messageView setAlpha:0];
    }];
    [self.messageView setHidden:YES];
    [self.messageView setAlpha:1];
}
@end
