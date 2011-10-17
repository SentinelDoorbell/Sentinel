//
//  SentinelAppDelegate.h
//  Sentinel
//
//  Created by Fekri Kassem on 10/16/11.
//  Copyright 2011 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SentinelAppDelegate : NSObject <UIApplicationDelegate> {
    UIWebView *view;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
