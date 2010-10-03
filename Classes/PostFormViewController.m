//
//  PostFormViewController.m
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

#import "PostFormViewController.h"

@implementation PostFormViewController
@synthesize postButton;
@synthesize resultTextView;

- (void)viewDidLoad 
{
	[super viewDidLoad];
	[self.activityIndicator stopAnimating];
}
- (void)viewDidUnload 
{
	[super viewDidUnload];
	self.postButton		=	nil;
	self.resultTextView	=	nil;
}
- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}
- (void)dealloc 
{
	CleanRelease(postButton);
	CleanRelease(resultTextView);
	[super dealloc];
}
- (IBAction)postButtonPressed:(id)sender
{
	self.postButton.enabled		=	NO;
	self.resultTextView.text	=	@"";
	[self.activityIndicator startAnimating];
	[model postPrint];
}
- (void)postPrint:(NSString *)result
{
	self.resultTextView.text	=	result;
	self.postButton.enabled		=	YES;
	[self.activityIndicator stopAnimating];
}

@end
