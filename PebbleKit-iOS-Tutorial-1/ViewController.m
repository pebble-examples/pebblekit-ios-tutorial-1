//
//  ViewController.m
//  PebbleKit-iOS-Tutorial-1
//
//  Created by Chris Lewis on 11/25/14.
//  Copyright (c) 2014 Pebble. All rights reserved.
//

#import "ViewController.h"
#import "PebbleKit/PebbleKit.h"

@interface ViewController () <PBPebbleCentralDelegate>

@property (weak, nonatomic) PBWatch *watch;
@property (weak, nonatomic) PBPebbleCentral *central;

@property (weak, nonatomic) IBOutlet UILabel *outputLabel;
@property (weak, nonatomic) IBOutlet UIButton *sportsButton;
@property (weak, nonatomic) IBOutlet UIButton *sendDataButton;

@end

@implementation ViewController

- (IBAction)launchButtonPressed:(id)sender {
    // Launch Sports watchapp
    [self.watch sportsAppLaunch:^(PBWatch *watch, NSError *error) {
        if (error) {
            // Show the error
            self.outputLabel.text = error.localizedDescription;
        } else {
            self.outputLabel.text = @"App launched!";
        }
    }];
}

- (IBAction)dataButtonPressed:(id)sender {
    // Make dictionary of data
    NSDictionary *updateDict = @{PBSportsTimeKey: @"12:52", PBSportsDistanceKey: @"23.8"};
    
    // Send to watch
    [self.watch sportsAppUpdate:updateDict onSent:^(PBWatch *watch, NSError *error) {
        if (error) {
            // Show the error
            self.outputLabel.text = error.localizedDescription;
        } else {
            self.outputLabel.text = @"Data sent OK!";
        }
    }];
}

- (void)pebbleCentral:(PBPebbleCentral *)central watchDidConnect:(PBWatch *)watch isNew:(BOOL)isNew {
    if (self.watch) {
        return;
    }
    self.watch = watch;
    self.outputLabel.text = @"Watch connected!";
    
    // Check AppMessage is supported by this watch
    [self.watch appMessagesGetIsSupported:^(PBWatch *watch, BOOL isAppMessagesSupported) {
        if(isAppMessagesSupported) {
            // Tell the user using the Label
            self.outputLabel.text = @"AppMessage is supported!";
        } else {
            self.outputLabel.text = @"AppMessage is NOT supported!";
        }
    }];
    
    // Keep a weak reference to self to prevent it staying around forever
    __weak typeof(self) welf = self;
    
    // Register to get messages from watch
    [self.watch sportsAppAddReceiveUpdateHandler:^BOOL(PBWatch *watch, SportsAppActivityState state) {
        __strong typeof(welf) sself = welf;
        if(!sself) {
            // self has been destroyed
            return NO;
        }
        
        // Display the new state of the watchapp
        switch (state) {
            case SportsAppActivityStateRunning:
                sself.outputLabel.text = @"Watchapp now RUNNING.";
                break;
            case SportsAppActivityStatePaused:
                sself.outputLabel.text = @"Watchapp now PAUSED.";
                break;
            default:
                sself.outputLabel.text = @"UNKNOWN CASE";
                break;
        }
        
        // Finally
        return YES;
    }];
}

-(void)pebbleCentral:(PBPebbleCentral *)central watchDidDisconnect:(PBWatch *)watch {
    // Only remove reference if it was the current active watch
    if(self.watch == watch) {
        self.watch = nil;
        self.outputLabel.text = @"Watch disconnected";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the delegate to receive PebbleKit events
    self.central = [PBPebbleCentral defaultCentral];
    self.central.delegate = self;
    
    // Register UUID
    self.central.appUUID = PBSportsUUID;
    
    // Begin connection
    [self.central run];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
