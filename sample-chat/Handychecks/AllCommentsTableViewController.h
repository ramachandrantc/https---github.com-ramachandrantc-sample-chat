//
//  AllCommentsTableViewController.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/13/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Network/Network.h"
#import "Reachability.h"
#import "MFSideMenu/MFSideMenu.h"
#import "CommentHeaderTableViewCell.h"
#import "CommentTableViewCell.h"

@interface AllCommentsTableViewController : UITableViewController
@property UIActivityIndicatorView *activityView;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *ratingCount;
@property (strong, nonatomic) NSString *reviewCount;
@property (strong, nonatomic) NSString *avgRating;
@property (strong, nonatomic) NSString *providerName;
@property (strong, nonatomic) NSString *providerId;
@end
