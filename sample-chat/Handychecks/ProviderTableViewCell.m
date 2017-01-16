//
//  ProviderTableViewCell.m
//  Handychecks
//
//  Created by Shrishti Informatics on 12/8/16.
//  Copyright © 2016 Shrishti Informatics. All rights reserved.
//

#import "ProviderTableViewCell.h"

@implementation ProviderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cellView.layer.cornerRadius = 4.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
