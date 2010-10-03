//
//  ModelTableViewController.m
//	ADModel
//	
//	Created by Doug Russell on 9/9/10.
//  Copyright Doug Russell 2010. All rights reserved.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  

#import "ModelTableViewController.h"

@implementation ModelTableViewController
@synthesize	items, activityIndicator;

/******************************************************************************/
#pragma mark -
#pragma mark View Life Cycle
#pragma mark -
/******************************************************************************/
- (void)viewDidLoad 
{
    [super viewDidLoad];
	//	
	//	Setup Model
	//	
	model	=	[DataModel sharedDataModel];
	[model addDelegate:self];
	//	
	//	Setup Activity Indicator
	//	
	UIActivityIndicatorView	*	anActivityIndicator	=
	[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	if (anActivityIndicator)
	{
		self.activityIndicator					=	anActivityIndicator;
		UIBarButtonItem				*	button	=	[[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
		self.navigationItem.rightBarButtonItem	=	button;
		[button release];
		[anActivityIndicator release];
	}
	[self.activityIndicator startAnimating];
}
- (void)viewDidUnload 
{
    [super viewDidUnload];
	self.activityIndicator	=	nil;
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
	[model removeDelegate:self];
	model	=	nil;
	CleanRelease(items);
	CleanRelease(activityIndicator);
    [super dealloc];
}
/******************************************************************************/
#pragma mark -
#pragma mark Table View Data Source
#pragma mark -
/******************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{// This will raise an exception and needs to be overridden
    return nil;
}
- (void)reloadTableView
{
	if ([NSThread isMainThread])
		[self.tableView reloadData];
	else
		[self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:NO];
}
/******************************************************************************/
#pragma mark -
#pragma mark Table View Delegate
#pragma mark -
/******************************************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
}

@end

