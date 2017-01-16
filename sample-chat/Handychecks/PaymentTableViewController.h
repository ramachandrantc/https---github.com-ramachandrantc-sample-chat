//
//  PaymentTableViewController.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/7/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Network/Network.h"
#import "SHEmailValidator.h"
#import "SHAutocorrectSuggestionView.h"
#import "Reachability.h"
#import "MFSideMenu/MFSideMenu.h"
#import "PaymentTableViewCell.h"
#import "CCWebViewController.h"

@interface PaymentTableViewController : UITableViewController
@property UIActivityIndicatorView *activityView;
@property (strong, nonatomic) NSMutableArray *data;

@end
