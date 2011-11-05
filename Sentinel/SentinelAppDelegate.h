//
//  SentinelAppDelegate.h
//  Sentinel
//
//  Created by Fekri Kassem on 10/16/11.
//  Copyright 2011 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SentinelCameraView;

@interface SentinelAppDelegate : NSObject <UIApplicationDelegate> {
    UIWebView *theWebView;

	NSURLRequest *theRequest;
	NSURLConnection *theConnection;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIWebView *theWebView;


- (IBAction) onTiltScanClick: (id) sender;

- (IBAction) onPanScanClick: (id) sender;

- (IBAction) onBrightnessDarker:(id) sender;

- (IBAction) onBrightnessReset:(id) sender;

- (IBAction) onBrightnessBrighter:(id) sender;

- (IBAction) OnNightModeSwitch: (id) sender;

- (IBAction) OnAlarmClick: (id) sender;

@end


@interface SentinelTouchView : UIView
{

}

- (void) homePosition;

- (void) tiltUp;

- (void) tiltDown;

- (void) PanLeft;

- (void) PanRight;

@end
