### Mock singleton using OCMock. 

Say we have `APIClient` class:

  ```objc
  // APIClient.h
  @interface APIClient : NSObject <NSURLSessionDelegate>

  + (instancetype)defaultClient;
  - (void)fetchItemsWithCallback:(void(^)(NSArray *result))callback;
  @end

  // APIClient.m
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

Case: When a button is tapped, the app calls an API to get a list of items. 

To Test: We want to test the `didTapFetchItemsButton:` method of `ViewController` class. 

Expectation: When the method is called, it should call `showItems` method when there is no error. Otherwise, it should call `showErrorAlert` method. 

Check `ViewController.m` in the sample project. `didTapFetchItemsButton:` is implemented as follows.

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

Case: `ViewController` has a block property called `onCancelCallback`. 

To test: `didTapCancelButton` method.

Expectation: We want to make sure when `didTapCancelButton` is called, `onCancelCallback` is also called.

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

Case: `ViewController` has `didTapSaveItem` method. In that method, an instance of `Item` class is created.
 
To test: Call `didTapSaveItem` method.

Expectation: When `didTapSaveItem` of `ViewController` instance is called, we want an instance of `Item` class to be created and its `saveItem` method to be called.

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

### Test custom UIView with snapshot testing

Case: We have a custom view called `ItemView` to show the image of the item, the name of the item, and the description of the item.

To test: `ItemView` render.

Expectation: `ItemView` view should look like the following.

![](https://github.com/nicnocquee/practical-ios-testing/blob/master/objc/PracticaliOSTesting/PracticaliOSTestingTests/ReferenceImages_64/ItemViewTests/testDefaultViewWithLongDescription@3x.png?raw=true)

To test this we need to use [FBSnapshotTestCase](https://github.com/facebook/ios-snapshot-test-case):

1. Subclass `FBSnapshotTestCase` instead of `XCTestCase`
2. Add `self.recordMode = YES;` to generate the reference image.
3. Remove `self.recordMode = YES;` to actually test the view.

```objc
// ItemViewTests.m
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
```

### Test custom UITableViewCell

Case: We have `ItemTableViewCell` class which is a custom `UITableViewCell`.

Given: Editing mode in the table view.

Expected: The cell should look like the following.

![](https://github.com/nicnocquee/practical-ios-testing/blob/master/objc/PracticaliOSTesting/PracticaliOSTestingTests/ReferenceImages_64/ItemTableViewControllerTests/testEditCellView@3x.png?raw=true)

Just like [snapshot testing for the custom UIView](https://github.com/nicnocquee/practical-ios-testing/blob/master/objc.md#test-custom-uiview-with-snapshot-testing), we need to use FBSnapshotTestCase again. 

Unlike the custom UIView testing, we don't instantiate `ItemTableViewCell` directly. Instead, we create `ItemsTableViewController` instance and get the cell for testing using `cellForRowAtIndexPath` method of `UITableView`.

 ```objc
 // ItemTableViewControllerTests.m
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
 ```

 ### Test View Controller's View

 Case: We have `ItemsTableViewController` class.

 To test: The view of `ItemsTableViewController` instance.

 Expected: The view should look like the following

 ![](https://github.com/nicnocquee/practical-ios-testing/blob/master/objc/PracticaliOSTesting/PracticaliOSTestingTests/ReferenceImages_64/ItemTableViewControllerTests/testDefaultView@3x.png?raw=true)

 ```objc
// ItemTableViewControllerTests.m
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
 ```

 ### Test invocation of third party library

 Case: When `saveItem` instance method of `Item` class is called, the app will send analytics event to [Firebase](https://firebase.google.com/docs/analytics/ios/start).
 
 To test: `saveItem` method of `Item` class.
 
 Expected: `logEventWithName:parameters:` class method of `FIRAnalytics` should be called.

 In the sample project, Firebase library is installed via Cocoapods. But for some reasons, I cannot import Firebase in the unit test target. (If you know how to do this, please let me know!). Since Firebase cannot be imported, we cannot create the mock using `OCMClassMock([FIRAnalytics class])`. But there is a workaround thanks to Objective-c's dynamic nature. All we need to do is to create `FIRAnalytics` class using `NSClassFromString(@"FIRAnalytics")`

 ```objc
 // ItemTests.m

 // we need the following category so that we can compile the project successfully
@interface NSObject (TestableFIRAnalytics)
+ (void)logEventWithName:(nonnull NSString *)name
              parameters:(nullable NSDictionary<NSString *, NSObject *> *)parameters;
@end


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
 ```