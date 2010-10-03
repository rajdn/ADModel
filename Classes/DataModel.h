//
//  DataModel.h
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

typedef enum {
	kPodcastFeedCode,
	kTwitterSearchFeedCode,
	kTwitterUserFeedCode,
	kPostPrintCode,
	kPostFilePrintCode,
	kPostMultiFilePrint,
	kTimeoutCode,
	kBadURLCode,
	kForbiddenURLCode,
	kBadServerURLCode,
	kUnavailableURLCode,
	kPutCreateURL,
} OperationCodes;

#import <Foundation/Foundation.h>
#import "NetworkOperationQueue.h"
#import "Reachability.h"

@protocol DataModelDelegate;

@interface DataModel : NSObject <NetworkOperationDelegate>
{
	//	
	//	Network Operations
	//	
	NetworkOperationQueue	*	operationQueue;
	NSMutableArray			*	delayedOperations;
	//	
	//	Delegates for returning data
	//	
	NSMutableArray			*	delegates;
	//	
	//	ConnectionStatus
	//	
	Reachability			*	hostReach;
	BOOL						connected;
	NetworkStatus				connectionType;
}

+ (DataModel *)sharedDataModel;
- (void)addDelegate:(id<DataModelDelegate>)dlgt;
- (void)removeDelegate:(id<DataModelDelegate>)dlgt;

- (void)podcastFeed;
- (void)twitterSearchFeed;
- (void)twitterUserFeed;
- (void)postPrint;
- (void)postFilePrint;
- (void)postMultiFilePrint;
- (void)timeout;
- (void)missingFile;
- (void)forbiddenURL;
- (void)badServerURL;
- (void)unavailableURL;
- (void)putCreateURL;
- (void)putNoContentURL;

- (NSString *)generateConnectionID;
- (NSString *)logNSURLError:(int)errorCode;

@end

@protocol DataModelDelegate
@optional
- (void)podcastFeed:(NSArray *)feedItems;
- (void)twitterSearchFeed:(NSArray *)tweets;
- (void)twitterUserFeed:(NSArray *)tweets;
- (void)postPrint:(NSString *)result;
@end
