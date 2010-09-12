//	
//	NetworkRequest.h
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
#import "NetworkRequestDelegate.h"

typedef enum {
	GET,
	POST,
	MULTI, //Multipart Form Post
	PUT,
//	DELETE,
} NetworkRequestType;

@interface NetworkRequest : NSObject 
{
@public
	id<NetworkRequestDelegate> delegate;
	NSString		*	url;
	NSString		*	connectionID;
	BOOL				cancelled;
	NSDictionary	*	headerDict;
	NSDictionary	*	bodyBufferDict;
	NSArray			*	bodyDataArray;
	NSDictionary	*	userInfo;
	NetworkRequestType	requestType;
	NSURLRequest	*	_request;
@private
	NSURLResponse	*	_response;
	NSURLConnection	*	_connection;
	NSMutableData	*	_data;
}

@property (nonatomic, assign)	id<NetworkRequestDelegate> delegate;
@property (nonatomic, retain)	NSString		*	url;
@property (nonatomic, retain)	NSString		*	connectionID;
@property (nonatomic, getter=isCancelled)	BOOL	cancelled;
@property (nonatomic, retain)	NSDictionary	*	headerDict;
@property (nonatomic, retain)	NSDictionary	*	bodyBufferDict;
@property (nonatomic, retain)	NSArray			*	bodyDataArray;
@property (nonatomic, retain)	NSDictionary	*	userInfo;
@property (nonatomic, assign)	NetworkRequestType	requestType;
@property (nonatomic, retain)	NSURLRequest	*	request;
@property (nonatomic, readonly)	NSURLResponse	*	response;

- (void)start;
- (void)cancel;

@end
