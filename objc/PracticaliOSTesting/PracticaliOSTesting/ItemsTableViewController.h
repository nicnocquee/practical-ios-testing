//
//  ItemsTableViewController.h
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/18.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Item.h"

@interface ItemsTableViewController : UITableViewController

@property (nonatomic, copy) NSArray <Item *>* items;

@end
