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
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
		[(UIScrollView *)self.view setContentSize:CGSizeMake(320, 1040)];
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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return YES;
	else
		return ((toInterfaceOrientation == UIInterfaceOrientationPortrait) ||
				(toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));	
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
	
}
- (IBAction)missingFileButton:(id)sender
{
	
}
- (IBAction)forbiddenURLButton:(id)sender
{
	
}
- (IBAction)badServerURLButton:(id)sender
{
	
}
- (IBAction)unavailableURLButton:(id)sender
{
	
}
- (IBAction)putCreateButton:(id)sender
{
	
}
- (IBAction)putNoContentURL:(id)sender
{
	
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
	[[NSClassFromString(className) alloc] initWithNibName:className bundle:nil];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

@end
