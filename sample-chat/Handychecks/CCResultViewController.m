//
//  CCResultViewController.m
//  CCIntegrationKit
//
//  Created by test on 5/16/14.
//  Copyright (c) 2014 Avenues. All rights reserved.
//

#import "CCResultViewController.h"

@interface CCResultViewController ()

@end

@implementation CCResultViewController
@synthesize transStatus;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ORDER CONFIRMATION";
    
    self.resultLabel.text = transStatus;
    self.orderId.text = self.orderID;
    self.amount.text = [NSString stringWithFormat:@"%@ AED", self.amt];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    UIButton *menu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
    [menu setImage:[UIImage imageNamed:@"menu_bar.png"] forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(toggleMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    self.navigationItem.leftBarButtonItem = menuButton;
    
    self.containerView.layer.cornerRadius = 8.0;
    self.homeButton.layer.cornerRadius = 4;
    
    // drop shadow
    [self.homeButton.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.homeButton.layer setShadowOpacity:1.0];
    [self.homeButton.layer setShadowRadius:1.0];
    [self.homeButton.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
}

- (IBAction)toggleMenu:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{
        nil;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)home:(id)sender {
    HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    [self.navigationController pushViewController:home animated:YES];
}
@end
