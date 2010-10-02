//	
//	RootViewController.h
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

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
{
	UIButton	*	podcastFeedButton;
	UIButton	*	twitterSearchFeedButton;
	UIButton	*	twitterUserButton;
	UIButton	*	postFormButton;
	UIButton	*	postFileButton;
	UIButton	*	postMultipleFilesButton;
	UIButton	*	timeoutButton;
	UIButton	*	missingFileButton;
	UIButton	*	forbiddenURLButton;
	UIButton	*	badServerURLButton;
	UIButton	*	unavailableURLButton;
	UIButton	*	putCreateButton;
	UIButton	*	putNoContentURL;
}

@property (nonatomic, retain)	IBOutlet	UIButton	*	podcastFeedButton;
@property (nonatomic, retain)	IBOutlet	UIButton	*	twitterSearchFeedButton;
@property (nonatomic, retain)	IBOutlet	UIButton	*	twitterUserButton;
@property (nonatomic, retain)	IBOutlet	UIButton	*	postFormButton;
@property (nonatomic, retain)	IBOutlet	UIButton	*	postFileButton;
@property (nonatomic, retain)	IBOutlet	UIButton	*	postMultipleFilesButton;
@property (nonatomic, retain)	IBOutlet	UIButton	*	timeoutButton;
@property (nonatomic, retain)	IBOutlet	UIButton	*	missingFileButton;
@property (nonatomic, retain)	IBOutlet	UIButton	*	forbiddenURLButton;
@property (nonatomic, retain)	IBOutlet	UIButton	*	badServerURLButton;
@property (nonatomic, retain)	IBOutlet	UIButton	*	unavailableURLButton;
@property (nonatomic, retain)	IBOutlet	UIButton	*	putCreateButton;
@property (nonatomic, retain)	IBOutlet	UIButton	*	putNoContentURL;

- (IBAction)podcastFeedButton:(id)sender;
- (IBAction)twitterSearchFeedButton:(id)sender;
- (IBAction)twitterUserFeedButton:(id)sender;
- (IBAction)postFormButton:(id)sender;
- (IBAction)postFileButton:(id)sender;
- (IBAction)postMultipleFilesButton:(id)sender;
- (IBAction)timeoutButton:(id)sender;
- (IBAction)missingFileButton:(id)sender;
- (IBAction)forbiddenURLButton:(id)sender;
- (IBAction)badServerURLButton:(id)sender;
- (IBAction)unavailableURLButton:(id)sender;
- (IBAction)putCreateButton:(id)sender;
- (IBAction)putNoContentURL:(id)sender;

- (void)pushTableViewController:(NSString *)className;
- (void)pushViewController:(NSString *)className;

@end
