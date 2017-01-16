//
//  ActiveNotificationTableViewCell.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/15/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"

@interface ActiveNotificationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *overallRating;
@property (strong, nonatomic) IBOutlet UIButton *acceptButton;
@property (strong, nonatomic) IBOutlet UILabel *reviewCount;
@property (strong, nonatomic) IBOutlet EDStarRating *starRating;
@property (strong, nonatomic) IBOutlet UIView *cellView;

@end
