//
//  ProvidersTableViewController.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/8/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Network/Network.h"
#import "SHEmailValidator.h"
#import "SHAutocorrectSuggestionView.h"
#import "Reachability.h"
#import "MFSideMenu/MFSideMenu.h"
#import "ProviderTableViewCell.h"
#import "RateViewController.h"

@interface ProvidersTableViewController : UITableViewController<RateDelegate>
@property UIActivityIndicatorView *activityView;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) RateViewController *rate;
@end
