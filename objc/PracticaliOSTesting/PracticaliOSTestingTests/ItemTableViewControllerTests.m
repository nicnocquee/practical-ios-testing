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

/**
 To test: ItemsTableViewController view
 Given: 20 Item objects
 Expected: Check the reference image in practical-ios-testing/objc/PracticaliOSTesting/PracticaliOSTestingTests/ReferenceImages_64/ItemTableViewControllerTests/testDefaultView@3x.png
 */
- (void)testDefaultView {
    // create fake Item objects
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:20];
    for (int i = 0; i < 20; i++) {
        Item *item = [[Item alloc] init];
        item.itemName = [NSString stringWithFormat:@"This is item %d", i];
        item.itemDescription = [NSString stringWithFormat:@"This is the description of item %d. This the second sentence of this description.", i];
        item.itemImage = [UIImage imageNamed:@"dummy_image.png"];
        [items addObject:item];
    }
    
    // instantiate ItemsTableViewController
    ItemsTableViewController *tableVC = [[ItemsTableViewController alloc] init];
    tableVC.edgesForExtendedLayout = UIRectEdgeNone;
    tableVC.automaticallyAdjustsScrollViewInsets = YES;
    
    // assign the items
    tableVC.items = items;
    [tableVC.tableView reloadData];
    
    // embed ItemsTableViewController in a navigation controller
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tableVC];
    
    // verify view
    FBSnapshotVerifyView(navigationController.view, nil);
}

/**
 To test: ItemTableViewCell view
 Given: Table view in editing mode
 Expected: Check the reference image in practical-ios-testing/objc/PracticaliOSTesting/PracticaliOSTestingTests/ReferenceImages_64/ItemTableViewControllerTests/testEditCellView@3x.png
 */
- (void)testEditCellView {    
    // create fake Item
    Item *item = [[Item alloc] init];
    item.itemName = @"This is an item name";
    item.itemDescription = @"This is an item description. It could be a very long paragraph. This is the third sentence.";
    item.itemImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"dummy_image" ofType:@"png"]];
    
    // instantiate the ItemsTableViewController
    ItemsTableViewController *tableVC = [[ItemsTableViewController alloc] init];
    tableVC.items = @[item];
    [tableVC.tableView reloadData];
    
    // enable editing mode
    tableVC.editing = YES;
    
    // get the cell from table view
    ItemTableViewCell *cell = (ItemTableViewCell *)[tableVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    // verify the cell
    FBSnapshotVerifyView(cell, nil);
}

/**
 To test: ItemTableViewCell view
 Given: Table view in normal mode (non-edit)
 Expected: Check the reference image in practical-ios-testing/objc/PracticaliOSTesting/PracticaliOSTestingTests/ReferenceImages_64/ItemTableViewControllerTests/testDefaultCellView@3x.png
 */
- (void)testDefaultCellView {
    // create fake Item
    Item *item = [[Item alloc] init];
    item.itemName = @"This is an item name";
    item.itemDescription = @"This is an item description. It could be a very long paragraph. This is the third sentence.";
    item.itemImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"dummy_image" ofType:@"png"]];
    
    // instantiate the ItemsTableViewController
    ItemsTableViewController *tableVC = [[ItemsTableViewController alloc] init];
    tableVC.items = @[item];
    [tableVC.tableView reloadData];
    
    // get the cell from table view
    ItemTableViewCell *cell = (ItemTableViewCell *)[tableVC.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    // verify the cell
    FBSnapshotVerifyView(cell, nil);
}

@end
