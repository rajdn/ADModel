//
//  TwitterSearchTableViewController.m
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

#import "TwitterSearchTableViewController.h"

@implementation TwitterSearchTableViewController

- (void)viewDidLoad 
{
    [super viewDidLoad];
	self.navigationItem.title	=	@"Twitter Search";
	[model twitterSearchFeed];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	cell.textLabel.text			=	[[self.items objectAtIndex:indexPath.row] objectForKey:@"from_user"];
	cell.detailTextLabel.text	=	[[self.items objectAtIndex:indexPath.row] objectForKey:@"text"];
	return cell;
}
/******************************************************************************/
#pragma mark -
#pragma mark Data Model Delegate
#pragma mark -
/******************************************************************************/
- (void)error:(NSError *)error operationCode:(NSInteger)code
{
	if (code == kTwitterSearchFeedCode)
	{
		BasicAlert(@"Error", 
				   error.domain, 
				   nil, 
				   @"OK", 
				   nil);
	}
}
- (void)twitterSearchFeed:(NSArray *)tweets
{
	self.items	=	tweets;
	[self reloadTableView];
	[self.activityIndicator stopAnimating];
}

@end

