//
//  AppDelegate.h
//  random-text
//
//  Created by Pumpkin Lee on 2/18/14.
//  Copyright (c) 2014 Pumpkin Lee. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSURLConnectionDelegate>

@property (nonatomic) NSMutableData *responseData;

@property (assign) IBOutlet NSWindow *window;

@end
