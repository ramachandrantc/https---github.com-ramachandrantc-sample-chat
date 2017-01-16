//
//  ServicesTableViewCell.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/8/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServicesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *applied;
@property (strong, nonatomic) IBOutlet UILabel *jobID;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *service;
@property (strong, nonatomic) IBOutlet UIView *cellView;

@end
