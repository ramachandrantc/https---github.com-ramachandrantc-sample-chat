//
//  ServicesViewController.h
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
#import "ServicesTableViewCell.h"
#import "ActiveNotificationTableViewController.h"
#import "AwardedNotificationTableViewController.h"

@interface ServicesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *filters;
@property (strong, nonatomic) IBOutlet UITableView *services;
@property (strong, nonatomic) IBOutlet UIButton *optionButton;
@property (strong, nonatomic) IBOutlet UILabel *option;
@property (strong, nonatomic) NSMutableArray *options;
@property (strong, nonatomic) NSMutableArray *activeData;
@property (strong, nonatomic) NSMutableArray *acceptedData;
@property (strong, nonatomic) NSMutableArray *tableData;
@property UIActivityIndicatorView *activityView;
@property NSString *selectedOption;

- (IBAction)filter:(id)sender;
@end
