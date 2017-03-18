//
//  ItemView.h
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/18.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemView : UIView

@property (nonatomic, readonly) UIImageView *itemImage;
@property (nonatomic, readonly) UILabel *itemNameLabel;
@property (nonatomic, readonly) UILabel *itemDescriptionLabel;

@end
