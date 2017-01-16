//
//  WalletViewController.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/7/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu/MFSideMenu.h"
#import "PaymentTableViewController.h"
#import "PaidServicesTableViewController.h"

@interface WalletViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *paymentButton;
@property (strong, nonatomic) IBOutlet UIButton *paidHistoryButton;

- (IBAction)payment:(id)sender;
- (IBAction)paidHistory:(id)sender;
@end
