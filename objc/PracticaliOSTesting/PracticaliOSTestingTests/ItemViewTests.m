//
//  ItemTableViewCellTests.m
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/18.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import "Item.h"
#import "ItemView.h"

@interface ItemViewTests : FBSnapshotTestCase

@end

@implementation ItemViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDefaultViewWithLongDescription {    
    Item *item = [[Item alloc] init];
    item.itemName = @"This is an item name";
    item.itemDescription = @"This is an item description. It could be a very long paragraph. This is the third sentence.";
    item.itemImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"dummy_image" ofType:@"png"]];
    
    ItemView *itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 0, 320, 500)];
    itemView.backgroundColor = [UIColor whiteColor];
    itemView.itemImage.image = item.itemImage;
    itemView.itemNameLabel.text = item.itemName;
    itemView.itemDescriptionLabel.text = item.itemDescription;
    
    [itemView setNeedsUpdateConstraints];
    [itemView updateConstraintsIfNeeded];
    
    CGSize fittingSize = [itemView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    itemView.frame = CGRectMake(0, 0, 320, fittingSize.height);
    
    FBSnapshotVerifyView(itemView, nil);
}

- (void)testDefaultViewWithShortDescription {
    Item *item = [[Item alloc] init];
    item.itemName = @"This is an item name";
    item.itemDescription = @"This is an item description.";
    item.itemImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"dummy_image" ofType:@"png"]];
    
    ItemView *itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 0, 320, 500)];
    itemView.backgroundColor = [UIColor whiteColor];
    itemView.itemImage.image = item.itemImage;
    itemView.itemNameLabel.text = item.itemName;
    itemView.itemDescriptionLabel.text = item.itemDescription;
    
    [itemView setNeedsUpdateConstraints];
    [itemView updateConstraintsIfNeeded];
    
    CGSize fittingSize = [itemView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    itemView.frame = CGRectMake(0, 0, 320, fittingSize.height);
    
    FBSnapshotVerifyView(itemView, nil);
}

- (void)testDefaultViewWithLongName {
    Item *item = [[Item alloc] init];
    item.itemName = @"This is an item with a long name because why not right?";
    item.itemDescription = @"This is an item description.";
    item.itemImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"dummy_image" ofType:@"png"]];
    
    ItemView *itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 0, 320, 500)];
    itemView.backgroundColor = [UIColor whiteColor];
    itemView.itemImage.image = item.itemImage;
    itemView.itemNameLabel.text = item.itemName;
    itemView.itemDescriptionLabel.text = item.itemDescription;
    
    [itemView setNeedsUpdateConstraints];
    [itemView updateConstraintsIfNeeded];
    
    CGSize fittingSize = [itemView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    itemView.frame = CGRectMake(0, 0, 320, fittingSize.height);
    
    FBSnapshotVerifyView(itemView, nil);
}

@end
