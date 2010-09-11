//	
//	NetworkOperation.m
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

#define kBaseURL @"http://getitdownonpaper.com"

#import "NetworkOperation.h"
#import "CJSONDeserializer.h"
#import "HandleXMLFeed.h"

@interface NetworkOperation ()
- (void)networkOperationDidComplete:(id)operation withResult:(id)result;
- (void)networkOperationDidFail:(id)operation withError:(NSError *)error;
@end

@implementation NetworkOperation
@synthesize	delegate, queue;
@synthesize	baseURL, URI;
@synthesize	cancelled, executing;
@synthesize	instanceCode, connectionID;
@synthesize	bufferDict, dataArray, userInfo;
@dynamic	xPath;
@synthesize	parseType;
@synthesize	requestType;

/******************************************************************************/
#pragma mark -
#pragma mark Setup/Cleanup
#pragma mark -
/******************************************************************************/
- (id)init
{
	if ((self = [super init]))
	{
		baseURL		=	kBaseURL;
		URI			=	nil;
		cancelled	=	NO;
		executing	=	NO;
		instanceCode=	0;
		connectionID=	nil;
		bufferDict	=	nil;
		dataArray	=	nil;
		userInfo	=	nil;
		xPath		=	nil;
		parseType	=	NoParse;
		requestType	=	GET;
		_request	=	nil;
	}
	return self;
}
- (void)dealloc
{
	delegate	=	nil;
	queue		=	nil;
	[baseURL release];
	[URI release];
	[request release];
	[connectionID release];
	[bufferDict release];
	[dataArray release];
	[userInfo release];
	[xPath release];
	[_request release];
	[super dealloc];
}
- (NSString *)xPath
{
	return xPath;
}
- (void)setXPath:(NSString *)anXPath
{
	[xPath release]; xPath = nil;
	if (anXPath != nil)
		xPath	=	[[NSString alloc] initWithFormat:@"//%@", anXPath];
}
/******************************************************************************/
#pragma mark -
#pragma mark 
#pragma mark -
/******************************************************************************/
- (void)start
{
	self.executing			=	YES;
	_request				=	[[NetworkRequest alloc] init];
	if (request != nil)
		_request.request	=	request;
	else 
	{
		if (URI)
			_request.url		=	[baseURL stringByAppendingString:URI];
		else
			_request.url		=	baseURL;
		_request.requestType	=	requestType;
		_request.bufferDict		=	bufferDict;
		_request.dataArray		=	dataArray;
		_request.userInfo		=	userInfo;
	}
	_request.connectionID	=	connectionID;
	_request.delegate		=	self;
	[_request start];
}
- (void)cancel
{
	cancelled	=	YES;
	[_request cancel];
	[self.queue removeNetworkOperation:self];
}
/******************************************************************************/
#pragma mark -
#pragma mark Network Request Delegate
#pragma mark -
/******************************************************************************/
- (void)networkRequestDone:(NetworkRequest *)request data:(NSData *)data
{
	if (cancelled)
		return;
	switch (parseType) {
		case NoParse:
			[self networkOperationDidComplete:self withResult:data];
			break;
		case ParseXML:
			[[self.queue parseQueue] addOperationWithBlock:^(void) {
				HandleXMLFeed	*	parser	=
				[[HandleXMLFeed alloc] initWithData:data xPath:xPath];
				NSArray			*	result	=	[parser parse];
				[self networkOperationDidComplete:self withResult:result];
				[parser release];
			}];
			break;
		case ParseJSONDictionary:
			[[self.queue parseQueue] addOperationWithBlock:^(void) {
				NSError			*	error;
				NSDictionary	*	result	=
				[[CJSONDeserializer deserializer] deserializeAsDictionary:data error:&error];
				[self networkOperationDidComplete:self withResult:result];
			}];
			break;
		case ParseJSONArray:
			[[self.queue parseQueue] addOperationWithBlock:^(void) {
				NSError			*	error;
				NSDictionary	*	result	=
				[[CJSONDeserializer deserializer] deserializeAsArray:data error:&error];
				[self networkOperationDidComplete:self withResult:result];
			}];
			break;
		default:
			break;
	}
}
- (void)networkRequestFailed:(NetworkRequest *)request error:(NSError *)error
{
	if (cancelled)
		return;
	[self networkOperationDidFail:self withError:error];
}
/******************************************************************************/
#pragma mark -
#pragma mark 
#pragma mark -
/******************************************************************************/
- (void)networkOperationDidComplete:(id)operation withResult:(id)result
{
	if (cancelled)
		return;
	if ([NSThread isMainThread])
	{
		self.executing	=	NO;
		[self.delegate networkOperationDidComplete:operation 
										withResult:result];
		[self.queue removeNetworkOperation:self];
	}
	else
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			[self networkOperationDidComplete:operation 
								   withResult:result];
		});
	}
}
- (void)networkOperationDidFail:(id)operation withError:(NSError *)error
{
	if (cancelled)
		return;
	if ([NSThread isMainThread])
	{
		self.executing	=	NO;
		[self.delegate networkOperationDidFail:operation 
									 withError:error];
		[self.queue removeNetworkOperation:self];
	}
	else
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			[self networkOperationDidFail:operation 
								withError:error];
		});
	}
}

@end
