//
//  ItemView.m
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/18.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

#import "ItemView.h"
#import <PureLayout/PureLayout.h>

@interface ItemView ()

@property (nonatomic, strong) UIImageView *itemImage;
@property (nonatomic, strong) UILabel *itemNameLabel;
@property (nonatomic, strong) UILabel *itemDescriptionLabel;

@end

@implementation ItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithFrame:frame];
    }
    return self;
}

- (void)updateConstraints {
    [self.itemImage autoSetDimensionsToSize:CGSizeMake(40, 40)];
    [self.itemImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [self.itemImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [self.itemNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [self.itemNameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10 relation:NSLayoutRelationEqual];
    [self.itemNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.itemImage withOffset:10];
    
    [self.itemDescriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10 relation:NSLayoutRelationEqual];
    [self.itemDescriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10 relation:NSLayoutRelationGreaterThanOrEqual];
    [self.itemDescriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.itemNameLabel withOffset:10];
    [self.itemDescriptionLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.itemNameLabel];
    
    [super updateConstraints];
}

- (void)setupWithFrame:(CGRect)frame {
    self.itemImage = [UIImageView new];
    self.itemImage.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.itemNameLabel = [UILabel new];
    self.itemNameLabel.numberOfLines = 0;
    self.itemNameLabel.backgroundColor = [UIColor yellowColor];
    self.itemNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.itemNameLabel.preferredMaxLayoutWidth = frame.size.width;
    [self.itemNameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    self.itemDescriptionLabel = [UILabel new];
    self.itemDescriptionLabel.numberOfLines = 0;
    self.itemDescriptionLabel.backgroundColor = [UIColor redColor];
    self.itemDescriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.itemDescriptionLabel.preferredMaxLayoutWidth = frame.size.width;
    [self.itemDescriptionLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    
    [self addSubview:self.itemImage];
    [self addSubview:self.itemNameLabel];
    [self addSubview:self.itemDescriptionLabel];
    
    self.itemImage.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.itemDescriptionLabel.preferredMaxLayoutWidth = self.itemDescriptionLabel.frame.size.width;
    self.itemNameLabel.preferredMaxLayoutWidth = self.itemNameLabel.frame.size.height;
    
    [super layoutSubviews];
}

@end
