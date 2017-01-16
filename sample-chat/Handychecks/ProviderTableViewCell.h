//
//  ProviderTableViewCell.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/8/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ProviderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *service;
@property (strong, nonatomic) IBOutlet UILabel *serviceID;
@property (strong, nonatomic) IBOutlet UILabel *provider;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UIButton *rateButton;
@property (strong, nonatomic) IBOutlet UIView *cellView;

@end
