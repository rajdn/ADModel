//	
//	NetworkRequest.m
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

#import "NetworkRequest.h"

@interface NetworkRequest ()
- (NSURLRequest *)initRequest;
- (NSData *)formBody;
- (NSString *)urlEncodeString:(NSString *)string;
- (NSData *)multipartFormBodyWithStringBoundary:(NSString *)stringBoundary;
@end

@implementation NetworkRequest
@synthesize delegate;
@synthesize	connectionID;
@synthesize	url;
@synthesize	cancelled;
@synthesize	headerDict, bodyBufferDict, bodyDataArray, userInfo;
@synthesize	requestType;
@synthesize	request	=	_request, response	=	_response;

/******************************************************************************/
#pragma mark -
#pragma mark Setup/Cleanup
#pragma mark -
/******************************************************************************/
- (id)init
{
	if ((self = [super init]))
	{
		//	
		//	Put everything into a known state
		//	
		url				=	nil;
		connectionID	=	nil;
		cancelled		=	NO;
		headerDict		=	nil;
		bodyBufferDict	=	nil;
		bodyDataArray	=	nil;
		userInfo		=	nil;
		requestType		=	GET;
		_request		=	nil;
		_response		=	nil;
		_connection		=	nil;
		_data			=	nil;
	}
	return self;
}
- (void)dealloc
{
	delegate = nil;
	[_connection cancel];
	CleanRelease(_connection);
	CleanRelease(_request);
	CleanRelease(_data);
	CleanRelease(url);
	CleanRelease(connectionID);
	CleanRelease(headerDict);
	CleanRelease(bodyBufferDict);
	CleanRelease(bodyDataArray);
	CleanRelease(userInfo);
	CleanRelease(_response);
	[super dealloc];
}
/******************************************************************************/
#pragma mark -
#pragma mark 
#pragma mark -
/******************************************************************************/
- (void)start
{
	//	
	//	Create request that respects caching and has an appropriate timeout
	//	
	_request	=	[self initRequest];
	//	
	//	Preflight request
	//	
	if ([NSURLConnection canHandleRequest:_request])
	{
		//	
		//	Check cache for available data
		//	
		NSCachedURLResponse	*	cachedResponse	=	[[NSURLCache sharedURLCache] cachedResponseForRequest:_request];
		if (cachedResponse != nil && !cancelled)
		{
			_response	=	[[cachedResponse response] retain];
			_data		=	[[cachedResponse data] retain];
			if ([(NSObject *)self.delegate respondsToSelector:@selector(networkRequestDone:data:)])
				[self.delegate networkRequestDone:self data:_data];
		}
		else if (!cancelled)
		{
			_data								=	[[NSMutableData alloc] init];
			_connection							=	[[NSURLConnection alloc] initWithRequest:_request delegate:self];
			if (_connection == nil)
			{	// Unable to make connection
				CleanRelease(_data);
				// Report error to delegate
				NSError				*	error	=	[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:nil];
				if ([(NSObject *)self.delegate respondsToSelector:@selector(networkRequestFailed:error:)])
					[self.delegate networkRequestFailed:self error:error];
			}
		}
	}
	else if (!cancelled)
	{	// Unable to preflight connection
		// Report error to delegate
		NSError					*	error	=	[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:nil];
		if ([(NSObject *)self.delegate respondsToSelector:@selector(networkRequestFailed:error:)])
			[self.delegate networkRequestFailed:self error:error];
	}
}
- (void)cancel
{
	self.cancelled	=	YES;
	[_connection cancel];
}
/******************************************************************************/
#pragma mark -
#pragma mark Build NSURLRequest
#pragma mark -
/******************************************************************************/
- (NSURLRequest *)initRequest
{
	//	
	//	If request has already been set, use it
	//	
	if (_request != nil)
		return _request;
	//	
	//	Otherwise create a request based on type
	//	
	NSMutableURLRequest	*	aRequest	=
	[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]
							cachePolicy:NSURLRequestUseProtocolCachePolicy
						timeoutInterval:15.0];
	if (headerDict != nil)
		[aRequest setAllHTTPHeaderFields:headerDict];
	switch (requestType) {
		//case GET:
		//	// Nothing to do here
		//	break;
		case POST:
			[aRequest setHTTPMethod:@"POST"];
			[aRequest setHTTPBody:[self formBody]];
			break;
		case MULTI:
			[aRequest setHTTPMethod:@"POST"];
			NSString	*	stringBoundary	=	[NSString stringWithString:@"---------------------------0xKhTmLbOuNdArY"];
			NSString	*	contentType		=	[NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary];
			[aRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
			[aRequest setHTTPBody:[self multipartFormBodyWithStringBoundary:stringBoundary]];
			break;
		case PUT:
			[aRequest setHTTPMethod:@"PUT"];
			if (bodyDataArray && bodyDataArray.count == 1)
				[aRequest setHTTPBody:[bodyDataArray objectAtIndex:0]];
			break;
		//case DELETE:
		//	// Not yet implemented
		//	break;
		default:
			break;
	}
	
	return [(NSURLRequest *)aRequest retain];
}
- (NSData *)formBody
{
	if (cancelled)
		return nil;
	NSMutableString	*	buffer		=	[NSMutableString string];
	NSArray			*	keys		=	[bodyBufferDict allKeys];
	NSString		*	value		=	nil;
	for (NSString *key in keys) 
	{
		if (!cancelled)
		{
			value					=	[self urlEncodeString:[bodyBufferDict objectForKey:key]];
			value					=	[NSString stringWithFormat:@"&%@=%@", key, value];
			if (value)
				[buffer appendString:value];
			value	=	nil;
		} 
		else
			break;
	}
	if (buffer.length >0)
		[buffer deleteCharactersInRange:NSMakeRange(0, 1)];
	NSData			*	postBody	=	[NSData dataWithBytes:[buffer UTF8String] length:[buffer length]];
	return postBody;
}
- (NSString *)urlEncodeString:(NSString *)string
{
	NSString	*	encodedString	=	@"";
	if (!cancelled)
	{
		CFStringRef	escapeChars	=	CFSTR("/&?=+");
		CFStringRef	encodedText	=	CFURLCreateStringByAddingPercentEscapes(NULL, 
																			(CFStringRef)string, 
																			NULL, 
																			escapeChars, 
																			kCFStringEncodingUTF8);
		encodedString			=	[NSString stringWithFormat:@"%@", (NSString *)encodedText];
		CFRelease(encodedText);
		CFRelease(escapeChars);
	}
	return encodedString;
}
- (NSData *)multipartFormBodyWithStringBoundary:(NSString *)stringBoundary
{	
	NSMutableData	*	postBody	=	[NSMutableData data];
	NSArray			*	keys		=	[bodyBufferDict allKeys];
	NSString		*	value		=	nil;
	for (NSString *key in keys) 
	{
		if (!cancelled)
		{
			value					=	[bodyBufferDict objectForKey:key];
			if (value)
			{
				[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:[[NSString stringWithString:value] dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
			}
			value	=	nil;
		} 
		else
			break;
	}
	for (NSDictionary *dataDict in bodyDataArray)
	{
		NSString	*	fieldName	=	[dataDict objectForKey:@"fieldName"];
		NSString	*	fileName	=	[dataDict objectForKey:@"fileName"];
		NSString	*	contentType	=	[dataDict objectForKey:@"contentType"];
		NSData		*	data		=	[dataDict objectForKey:@"data"];
		if (fieldName && fileName && contentType && data && !cancelled)
		{
			[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
			[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
			[postBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", contentType] dataUsingEncoding:NSUTF8StringEncoding]];
			[postBody appendData:data];
			[postBody appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		}
	}
	[postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	return (NSData *)postBody;
}
/******************************************************************************/
#pragma mark -
#pragma mark NSURLConnection Delegate Methods
#pragma mark -
/******************************************************************************/
- (void)connection:(NSURLConnection *)connection 
didReceiveResponse:(NSURLResponse *)response
{
	CleanRelease(_response);
	_response	=	[response copy];
#if 0
	if ([[[_request URL] scheme] isEqual:@"http"] ||
		[[[_request URL] scheme] isEqual:@"https"])
	{
		NSInteger statusCode	=	[(NSHTTPURLResponse *)_response statusCode];
		if (statusCode == 403 ||
			statusCode == 404 ||
			statusCode == 500 ||
			statusCode == 503)
		{
			// Cleanup connection and data
			[_connection cancel];
			CleanRelease(_connection);
			CleanRelease(_data);
			// Report error to delegate
			NSError	*	error;
			switch (statusCode) {
				case 403:
					error	=	[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorNoPermissionsToReadFile userInfo:nil];
					break;
				case 404:
					error	=	[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorResourceUnavailable userInfo:nil];
					break;
				case 500:
					error	=	[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadServerResponse userInfo:nil];
					break;
				case 503:	// Should check for Retry-After header and schedule 
							// [self performSelector:@selector(start) withObject:nil afterDelay:retryAfter];
							// with some kind of retry limit
					error	=	[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotConnectToHost userInfo:nil];
					break;
				default:
					error	=	[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:nil];
					break;
			}
			if (self.delegate && [self.delegate respondsToSelector:@selector(networkRequestFailed:error:)])
				[self.delegate networkRequestFailed:self error:error];
		}
	}
#endif
    [_data setLength:0];
}
- (void)connection:(NSURLConnection *)connection 
	didReceiveData:(NSData *)data
{
    [_data appendData:data];
	if (connectionID)
	{
		long long length	=	[_response expectedContentLength];
		if (length == NSURLResponseUnknownLength)
		{
			NSNumber	*	percentCompleted	=
			[[NSNumber alloc] initWithFloat:(float)[_data length]/(float)length];
			// Post a notification with percent download completed and connectionID
			[percentCompleted release];
		}
	}
}
- (void)connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error
{
	// Cleanup connection and data
	[_connection cancel];
	CleanRelease(_connection);
	CleanRelease(_data);
	// Report error to delegate
	if (self.delegate && [self.delegate respondsToSelector:@selector(networkRequestFailed:error:)])
		[self.delegate networkRequestFailed:self error:error];
}
- (void)connection:(NSURLConnection *)connection 
   didSendBodyData:(NSInteger)bytesWritten 
 totalBytesWritten:(NSInteger)totalBytesWritten 
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
	if (connectionID)
	{
		NSNumber	*	percentCompleted	=
		[[NSNumber alloc] initWithFloat:(float)totalBytesWritten/(float)totalBytesExpectedToWrite];
		// Post a notification with percent completed and connectionID
		[percentCompleted release];
	}
}
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection 
				  willCacheResponse:(NSCachedURLResponse *)cachedResponse

{
	// Don't cache https
    NSCachedURLResponse	*	newCachedResponse	=	cachedResponse;
    if ([[[[cachedResponse response] URL] scheme] isEqual:@"https"])
        newCachedResponse						=	nil;
    return newCachedResponse;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//	
	//	Cleanup Connection
	//	
	CleanRelease(_connection);
	//	
	//	
	//	
	long long length				=	[_response expectedContentLength];
	//NSString	*	fileName		=	[_response suggestedFilename];
	//NSString	*	mimeType		=	[_response MIMEType];
	//NSString	*	textEncoding	=	[_response textEncodingName];
	if (_data && ((length == [_data length]) || (length == NSURLResponseUnknownLength)))
	{
		if (self.delegate && [self.delegate respondsToSelector:@selector(networkRequestDone:data:)])
			[self.delegate networkRequestDone:self data:_data];
	}
	else 
	{
		// Incomplete download
		// Report error to delegate
		NSError					*	error	=	[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUnknown userInfo:nil];
		if ([(NSObject *)self.delegate respondsToSelector:@selector(networkRequestFailed:error:)])
			[self.delegate networkRequestFailed:self error:error];
	}
	//	
	//	Cleanup data
	//	
    CleanRelease(_data);
}

@end
