//	
//	NetworkOperation.h
//	
//	Created by Doug Russell on 9/9/10.
//	Copyright Doug Russell 2010. All rights reserved.
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

#import <Foundation/Foundation.h>
#import "NetworkOperationDelegate.h"
#import "NetworkRequest.h"

typedef enum {
	NoParse,
	ParseXML,
	ParseJSONDictionary,
	ParseJSONArray,
} NetworkOperationParseType;

@class NetworkOperationQueue;
@interface NetworkOperation : NSObject <NetworkRequestDelegate>
{
@public
	//	
	//	/*UNREVISEDCOMMENTS*/
	//	
	id<NetworkOperationDelegate, NSObject> delegate;
	id<NetworkOperationQueueDelegate, NSObject> queue;
	//	
	//	/*UNREVISEDCOMMENTS*/
	//	
	NSString		*	baseURL;
	NSString		*	URI;
	//	
	//	Operation State
	//	
	BOOL				cancelled;
	BOOL				executing;
	//	
	//	/*UNREVISEDCOMMENTS*/
	//	
	NSInteger			instanceCode;
	NSString		*	connectionID;
	//	
	//	/*UNREVISEDCOMMENTS*/
	//	
	NSURLRequest	*	request;
	//	
	//	/*UNREVISEDCOMMENTS*/
	//	
	NSDictionary	*	bufferDict;
	NSArray			*	dataArray;
	NSDictionary	*	userInfo;
	NSString		*	xPath;
	NetworkOperationParseType	parseType;
	NetworkRequestType			requestType;
@private
	//	
	//	/*UNREVISEDCOMMENTS*/
	//	
	NetworkRequest	*	_request;
}

@property (nonatomic, assign)	id<NetworkOperationDelegate, NSObject> delegate;
@property (nonatomic, assign)	id<NetworkOperationQueueDelegate, NSObject> queue;
@property (nonatomic, retain)	NSString		*	baseURL;
@property (nonatomic, retain)	NSString		*	URI;
@property (nonatomic, getter=isCancelled)	BOOL	cancelled;
@property (nonatomic, getter=isExecuting)	BOOL	executing;
@property (nonatomic, assign)	NSInteger			instanceCode;
@property (nonatomic, retain)	NSString		*	connectionID;
@property (nonatomic, retain)	NSDictionary	*	bufferDict;
@property (nonatomic, retain)	NSArray			*	dataArray;
@property (nonatomic, retain)	NSDictionary	*	userInfo;
@property (nonatomic, retain)	NSString		*	xPath;
@property (nonatomic, assign)	NetworkOperationParseType	parseType;
@property (nonatomic, assign)	NetworkRequestType			requestType;

- (void)start;

@end
