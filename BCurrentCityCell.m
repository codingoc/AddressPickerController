//
//  BCurrentCityCell.m
//  Bee
//
//  Created by 林洁 on 16/1/12.
//  Copyright © 2016年 Lin. All rights reserved.
//

#import "BCurrentCityCell.h"
#import "BAddressHeader.h"

@implementation BCurrentCityCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BG_CELL;
        [self.contentView addSubview:self.GPSButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Event Response
- (void)buttonWhenClick:(void (^)(UIButton *))block{
    self.buttonClickBlock = block;
}

- (void)buttonClick:(UIButton*)button{
    self.buttonClickBlock(button);
}

#pragma mark - Getter and Setter
- (UIButton*)GPSButton{
    if (_GPSButton == nil) {
        _GPSButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _GPSButton.frame = CGRectMake(15, 15 , BUTTON_WIDTH, BUTTON_HEIGHT);
        [_GPSButton setTitle:@"嘉善" forState:UIControlStateNormal];
        _GPSButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _GPSButton.tintColor = [UIColor blackColor];
        _GPSButton.backgroundColor = [UIColor whiteColor];
        _GPSButton.alpha = 0.8;
        _GPSButton.layer.borderColor = [UIColorFromRGBA(237, 237, 237, 1.0) CGColor];
        _GPSButton.layer.borderWidth = 1;
        _GPSButton.layer.cornerRadius = 3;
        [_GPSButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _GPSButton;
}

@end
