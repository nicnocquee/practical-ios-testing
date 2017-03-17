//
//  ViewController.m
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/17.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

#import "ViewController.h"
#import "APIClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

- (void)showErrorAlert:(NSError *)error {
    
}

- (void)showItems:(id)items {
    
}

- (void)didTapCancelButton {
    if (self.onCancelCallback) {
        self.onCancelCallback();
    }
}

@end
