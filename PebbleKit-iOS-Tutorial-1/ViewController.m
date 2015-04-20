//
//  ViewController.m
//  PebbleKit-iOS-Tutorial-1
//
//  Created by Chris Lewis on 11/25/14.
//  Copyright (c) 2014 Pebble. All rights reserved.
//

#import "ViewController.h"
#import "PebbleKit/PebbleKit.h"
#import "AppDelegate.h"

@interface ViewController () <PBPebbleCentralDelegate>

@property PBWatch *watch;

@property (weak, nonatomic) IBOutlet UILabel *outputLabel;
@property (weak, nonatomic) IBOutlet UIButton *sportsButton;
@property (weak, nonatomic) IBOutlet UIButton *sendDataButton;

@end

@implementation ViewController

- (IBAction)launchButtonPressed:(id)sender {
    // Set the communication UUID
    [[PBPebbleCentral defaultCentral] setAppUUID:PBSportsUUID];
    
    // Launch Sports watchapp
    [self.watch sportsAppLaunch:^(PBWatch *watch, NSError *error) {
        if (error) {
            // Show the error
            [self.outputLabel setText:error.localizedDescription];
        } else {
            [self.outputLabel setText:@"App launched!"];
        }
    }];
}

- (IBAction)dataButtonPressed:(id)sender {
    // Make dictionary of data
    NSDictionary *updateDict = @{ PBSportsTimeKey: @"12:52", PBSportsDistanceKey: @"23.8"};
    
    // Send to watch
    [self.watch sportsAppUpdate:updateDict onSent:^(PBWatch *watch, NSError *error) {
        if (error) {
            // Show the error
            [self.outputLabel setText:error.localizedDescription];
        } else {
            [self.outputLabel setText:@"Data sent OK!"];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get reference to watch
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.watch = [delegate getConnectedWatch];
    
    // Check the watch object is available
    if(self.watch) {
        // Check AppMessage is supported by this watch
        [self.watch appMessagesGetIsSupported:^(PBWatch *watch, BOOL isAppMessagesSupported) {
            if(isAppMessagesSupported) {
                // Tell the user using the Label
                [self.outputLabel setText:@"AppMessage is supported!"];
            } else {
                [self.outputLabel setText:@"AppMessage is NOT supported!"];
            }
        }];
        
        // Register UUID
        [[PBPebbleCentral defaultCentral] setAppUUID:PBSportsUUID];
        
        // Register to get messages from watch
        [self.watch sportsAppAddReceiveUpdateHandler:^BOOL(PBWatch *watch, SportsAppActivityState state) {
            // Display the new state of the watchapp
            switch (state) {
                case SportsAppActivityStateRunning:
                    [self.outputLabel setText:@"Watchapp now RUNNING."];
                    break;
                case SportsAppActivityStatePaused:
                    [self.outputLabel setText:@"Watchapp now PAUSED."];
                    break;
                default:
                    [self.outputLabel setText:@"UNKNOWN CASE"];
                    break;
            }
            
            // Finally
            return YES;
        }];
    } else {
        [self.outputLabel setText:@"No Pebble watch available!"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
