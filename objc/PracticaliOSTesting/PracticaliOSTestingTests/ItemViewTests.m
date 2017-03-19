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


/**
 To test: How ItemView looks
 Given: a short item's name and a long item's description
 Expected: Check the reference image in practical-ios-testing/objc/PracticaliOSTesting/PracticaliOSTestingTests/ReferenceImages_64/ItemViewTests/testDefaultViewWithLongDescription@3x.png
 */
- (void)testDefaultViewWithLongDescription {
    // uncomment the following line to generate the reference image for this test
    // self.recordMode = YES;
    
    // create fake Item
    Item *item = [[Item alloc] init];
    item.itemName = @"This is an item name";
    item.itemDescription = @"This is an item description. It could be a very long paragraph. This is the third sentence.";
    item.itemImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"dummy_image" ofType:@"png"]];
    
    // create an instance of ItemView with a fixed width and max height.
    // this instance will be the one we test
    ItemView *itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 0, 320, CGFLOAT_MAX)];
    itemView.backgroundColor = [UIColor whiteColor];
    
    // assign the name, description, and the image to ItemView instance
    itemView.itemImage.image = item.itemImage;
    itemView.itemNameLabel.text = item.itemName;
    itemView.itemDescriptionLabel.text = item.itemDescription;
    
    // lays out the subviews immediately
    [itemView setNeedsLayout];
    [itemView layoutIfNeeded];
    
    // find the height that will enclose the ItemView
    CGSize fittingSize = [itemView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    // set the height of the ItemView instance
    itemView.frame = CGRectMake(0, 0, 320, fittingSize.height);
    
    // compare the instance with the reference image.
    // if self.recordMode = YES, this test will fail but the reference image will be generated.
    // the location of the reference images is set in the Environment Variables (FB_REFERENCE_IMAGE_DIR) of this project's scheme
    FBSnapshotVerifyView(itemView, nil);
}

/**
 To test: How ItemView looks
 Given: a short item's name and a short item's description
 Expected: Check the reference image in practical-ios-testing/objc/PracticaliOSTesting/PracticaliOSTestingTests/ReferenceImages_64/ItemViewTests/testDefaultViewWithShortDescription@3x.png
 */
- (void)testDefaultViewWithShortDescription {
    // uncomment the following line to generate the reference image for this test
    // self.recordMode = YES;
    
    // create fake Itemwith a short description
    Item *item = [[Item alloc] init];
    item.itemName = @"This is an item name";
    item.itemDescription = @"This is an item description.";
    item.itemImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"dummy_image" ofType:@"png"]];
    
    // create an instance of ItemView with a fixed width and max height.
    // this instance will be the one we test
    ItemView *itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 0, 320, 500)];
    itemView.backgroundColor = [UIColor whiteColor];
    
    // assign the name, description, and the image to ItemView instance
    itemView.itemImage.image = item.itemImage;
    itemView.itemNameLabel.text = item.itemName;
    itemView.itemDescriptionLabel.text = item.itemDescription;
    
    // lays out the subviews immediately
    [itemView setNeedsLayout];
    [itemView layoutIfNeeded];
    
    // find the height that will enclose the ItemView
    CGSize fittingSize = [itemView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    // set the height of the ItemView instance
    itemView.frame = CGRectMake(0, 0, 320, fittingSize.height);
    
    // compare the instance with the reference image.
    // if self.recordMode = YES, this test will fail but the reference image will be generated.
    // the location of the reference images is set in the Environment Variables (FB_REFERENCE_IMAGE_DIR) of this project's scheme
    FBSnapshotVerifyView(itemView, nil);
}

/**
 To test: How ItemView looks
 Given: a long item's name and a short item's description
 Expected: Check the reference image in practical-ios-testing/objc/PracticaliOSTesting/PracticaliOSTestingTests/ReferenceImages_64/ItemViewTests/testDefaultViewWithLongName@3x.png
 */
- (void)testDefaultViewWithLongName {
    // uncomment the following line to generate the reference image for this test
    // self.recordMode = YES;
    
    // create fake Item with a long name
    Item *item = [[Item alloc] init];
    item.itemName = @"This is an item with a long name because why not right?";
    item.itemDescription = @"This is an item description.";
    item.itemImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"dummy_image" ofType:@"png"]];
    
    // create an instance of ItemView with a fixed width and max height.
    // this instance will be the one we test
    ItemView *itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 0, 320, 500)];
    itemView.backgroundColor = [UIColor whiteColor];
    
    // assign the name, description, and the image to ItemView instance
    itemView.itemImage.image = item.itemImage;
    itemView.itemNameLabel.text = item.itemName;
    itemView.itemDescriptionLabel.text = item.itemDescription;
    
    // lays out the subviews immediately
    [itemView setNeedsLayout];
    [itemView layoutIfNeeded];
    
    // find the height that will enclose the ItemView
    CGSize fittingSize = [itemView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    // set the height of the ItemView instance
    itemView.frame = CGRectMake(0, 0, 320, fittingSize.height);
    
    // compare the instance with the reference image.
    // if self.recordMode = YES, this test will fail but the reference image will be generated.
    // the location of the reference images is set in the Environment Variables (FB_REFERENCE_IMAGE_DIR) of this project's scheme
    FBSnapshotVerifyView(itemView, nil);
}

@end
