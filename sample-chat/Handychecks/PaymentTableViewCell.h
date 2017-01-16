//
//  PaymentTableViewCell.h
//  Handychecks
//
//  Created by Shrishti Informatics on 12/7/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *jobID;
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UILabel *amount;
@property (strong, nonatomic) IBOutlet UIButton *paymentButton;
@property (strong, nonatomic) IBOutlet UIView *cellView;

@end
