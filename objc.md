### Mock singleton using OCMock. 

  Check the file `APIClient+UnitTests.h` in the sample project. Say we have `APIClient` class:

  ```objc
  @interface APIClient : NSObject <NSURLSessionDelegate>

  + (instancetype)defaultClient;
  - (void)fetchItemsWithCallback:(void(^)(NSArray *result))callback;
  @end

  @implementation APIClient
  + (instancetype)defaultClient {
      static APIClient *_sharedClient = nil;
      static dispatch_once_t onceToken;
      dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] init];
      });
    
      return _sharedClient;
  }
  @end
  ```

  And in other part of our application we call the `fetchItemsWithCallback:` method using the APIClient singleton:

  ```objc
  // ViewController.m
  [[APIClient defaultClient] fetchItemsWithCallback:^(id result, NSError *error) {
    // ... do something
  }]
  ```

  To mock `fetchItemsWithCallback:` method, we need to mock the `APIClient`'s `defaultClient`:

  ```objc
  // APIClient+UnitTests.h
  @interface APIClient (UnitTests)
  + (id)testable;
  @end

  // APIClient+UnitTests.m
  #import "APIClient+UnitTests.h"
  #import <OCMock/OCMock.h>

  @implementation APIClient (UnitTests)

  + (id)testable {
      // create a mock for APIClient class
      id apiClientMock = OCMClassMock([APIClient class]);
      
      // stub defaultClient method of APIClient and return the APIClient mock 
      OCMStub([apiClientMock defaultClient]).andReturn(apiClientMock);
      
      return apiClientMock;
  }

  @end

  // in the test file
  // stub or create expectations using the testableClient
  id testableAPIClient = [APIClient testable];
  OCMExpect([testableAPIClient fetchItemsWithCallback:([OCMArg any]);
  ```

### Test asynchronous callback.

  Scenario: When a button is tapped, the app calls an API to get a list of items. We want to test the `didTapFetchItemsButton:` method of `ViewController` class. When the method is called, it should call `showItems` method when there is no error. Otherwise, it should call `showErrorAlert` method. Check `ViewController.m` in the sample project. `didTapFetchItemsButton:` is implemented as follows.

  ```objc
  // ViewController.m
  - (void)didTapFetchItemsButton:(id)sender {
    __weak typeof (self) weakSelf = self;
    [[APIClient defaultClient] fetchItemsWithCallback:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [weakSelf showErrorAlert:error];
            } else {
                [weakSelf showItems:result];
            }
        });
    }];
  }
  ```

  To test this scenario, we need to:

  1. Mock the `APIClient`'s `fetchItemsWithCallback` and call the callback block with a non-nil error in one case, and nil error in another.
  2. Partially mock the instance of `ViewController` to check if `showItems` and `showErrorAlert` are called.

  ```objc
  // ViewControllerTests.m
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
  ```

### Test block property invocation

Scenario: `ViewController` has a block property called `onCancelCallback`. We want to make sure when `didTapCancelButton` is called, `onCancelCallback` is also called.

We can use `XCTestExpectation` to test this. Check `testOnCancelCallback` in `ViewControllerTests.m` 

```objc
// ViewControllerTests.m
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
```

### Test mocking an instance inside a method

Scenario: When `didTapSaveItem` of `ViewController` instsance is called, we want an instance of `Item` class to be created and its `saveItem` method to be called.

```objc
// ViewController.m
- (void)didTapSaveItem {
    Item *item = [[Item alloc] init];
    [item saveItem];
}
```

To test this, we need to:

1. mock the `Item` class.
2. stub the `alloc` method to return the mock object.
3. create expectation for method `saveItem`

```objc
// ViewControllerTests.m
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
```