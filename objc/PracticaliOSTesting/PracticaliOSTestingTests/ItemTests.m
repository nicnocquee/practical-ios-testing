//
//  ItemTests.m
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/19.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Item.h"

// we need the following category so that we can compile the project successfully
@interface NSObject (TestableFIRAnalytics)
+ (void)logEventWithName:(nonnull NSString *)name
              parameters:(nullable NSDictionary<NSString *, NSObject *> *)parameters;
@end

@interface ItemTests : XCTestCase

@end

@implementation ItemTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


/**
 Case: When saveItem method of Item class is called, the app should send analytics event to Firebase 
 To test: saveItem method of Item class
 Expected: FIRAnalytics' logEventWithName:parameters: should be called
 */
- (void)testSaveItem {
    // create fake Item
    Item *item = [[Item alloc] init];
    item.itemName = @"This is an item name";
    item.itemDescription = @"This is an item description. It could be a very long paragraph. This is the third sentence.";
    item.itemImage = [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"dummy_image" ofType:@"png"]];
    
    // create FIRAnalytics mock
    Class analyticsClass = NSClassFromString(@"FIRAnalytics");
    id firAnalyticsMock = OCMClassMock(analyticsClass);
    
    // create expected parameters to be passed into logEventWithName:parameters:
    NSDictionary *expectedParameters = @{
                                         @"item_id": @"id-This is an item name",
                                         @"item_name": @"This is an item name",
                                         @"content_type": @"image"
                                         };
    
    // expect logEventWithName:parameters: to be called with select_content name any parameters
    OCMExpect([firAnalyticsMock logEventWithName:@"select_content" parameters:expectedParameters]);
    
    // call the method to test
    [item saveItem];
    
    // verify expectation
    OCMVerifyAll(firAnalyticsMock);
}


@end
