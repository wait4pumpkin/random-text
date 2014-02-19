//
//  AppDelegate.m
//  random-text
//
//  Created by Pumpkin Lee on 2/18/14.
//  Copyright (c) 2014 Pumpkin Lee. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () {
    NSArray *fonts;
}

@property (weak) IBOutlet NSTextField *randomText;
@property (weak) IBOutlet NSTextField *fontName;
@property (weak) IBOutlet NSButton *button;

- (IBAction)generate:(NSButton *)sender;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    fonts = [[NSFontManager sharedFontManager] availableFontFamilies];
    self.window.backgroundColor = [NSColor whiteColor];
}

- (IBAction)generate:(NSButton *)sender {
    [sender setEnabled:NO];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:@"http://watchout4snakes.com/wo4snakes/Random/RandomParagraph"]];
    [request setHTTPMethod:@"POST"];
    NSString *form = @"Subject1=&Subject2=";
    [request setHTTPBody:[form dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)capture {
    CGImageRef capturedImage = CGDisplayCreateImage(kCGDirectMainDisplay);
    capturedImage = CGImageCreateWithImageInRect(capturedImage, self.randomText.frame);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fileName = [NSString stringWithFormat:@"%@.png",
                          [dateFormatter stringFromDate:[NSDate date]]];
    CFURLRef fileUrl = (__bridge CFURLRef)[NSURL fileURLWithPath:fileName];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(fileUrl, kUTTypePNG, 1, NULL);
    CGImageDestinationAddImage(destination, capturedImage, nil);
    
    CGImageDestinationFinalize(destination);
    CGImageRelease(capturedImage);
    
    [self.button setEnabled:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSInteger idx = arc4random_uniform((int)fonts.count);
    self.fontName.stringValue = fonts[idx];
    
    NSString *text = [[NSString alloc] initWithData:self.responseData encoding:NSISOLatin1StringEncoding];
    self.randomText.stringValue = text;
    self.randomText.font = [NSFont fontWithName:fonts[idx] size:18.];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(capture)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error.description);
    [self.button setEnabled:YES];
}
     
     
@end
