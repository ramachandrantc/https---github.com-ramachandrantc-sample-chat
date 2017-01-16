//
//  ActiveNotificationTableViewController.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/15/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Network/Network.h"
#import "Reachability.h"
#import "MFSideMenu/MFSideMenu.h"
#import "ActiveNotificationTableViewCell.h"
#import "AcceptViewController.h"
#import "TrackViewController.h"
#import "CCWebViewController.h"
#import "AllCommentsTableViewController.h"

@interface ActiveNotificationTableViewController : UITableViewController<AcceptDelegate>

@property (strong, nonatomic) NSMutableArray *tableData;
@property UIActivityIndicatorView *activityView;
@property (strong, nonatomic) NSString *reqId;
@property (strong, nonatomic) AcceptViewController *accept;
@property (strong, nonatomic) NSString *providerName;
@property (strong, nonatomic) NSString *providerId;
@property (strong, nonatomic) NSString *imageUrl;
@end
