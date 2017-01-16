//
//  PaidServicesTableViewCell.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/7/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaidServicesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *paymentID;
@property (strong, nonatomic) IBOutlet UILabel *orderID;
@property (strong, nonatomic) IBOutlet UILabel *paymentAmount;
@property (strong, nonatomic) IBOutlet UILabel *paymentDate;
@property (strong, nonatomic) IBOutlet UILabel *paymentTime;
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UILabel *requestID;
@property (strong, nonatomic) IBOutlet UIView *cellView;

@end
