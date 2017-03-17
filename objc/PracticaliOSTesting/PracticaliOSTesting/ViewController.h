//
//  ViewController.h
//  PracticaliOSTesting
//
//  Created by Nico Prananta on 2017/03/17.
//  Copyright © 2017 DelightfulDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, copy) void (^onCancelCallback)();

- (IBAction)didTapFetchItemsButton:(id)sender;
- (void)didTapCancelButton;

@end

