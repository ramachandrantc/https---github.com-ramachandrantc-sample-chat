//
//  CommentHeaderTableViewCell.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/21/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"

@interface CommentHeaderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *provider;

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet EDStarRating *starRating;
@property (strong, nonatomic) IBOutlet UILabel *reviewNo;
@property (strong, nonatomic) IBOutlet UILabel *commentNo;
@end
