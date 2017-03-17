- Mock singleton using OCMock. Check the file `APIClient+UnitTests.h` in the sample project. Say we have `APIClient` class:

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
    [[APIClient defaultClient] fetchItemsWithCallback:^(id result, NSError *error) {
      // ... do something
    }]
    ```

    To mock `fetchItemsWithCallback:` method, we need to mock the `APIClient`'s `defaultClient`:

  ```objc
  #import <OCMock/OCMock.h>

  @interface TestableAPIClient : APIClient
  @end

  @implementation TestableAPIClient
  @end

  id apiClientMock = OCMClassMock([APIClient class]);
    
  // create a mock for TestableAPIClient class which is a subclass of APIClient
  id testableClient = OCMClassMock([TestableAPIClient class]);
    
  // stub defaultClient method of APIClient and return the testable client. This way, every [APIClient defaultClient] calls will return the TestableAPIClient mock 
  OCMStub([apiClientMock defaultClient]).andReturn(testableClient);

  // stub or create expectations using the testableClient
  OCMExpect([testableAPIClient fetchItemsWithCallback:([OCMArg any]);
  ```