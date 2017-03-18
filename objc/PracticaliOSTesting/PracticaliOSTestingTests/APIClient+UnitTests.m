//
//  APIClient+UnitTests.m
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/17.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

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
