//	
//	RootViewController.m
//	ADModel
//	
//	Created by Doug Russell on 9/9/10.
//	Copyright Doug Russell 2010. All rights reserved.
//	
//	Licensed under the Apache License, Version 2.0 (the "License");
//	you may not use this file except in compliance with the License.
//	You may obtain a copy of the License at
//	
//	http://www.apache.org/licenses/LICENSE-2.0
//	
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.
//	

#import "RootViewController.h"
#import "PodcastTableViewController.h"
#import "TwitterSearchTableViewController.h"
#import "TwitterUserTableViewController.h"
#import "PostFormViewController.h"
#import "PutCreateViewController.h"
#import "PutNoContentViewController.h"

@implementation RootViewController
@synthesize	podcastFeedButton;
@synthesize	twitterSearchFeedButton;
@synthesize twitterUserButton;
@synthesize	postFormButton;
@synthesize	postFileButton;
@synthesize	postMultipleFilesButton;
@synthesize	timeoutButton;
@synthesize	missingFileButton;
@synthesize	forbiddenURLButton;
@synthesize	badServerURLButton;
@synthesize	unavailableURLButton;
@synthesize	putCreateButton;
@synthesize	putNoContentURL;

/******************************************************************************/
#pragma mark -
#pragma mark View Life Cycle
#pragma mark -
/******************************************************************************/
- (void)viewDidLoad 
{
	[super viewDidLoad];
	[self.activityIndicator stopAnimating];
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
		[(UIScrollView *)self.view setContentSize:CGSizeMake(self.view.bounds.size.width, 1100)];
}
- (void)viewDidUnload 
{
    [super viewDidUnload];
	self.podcastFeedButton			=	nil;
	self.twitterSearchFeedButton	=	nil;
	self.twitterUserButton			=	nil;
	self.postFormButton				=	nil;
	self.postFileButton				=	nil;
	self.postMultipleFilesButton	=	nil;
	self.timeoutButton				=	nil;
	self.missingFileButton			=	nil;
	self.forbiddenURLButton			=	nil;
	self.badServerURLButton			=	nil;
	self.unavailableURLButton		=	nil;
	self.putCreateButton			=	nil;
	self.putNoContentURL			=	nil;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
		[(UIScrollView *)self.view setContentSize:CGSizeMake(self.view.bounds.size.width, 1100)];
}
/******************************************************************************/
#pragma mark -
#pragma mark Memory Management
#pragma mark -
/******************************************************************************/
- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}
- (void)dealloc 
{
	CleanRelease(podcastFeedButton);
	CleanRelease(twitterSearchFeedButton);
	CleanRelease(twitterUserButton);
	CleanRelease(postFormButton);
	CleanRelease(postFileButton);
	CleanRelease(postMultipleFilesButton);
	CleanRelease(timeoutButton);
	CleanRelease(missingFileButton);
	CleanRelease(forbiddenURLButton);
	CleanRelease(badServerURLButton);
	CleanRelease(unavailableURLButton);
	CleanRelease(putCreateButton);
	CleanRelease(putNoContentURL);
    [super dealloc];
}
/******************************************************************************/
#pragma mark -
#pragma mark Buttons
#pragma mark -
/******************************************************************************/
- (IBAction)podcastFeedButton:(id)sender
{
	[self pushTableViewController:@"PodcastTableViewController"];
}
- (IBAction)twitterSearchFeedButton:(id)sender
{
	[self pushTableViewController:@"TwitterSearchTableViewController"];
}
- (IBAction)twitterUserFeedButton:(id)sender
{
	[self pushTableViewController:@"TwitterUserTableViewController"];
}
- (IBAction)postFormButton:(id)sender
{
	[self pushViewController:@"PostFormViewController"];
}
- (IBAction)postFileButton:(id)sender
{
	
}
- (IBAction)postMultipleFilesButton:(id)sender
{
	
}
- (IBAction)timeoutButton:(id)sender
{
	BasicAlert(@"Timeout", 
			   @"Timeout will occur in 15 seconds", 
			   nil, 
			   @"OK", 
			   nil);
	[model timeout];
}
- (IBAction)missingFileButton:(id)sender
{
	[model missingFile];
}
- (IBAction)forbiddenURLButton:(id)sender
{
	[model forbiddenURL];
}
- (IBAction)badServerURLButton:(id)sender
{
	[model badServerURL];
}
- (IBAction)unavailableURLButton:(id)sender
{
	[model unavailableURL];
}
- (IBAction)putCreateButton:(id)sender
{
	[self pushViewController:@"PutCreateViewController"];
}
- (IBAction)putNoContentURL:(id)sender
{
	[self pushViewController:@"PutNoContentViewController"];
}
- (void)pushTableViewController:(NSString *)className
{
	UITableViewController	*	viewController	=	
	[[NSClassFromString(className) alloc] initWithStyle:UITableViewStylePlain];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}
- (void)pushViewController:(NSString *)className
{
	UIViewController	*	viewController	=	
	[[NSClassFromString(className) alloc] initWithNibName:[NSString stringWithFormat:@"%@%@", className, (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"~iPad" : @"~iPhone"] bundle:nil];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}
/******************************************************************************/
#pragma mark -
#pragma mark Data Model Delegate
#pragma mark -
/******************************************************************************/
- (void)error:(NSError *)error operationCode:(NSInteger)code
{
	if (code == kTimeoutCode ||
		code == kBadURLCode ||
		code == kForbiddenURLCode ||
		code == kBadServerURLCode ||
		code == kUnavailableURLCode ||
		code == kPutCreateURL ||
		code == kPutNoContentURL)
	{
		BasicAlert(@"Error", 
				   [NSString stringWithFormat:@"%@ : %@", error.domain, [model stringForNSURLError:error.code]], 
				   nil, 
				   @"OK", 
				   nil);
	}
}

@end
