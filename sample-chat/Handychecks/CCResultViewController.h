//
//  CCResultViewController.h
//  CCIntegrationKit
//
//  Created by test on 5/16/14.
//  Copyright (c) 2014 Avenues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu/MFSideMenu.h"
#import "HomeViewController.h"

@interface CCResultViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) NSString *transStatus;
@property (strong, nonatomic) NSString *orderID;
@property (strong, nonatomic) NSString *amt;
@property (strong, nonatomic) IBOutlet UILabel *orderId;
@property (strong, nonatomic) IBOutlet UILabel *amount;
@property (strong, nonatomic) IBOutlet UIButton *homeButton;
@property (strong, nonatomic) IBOutlet UIView *containerView;
- (IBAction)home:(id)sender;
@end
