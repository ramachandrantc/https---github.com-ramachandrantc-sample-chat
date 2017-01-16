//
//  MenuViewController.m
//  Handychecks
//
//  Created by Shrishti Informatics on 11/30/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    float width= [UIScreen mainScreen].bounds.size.width;
    float height=[UIScreen mainScreen].bounds.size.height;
    [self.view setFrame:CGRectMake(0, 0, width, height)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.requestService.layer.cornerRadius = 4;
    
    // drop shadow
    [self.requestService.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.requestService.layer setShadowOpacity:0.8];
    [self.requestService.layer setShadowRadius:1.0];
    [self.requestService.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    self.profile.layer.cornerRadius = 4;
    
    // drop shadow
    [self.profile.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.profile.layer setShadowOpacity:0.8];
    [self.profile.layer setShadowRadius:1.0];
    [self.profile.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    self.notification.layer.cornerRadius = 4;
    
    // drop shadow
    [self.notification.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.notification.layer setShadowOpacity:0.8];
    [self.notification.layer setShadowRadius:1.0];
    [self.notification.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    self.wallet.layer.cornerRadius = 4;
    
    // drop shadow
    [self.wallet.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.wallet.layer setShadowOpacity:0.8];
    [self.wallet.layer setShadowRadius:1.0];
    [self.wallet.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    self.chat.layer.cornerRadius = 4;
    
    // drop shadow
    [self.chat.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.chat.layer setShadowOpacity:0.8];
    [self.chat.layer setShadowRadius:1.0];
    [self.chat.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    self.rating.layer.cornerRadius = 4;
    
    // drop shadow
    [self.rating.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.rating.layer setShadowOpacity:0.8];
    [self.rating.layer setShadowRadius:1.0];
    [self.rating.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    
    self.logout.layer.cornerRadius = 4;
    
    // drop shadow
    [self.logout.layer setShadowColor:[UIColor colorWithRed:(14.0/255) green:(82.0/255) blue:(117.0/255) alpha:1].CGColor];
    [self.logout.layer setShadowOpacity:0.8];
    [self.logout.layer setShadowRadius:1.0];
    [self.logout.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
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

- (IBAction)serviceRequest:(id)sender {
    ServiceRequestViewController *requestService;
    requestService = [[ServiceRequestViewController alloc] initWithNibName:@"ServiceRequestViewController" bundle:nil];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    if([[[navigationController visibleViewController] nibName] isEqualToString:@"ServiceRequestViewController"]) {
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    } else {
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        [navigationController pushViewController:requestService animated:YES];
    }
}

- (IBAction)profile:(id)sender {
    ProfileViewController *profile;
    profile = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    if([[[navigationController visibleViewController] nibName] isEqualToString:@"ProfileViewController"]) {
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    } else {
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        [navigationController pushViewController:profile animated:YES];
    }
}

- (IBAction)notifications:(id)sender {
    ServicesViewController *notification;
    notification = [[ServicesViewController alloc] initWithNibName:@"ServicesViewController" bundle:nil];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    if([[[navigationController visibleViewController] nibName] isEqualToString:@"ServicesViewController"]) {
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    } else {
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        [navigationController pushViewController:notification animated:YES];
    }
}

- (IBAction)wallet:(id)sender {
    WalletViewController *wallet;
    wallet = [[WalletViewController alloc] initWithNibName:@"WalletViewController" bundle:nil];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    if([[[navigationController visibleViewController] nibName] isEqualToString:@"WalletViewController"]) {
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    } else {
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        [navigationController pushViewController:wallet animated:YES];
    }
}

- (IBAction)chat:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    QBUUser *currentUser = [QBUUser user];
    currentUser.email = [defaults objectForKey:@"quick_email"];
    currentUser.password = [defaults objectForKey:@"quick_pass"];
    
    // connect to Chat
    [[QBChat instance] connectWithUser:currentUser completion:^(NSError * _Nullable error) {
        NSLog(@"Error: %@", error);
    }];

}

- (IBAction)rating:(id)sender {
    ProvidersTableViewController *provider;
    provider = [[ProvidersTableViewController alloc] initWithNibName:@"ProvidersTableViewController" bundle:nil];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    if([[[navigationController visibleViewController] nibName] isEqualToString:@"ProvidersTableViewController"]) {
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    } else {
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        [navigationController pushViewController:provider animated:YES];
    }
}

- (IBAction)logout:(id)sender {
    LoginViewController *login;
    login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    if([[[navigationController visibleViewController] nibName] isEqualToString:@"LoginViewController"]) {
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    } else {
        
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        [navigationController pushViewController:login animated:YES];
    }
}
@end
