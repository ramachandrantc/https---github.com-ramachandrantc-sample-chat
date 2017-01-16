//
//  PaymentTableViewCell.m
//  Handychecks
//
//  Created by Shrishti Informatics on 12/7/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "PaymentTableViewCell.h"

@implementation PaymentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cellView.layer.cornerRadius = 4.0;
    self.paymentButton.layer.cornerRadius = 4.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
