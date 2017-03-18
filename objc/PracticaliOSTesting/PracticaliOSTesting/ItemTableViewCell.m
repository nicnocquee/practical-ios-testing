//
//  ItemTableViewCell.m
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/18.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

#import "ItemTableViewCell.h"
#import "Item.h"
#import "ItemView.h"
#import <PureLayout/PureLayout.h>

@interface ItemTableViewCell ()

@property (nonatomic, strong) ItemView *itemView;

@end

@implementation ItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.itemView = [ItemView newAutoLayoutView];
    [self.contentView addSubview:self.itemView];
        
    [self.itemView autoPinEdgesToSuperviewEdges];
}

- (void)setItem:(Item *)item {
    if (_item != item) {
        _item = item;
        
        self.itemView.itemNameLabel.text = _item.itemName;
        self.itemView.itemDescriptionLabel.text = _item.itemDescription;
        self.itemView.itemImage.image = _item.itemImage;
    }
}

@end
