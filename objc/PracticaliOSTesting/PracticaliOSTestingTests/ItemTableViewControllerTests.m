//
//  ItemTableViewControllerTests.m
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/18.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

#import "ItemsTableViewController.h"
#import "Item.h"
#import "ItemTableViewCell.h"

@interface ItemTableViewControllerTests : FBSnapshotTestCase

@end

@implementation ItemTableViewControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDefaultView {
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:20];
    for (int i = 0; i < 20; i++) {
        Item *item = [[Item alloc] init];
        item.itemName = [NSString stringWithFormat:@"This is item %d", i];
        item.itemDescription = [NSString stringWithFormat:@"This is the description of item %d. This the second sentence of this description.", i];
        item.itemImage = [UIImage imageNamed:@"dummy_image.png"];
        [items addObject:item];
    }
    ItemsTableViewController *tableVC = [[ItemsTableViewController alloc] init];
    tableVC.items = items;
    tableVC.edgesForExtendedLayout = UIRectEdgeNone;
    tableVC.automaticallyAdjustsScrollViewInsets = YES;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tableVC];
    
    FBSnapshotVerifyView(navigationController.view, nil);
}

@end
