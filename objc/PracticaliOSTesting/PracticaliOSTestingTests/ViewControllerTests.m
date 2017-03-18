//
//  ViewControllerTests.m
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/17.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "APIClient+UnitTests.h"
#import "Item.h"
#import <OCMock/OCMock.h>

@interface ViewController (Testable)
// Expose the following methods so we can test it
- (void)showErrorAlert:(NSError *)error;
- (void)showItems:(id)items;

@end

@interface ViewControllerTests : XCTestCase

@end

@implementation ViewControllerTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}


/**
 To test: didTapFetchItemsButton
 Given: A result and NO Error from API call
 Expected: showItems method should be called
 */
- (void)testDidTapFetchItemsButtonSuccess {
    // create a mock APIClient
    id testableAPIClient = [APIClient testable];
    
    // create a fake result for testing
    NSString *fakeResult = @"This is a result";
    
    // expect fetchItemsWithCallback: to be called and invoke the callback block
    OCMExpect([testableAPIClient fetchItemsWithCallback:([OCMArg invokeBlockWithArgs:fakeResult, [NSNull null], nil])]);
    
    // initiate the ViewController for testing
    ViewController *viewController = [[ViewController alloc] init];
    
    // partially mock the ViewController instance
    id partialViewControllerMock = OCMPartialMock(viewController);
    
    // expect showItems to be called with the fake result for testing
    OCMExpect([partialViewControllerMock showItems:fakeResult]);
    
    // test didTapFetchItemsButton
    [partialViewControllerMock didTapFetchItemsButton:nil];
    
    // verify expectations of APIClient mock
    OCMVerifyAll(testableAPIClient);
    
    // verify expectations of partial mock of ViewController instance after a delay. Add delay because the showItems method is called inside dispatch_async
    OCMVerifyAllWithDelay(partialViewControllerMock, 1);
}

/**
 To test: didTapFetchItemsButton
 Given: No result and and an Error from API call
 Expected: showErrorAlert method should be called
 */
- (void)testDidTapFetchItemsButtonError {
    // create a mock APIClient
    id testableAPIClient = [APIClient testable];
    
    // create a fake error for testing
    NSError *fakeError = [NSError errorWithDomain:@"domain" code:404 userInfo:nil];
    
    // expect fetchItemsWithCallback: to be called and invoke the callback block
    OCMExpect([testableAPIClient fetchItemsWithCallback:([OCMArg invokeBlockWithArgs:[NSNull null], fakeError, nil])]);
    
    // initiate the ViewController for testing
    ViewController *viewController = [[ViewController alloc] init];
    
    // partially mock the ViewController instance
    id partialViewControllerMock = OCMPartialMock(viewController);
    
    // expect showErrorAlert to be called
    OCMExpect([partialViewControllerMock showErrorAlert:fakeError]);
    
    // test didTapFetchItemsButton
    [partialViewControllerMock didTapFetchItemsButton:nil];
    
    // verify expectations of APIClient mock
    OCMVerifyAll(testableAPIClient);
    
    // verify expectations of partial mock of ViewController instance after a delay. Add delay because the showItems method is called inside dispatch_async
    OCMVerifyAllWithDelay(partialViewControllerMock, 1);
}


/**
 To test: didTapCancelButton
 Given: onCancelCallback block
 Expected: onCancelCallback block should be invoked
 */
- (void)testOnCancelCallback {
    // initiate the ViewController for testing
    ViewController *viewController = [[ViewController alloc] init];
    
    // create expectation
    XCTestExpectation *callbackExpect = [self expectationWithDescription:@"callback expectation"];
    
    // assign a dummy callback to viewController and fulfill the expectation in it
    viewController.onCancelCallback = ^{
        // if this block is invoked, we fulfill the expectation and the test will pass.
        // if you try removing the onCancelCallback invocation in didTapCancelButton method, this test will fail.
        [callbackExpect fulfill];
    };
    
    // test didTapCancelButton
    [viewController didTapCancelButton];
    
    // wait for the expectation to be fulfilled
    [self waitForExpectationsWithTimeout:0.5 handler:nil];
}


/**
 To test: didSaveItem
 Given: None
 Expected: An Item instance should be created and its saveItem method is called
 */
- (void)testDidTapSaveItem {
    // initiate the ViewController for testing
    ViewController *viewController = [[ViewController alloc] init];
    
    // mock Item class
    id mockItem = OCMClassMock([Item class]);
    
    // stub Item's alloc and return the mock
    OCMStub([mockItem alloc]).andReturn(mockItem);
    
    // expect saveItem method to be called
    OCMExpect([mockItem saveItem]);
    
    // test didTapSaveItem
    [viewController didTapSaveItem];
    
    // verify expectation
    OCMVerify([mockItem saveItem]);
}

@end
