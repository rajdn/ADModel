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

#define kBaseURL @"http://app.keithandthegirl.com"

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
@synthesize	cancelled, executing, done;
@synthesize	instanceCode, connectionID;
@synthesize	request;
@synthesize	headerDict, bodyBufferDict, bodyDataArray, userInfo;
@dynamic	xPath;
@synthesize	parseType;
@synthesize	requestType;
@dynamic	response;

/******************************************************************************/
#pragma mark -
#pragma mark Setup/Cleanup
#pragma mark -
/******************************************************************************/
- (id)init
{
	if ((self = [super init]))
	{
		baseURL			=	kBaseURL;
		URI				=	nil;
		cancelled		=	NO;
		executing		=	NO;
		instanceCode	=	0;
		connectionID	=	nil;
		headerDict		=	nil;
		bodyBufferDict	=	nil;
		bodyDataArray	=	nil;
		userInfo		=	nil;
		xPath			=	nil;
		parseType		=	NoParse;
		requestType		=	GET;
		_request		=	nil;
	}
	return self;
}
- (void)dealloc
{
	delegate	=	nil;
	queue		=	nil;
	CleanRelease(baseURL);
	CleanRelease(URI);
	CleanRelease(request);
	CleanRelease(connectionID);
	CleanRelease(headerDict);
	CleanRelease(bodyBufferDict);
	CleanRelease(bodyDataArray);
	CleanRelease(userInfo);
	CleanRelease(xPath);
	_request.delegate = nil;
	CleanRelease(_request);
	[super dealloc];
}
- (NSString *)xPath
{
	return xPath;
}
- (void)setXPath:(NSString *)anXPath
{
	CleanRelease(xPath);
	if (anXPath != nil)
		xPath	=	[[NSString alloc] initWithFormat:@"//%@", anXPath];
}
- (NSURLResponse *)response
{
	return _request.response;
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
		_request.bodyBufferDict	=	bodyBufferDict;
		_request.bodyDataArray	=	bodyDataArray;
	}
	_request.userInfo		=	userInfo;
	_request.connectionID	=	connectionID;
	_request.delegate		=	self;
	[_request start];
}
- (void)cancel
{
	self.cancelled	=	YES;
	_request.delegate = nil; [_request cancel];
	self.executing	=	NO;
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
		self.done		=	YES;
		_request.delegate = nil; CleanRelease(_request);
		CleanRelease(request);
		[self.delegate networkOperationDidComplete:operation 
										withResult:result];
		self.executing	=	NO;
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
		self.done		=	YES;
		_request.delegate = nil; CleanRelease(_request);
		CleanRelease(request);
		[self.delegate networkOperationDidFail:operation 
									 withError:error];
		self.executing	=	NO;
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
