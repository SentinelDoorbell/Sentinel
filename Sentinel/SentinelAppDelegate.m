//
//  SentinelAppDelegate.m
//  Sentinel
//
//  Created by Fekri Kassem on 10/16/11.
//  Copyright 2011 Self. All rights reserved.
//

#import "SentinelAppDelegate.h"

@implementation SentinelAppDelegate


@synthesize window=_window;
@synthesize theWebView;
@synthesize theImageView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
	theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://128.238.151.253/"] 	  
								cachePolicy:NSURLRequestUseProtocolCachePolicy						  
							timeoutInterval:60.0];
	
	theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,64,320,240)];
	theWebView.userInteractionEnabled = YES;
	
	SentinelTouchView* tmpView = [[SentinelTouchView alloc] initWithFrame:CGRectMake(0,0,320,240)];
	[theWebView addSubview:tmpView];
	
	theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

	[self.window addSubview:theWebView];
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge 
{
	if ([challenge previousFailureCount] == 0)
	{
		NSURLCredential *newCredential;
		newCredential=[NSURLCredential credentialWithUser:@"kongcao7bl"
												 password:@"Kongcao7BL"
											  persistence:NSURLCredentialPersistenceForSession];
		[[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
		NSURL *url = [NSURL URLWithString:@"http://128.238.151.253/nphMotionJpeg?Resolution=320x240&Quality=Standard"];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[theWebView loadRequest:requestObj];
		
		NSLog(@"Hello world");
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Failure" 
														message:@"Invalid username/password."
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (IBAction) onTiltScanClick: (id) sender
{
	NSURL *url = [NSURL URLWithString:@"http://128.238.151.253/nphControlCamera?Direction=TiltScan&PanTiltMin=1"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[NSURLConnection sendSynchronousRequest:requestObj returningResponse:nil error:nil];

	NSLog(@"TiltScan");
}

- (IBAction) onPanScanClick: (id) sender
{
	NSURL *url = [NSURL URLWithString:@"http://128.238.151.253/nphControlCamera?Direction=PanScan&PanTiltMin=1"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[NSURLConnection sendSynchronousRequest:requestObj returningResponse:nil error:nil];
	NSLog(@"PanScan");
}

- (IBAction) onBrightnessDarker:(id) sender
{
	NSURL *url = [NSURL URLWithString:@"http://128.238.151.253/nphControlCamera?Direction=Darker"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[NSURLConnection sendSynchronousRequest:requestObj returningResponse:nil error:nil];
}

- (IBAction) onBrightnessReset:(id) sender
{
	NSURL *url = [NSURL URLWithString:@"http://128.238.151.253/nphControlCamera?Direction=DefaultBrightness"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[NSURLConnection sendSynchronousRequest:requestObj returningResponse:nil error:nil];
}

- (IBAction) onBrightnessBrighter:(id) sender
{
	NSURL *url = [NSURL URLWithString:@"http://128.238.151.253/nphControlCamera?Direction=Brighter"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[NSURLConnection sendSynchronousRequest:requestObj returningResponse:nil error:nil];
}


- (IBAction) OnNightModeSwitch: (id) sender
{
	UISwitch *nightSwitch = (UISwitch *) sender;
	

	
	if ([nightSwitch isOn] )
	{
		NSURL *url = [NSURL URLWithString:@"http://128.238.151.253/nphControlCamera?Direction=BacklightOn"];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[NSURLConnection sendSynchronousRequest:requestObj returningResponse:nil error:nil];
	}
	else 
	{
		NSURL *url = [NSURL URLWithString:@"http://128.238.151.253/nphControlCamera?Direction=BacklightOff"];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		[NSURLConnection sendSynchronousRequest:requestObj returningResponse:nil error:nil];
	}

	NSLog(@"NightMode");
}

- (IBAction) OnAlarmClick: (id) sender
{
	NSURL *url = [NSURL URLWithString:@"http://128.238.151.253/nphControlCamera?Direction=Sound"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[NSURLConnection sendSynchronousRequest:requestObj returningResponse:nil error:nil];
	
	NSLog(@"Alarm");
}

- (IBAction) OnSnapshot: (id) sender
{
	NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"yyyyMMMdd_HH_mm_ss"];
	
	NSDate *now = [NSDate date];
	
	NSString *dateString = [format stringFromDate:now];
	
	NSURL *url = [NSURL URLWithString:@"http://128.238.151.253/SnapshotJPEG?Resolution=320x240&Quality=Motion&Count=0"];
	NSData *data = [NSData dataWithContentsOfURL:url];
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *str = [[NSString alloc] initWithFormat:@"/%@.jpg", dateString];
	path = [path stringByAppendingString:str];
	[str release];

	[data writeToFile:path atomically:YES];
}

- (IBAction) OnImagesClick: (id) sender
{
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
	NSArray *onlyJPGs = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"]];
	
	for(NSString* image in onlyJPGs)
	{
		NSString* fullPath = [[NSString alloc] initWithFormat:@"%@/%@",path, image];
		
		UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
		
		if (image)
		{
			NSLog(@"Image is good");
		}
		
		[theImageView setImage:image];
		
		[fullPath release];
	}
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    [connection release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	
}


- (void)dealloc
{
    [theWebView release];
    [_window release];
    [super dealloc];
}

@end

@implementation SentinelTouchView
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	CGPoint startLocation = [(UITouch*)[touches anyObject] locationInView:self];

	double x = startLocation.x;
	double y = startLocation.y;

	NSLog(@"%f %f", x, y);
	
	if(x >= 100 && x <= 210 && y >= 80 && y <= 160)
	{
		[self homePosition];
	}
	
	if (y >= 0 && y <= 80)
	{
		[self tiltUp];
	}
	else if(y >= 160 && y <= 240)
	{
		[self tiltDown];
	}
	
	if (x >= 0 & x <= 110)
	{
		[self PanLeft];
	}
	else if(x >= 210 && x <= 320)
	{
		[self PanRight];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	CGPoint startLocation = [(UITouch*)[touches anyObject] locationInView:self];
	
	double x = startLocation.x;
	double y = startLocation.y;
	
	NSLog(@"Ended: %f %f", x, y);
}

- (void) homePosition
{
	NSURL *url = [NSURL URLWithString:@"http://128.238.151.253/nphControlCamera?Direction=HomePosition"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[NSURLConnection sendSynchronousRequest:requestObj returningResponse:nil error:nil];
	NSLog(@"TiltUp");
}

- (void) tiltUp
{
	NSURL *url = [NSURL URLWithString:@"http://128.238.151.253/nphControlCamera?Direction=TiltUp"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[NSURLConnection sendSynchronousRequest:requestObj returningResponse:nil error:nil];
	NSLog(@"TiltUp");
}

- (void) tiltDown
{
	NSURL *url = [NSURL URLWithString:@"http://128.238.151.253/nphControlCamera?Direction=TiltDown"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[NSURLConnection sendSynchronousRequest:requestObj returningResponse:nil error:nil];
	NSLog(@"TiltDown");
}

- (void) PanLeft
{
	NSURL *url = [NSURL URLWithString:@"http://128.238.151.253/nphControlCamera?Direction=PanLeft"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[NSURLConnection sendSynchronousRequest:requestObj returningResponse:nil error:nil];
	NSLog(@"Pan Left");
}

- (void) PanRight
{
	NSURL *url = [NSURL URLWithString:@"http://128.238.151.253/nphControlCamera?Direction=PanRight"];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[NSURLConnection sendSynchronousRequest:requestObj returningResponse:nil error:nil];
	NSLog(@"Pan Right");
}

@end
