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
	//	Delegate for returning success/failure results
	//	queue for accessing parsing and cleanup when operation finishes
	//	
	id<NetworkOperationDelegate, NSObject> delegate;
	id<NetworkOperationQueueDelegate, NSObject> queue;
	//	
	//	Base URL: scheme and host from URL - Ex: http://www.google.com
	//	Relative URI: relative location of resource - EX: /index.php/
	//	
	NSString		*	baseURL;
	NSString		*	URI;
	//	
	//	Operation State
	//	
	BOOL				cancelled;
	BOOL				executing;
	BOOL				done;
	//	
	//	Metadata for identifying operation
	//	Instance code differentiates groups/types of operations
	//	from each other - Ex: Discerning calls to one api, from calls to another
	//	Connection ID differentiates an individual operation
	//	from any other - Ex: Discerning multiple calls to the same api from
	//	from one another
	//	
	NSInteger			instanceCode;
	NSString		*	connectionID;
	//	
	//	Serves two purposes:
	//	If Network Request builds the request itself based on headerDict,
	//	bodyBufferDict, etc then this iVar provides access to that generated
	//	request.
	//	
	//	Alternatively if a complicated request needs to be constructed that is
	//	outside of the bounds of what can be generated, this iVar can be assigned
	//	a request that will be used instead of generating one.
	//	
	NSURLRequest	*	request;
	//	
	//	Data used to generate a NSURLRequest for the NetworkRequest
	//	
	//	NSDictionary	*	headerDict;
	//	Set request header fields, keys are field names, values are field values
	//	Non string objects will be ignored
	//
	//	NSDictionary	*	bodyBufferDict;
	//	For requestType POST, key value pairs are turned into a form post
	//	body, with the values url encoded
	//	For requestType MULTI, keys and values are encoded as data using 
	//	UTF8Encoding
	//	
	//	NSArray			*	bodyDataArray;
	//	For requestType MULTI, bodyDataArray contains dictionaries with
	//	data to post and metadata for fieldName, fileName, contentType and data
	//	[NSDictionary dictionaryWithObjectsAndKeys:
	//	(NSString *)fieldName, @"fieldName",
	//	(NSString *)fileName, @"fileName",
	//	(NSString *)contentType, @"contentType", 
	//	(NSData *)data, @"data", nil];
	//	For requestType PUT, bodyDataArray contains one NSData object that
	//	you would like to PUT
	//	[NSArray arrayWithObject:(NSData *)data];
	//	
	//	NSDictionary	*	userInfo;
	//	Arbitrary dictionary with data associated operation
	//	
	//	NSString		*	xPath;
	//	XPath used to parseXML when parseType is set to ParseXML
	//	
	//	NetworkOperationParseType	parseType;
	//	NoParse - Don't parse data at all
	//	ParseXML - Parse returned data as XML using given xPath
	//	ParseJSONDictionary - Parse returned data as JSON assuming it's root
	//	object is a dictionary
	//	ParseJSONArray - Parse returned data as JSON assuming it's root
	//	object is an array
	//	
	//	NetworkRequestType			requestType;
	//	GET - HTTP Get
	//	POST - HTTP POST with Content-Type: application/x-www-form-urlencoded
	//	MULTI - HTTP POST with Content-Type: multipart/form-data
	//	PUT - HTTP PUT
	//	
	//	NSURLResponse	*	response;
	//	Copy of the NSURLResponse from NetworkRequest (This is usually
	//	a NSHTTPURLResponse. For example:
	//	if ([response isKindOfClass:[NSHTTPURLResponse class]])
	//		NSLog(@"Response Code: %d\nResponse Headers: %@", [(NSHTTPURLResponse *)response statusCode], [(NSHTTPURLResponse *)response allHeaderFields]);
	NSDictionary	*	headerDict;
	NSDictionary	*	bodyBufferDict;
	NSArray			*	bodyDataArray;
	NSDictionary	*	userInfo;
	NSString		*	xPath;
	NetworkOperationParseType	parseType;
	NetworkRequestType			requestType;
	NSURLResponse	*	response;
@private
	//	
	//	Network Request instance that manages the actual network activity
	//	
	NetworkRequest	*	_request;
}

@property (nonatomic, assign)	id<NetworkOperationDelegate, NSObject> delegate;
@property (nonatomic, assign)	id<NetworkOperationQueueDelegate, NSObject> queue;
@property (nonatomic, retain)	NSString		*	baseURL;
@property (nonatomic, retain)	NSString		*	URI;
@property (nonatomic, getter=isCancelled)	BOOL	cancelled;
@property (nonatomic, getter=isExecuting)	BOOL	executing;
@property (nonatomic, getter=isDone)		BOOL	done;
@property (nonatomic, assign)	NSInteger			instanceCode;
@property (nonatomic, retain)	NSString		*	connectionID;
@property (nonatomic, retain)	NSURLRequest	*	request;
@property (nonatomic, retain)	NSDictionary	*	headerDict;
@property (nonatomic, retain)	NSDictionary	*	bodyBufferDict;
@property (nonatomic, retain)	NSArray			*	bodyDataArray;
@property (nonatomic, retain)	NSDictionary	*	userInfo;
@property (nonatomic, retain)	NSString		*	xPath;
@property (nonatomic, assign)	NetworkOperationParseType	parseType;
@property (nonatomic, assign)	NetworkRequestType			requestType;
@property (nonatomic, readonly)	NSURLResponse	*	response;

- (void)start;
- (void)cancel;

@end
