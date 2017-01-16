//
//  WalletViewController.m
//  Handychecks
//
//  Created by Shrishti Informatics on 12/7/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "WalletViewController.h"

@interface WalletViewController ()

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"WALLET";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    UIButton *menu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
    [menu setImage:[UIImage imageNamed:@"menu_bar.png"] forState:UIControlStateNormal];
    [menu addTarget:self action:@selector(toggleMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:menu];
    
    self.navigationItem.leftBarButtonItem = menuButton;
    
    self.paymentButton.layer.cornerRadius = 4;
    
    // drop shadow
    [self.paymentButton.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.paymentButton.layer setShadowOpacity:1.0];
    [self.paymentButton.layer setShadowRadius:1.0];
    [self.paymentButton.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    self.paidHistoryButton.layer.cornerRadius = 4;
    
    // drop shadow
    [self.paidHistoryButton.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.paidHistoryButton.layer setShadowOpacity:1.0];
    [self.paidHistoryButton.layer setShadowRadius:1.0];
    [self.paidHistoryButton.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
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

- (IBAction)payment:(id)sender {
    PaymentTableViewController *payment;
    payment = [[PaymentTableViewController alloc] initWithNibName:@"PaymentTableViewController" bundle:nil];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    [navigationController pushViewController:payment animated:YES];
}

- (IBAction)paidHistory:(id)sender {
    PaidServicesTableViewController *paidServices;
    paidServices = [[PaidServicesTableViewController alloc] initWithNibName:@"PaidServicesTableViewController" bundle:nil];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    [navigationController pushViewController:paidServices animated:YES];
}
@end
