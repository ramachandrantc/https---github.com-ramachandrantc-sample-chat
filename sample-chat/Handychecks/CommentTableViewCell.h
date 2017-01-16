//
//  CommentTableViewCell.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/21/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating/EDStarRating.h"

@interface CommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *customer;
@property (strong, nonatomic) IBOutlet UILabel *jobID;
@property (strong, nonatomic) IBOutlet EDStarRating *starRating;
@property (strong, nonatomic) IBOutlet UILabel *dateTime;
@property (strong, nonatomic) IBOutlet UITextView *comment;
@property (strong, nonatomic) IBOutlet UILabel *provider;
@property (strong, nonatomic) IBOutlet UIImageView *replyImage;
@property (strong, nonatomic) IBOutlet UITextView *reply;
@end
