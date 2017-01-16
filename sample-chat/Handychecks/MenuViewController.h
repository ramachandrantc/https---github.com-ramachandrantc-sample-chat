//
//  MenuViewController.h
//  Handychecks
//
//  Created by Shrishti Informatics on 11/30/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MFSideMenu.h"
#import "ServiceRequestViewController.h"
#import "ProfileViewController.h"
#import "ServicesViewController.h"
#import "WalletViewController.h"
#import "ProvidersTableViewController.h"
#import <Quickblox/Quickblox.h>
#import "LoginViewController.h"

@interface MenuViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *requestService;
@property (strong, nonatomic) IBOutlet UIButton *profile;
@property (strong, nonatomic) IBOutlet UIButton *notification;
@property (strong, nonatomic) IBOutlet UIButton *wallet;
@property (strong, nonatomic) IBOutlet UIButton *chat;
@property (strong, nonatomic) IBOutlet UIButton *logout;
@property (strong, nonatomic) IBOutlet UIButton *rating;
- (IBAction)serviceRequest:(id)sender;
- (IBAction)profile:(id)sender;
- (IBAction)notifications:(id)sender;
- (IBAction)wallet:(id)sender;
- (IBAction)chat:(id)sender;
- (IBAction)rating:(id)sender;
- (IBAction)logout:(id)sender;
@end
