//
//  APIClient+UnitTests.m
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/17.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

#import "APIClient+UnitTests.h"
#import <OCMock/OCMock.h>

@implementation TestableAPIClient
@end

@implementation APIClient (UnitTests)

+ (TestableAPIClient *)testable {
    // create a mock for APIClient class
    id apiClientMock = OCMClassMock([APIClient class]);
    
    // create a mock for TestableAPIClient class which is a subclass of APIClient
    id testableClient = OCMClassMock([TestableAPIClient class]);
    
    // stub defaultClient method of APIClient and return the testable client. This way, every [APIClient defaultClient] calls will return the TestableAPIClient mock 
    OCMStub([apiClientMock defaultClient]).andReturn(testableClient);
    
    return testableClient;
}

@end
