//	
//	RootViewController.m
//	ADModel
//	
//	Created by Doug Russell on 9/9/10.
//	Copyright Doug Russell 2010. All rights reserved.
//	
//	Licensed under the Apache License, Version 2.0 (the "License");
//	you may not use this file except in compliance with the License.
//	You may obtain a copy of the License at
//	
//	http://www.apache.org/licenses/LICENSE-2.0
//	
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.
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

#import "RootViewController.h"
#import "HandleXMLFeed.h"

@interface RootViewController ()
- (NSString *)generateConnectionID;
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
- (NSString *)logNSURLError:(int)errorCode;
@end

@implementation RootViewController

/******************************************************************************/
#pragma mark -
#pragma mark View Life Cycle
#pragma mark -
/******************************************************************************/
- (void)viewDidLoad 
{
	[super viewDidLoad];
	operationQueue	=	[[NetworkOperationQueue alloc] init];
	[operationQueue setMaxConcurrentOperationCount:10];
	//	
	//	Uncomment one or several of the sample calls to test run operations
	//	
//	[self podcastFeed];
//	[self twitterSearchFeed];
//	[self twitterUserFeed];
	[self postPrint];
//	[self postFilePrint];
//	[self postMultiFilePrint];
//	[self timeout];
//	[self missingFile];
//	[self forbiddenURL];
//	[self badServerURL];
//	[self unavailableURL];
//	[self putCreateURL];
//	[self putNoContentURL];
}
- (void)viewDidUnload 
{
    [super viewDidUnload];
}
/******************************************************************************/
#pragma mark -
#pragma mark Sample Ops
#pragma mark -
/******************************************************************************/
- (NSString *)generateConnectionID
{
	return [NSString stringWithFormat:@"%f", CFAbsoluteTimeGetCurrent()];
}
- (void)podcastFeed
{
	//	
	//	Retrieves and parses the RSS Feed for the podcast The Talk Show
	//	
	NetworkOperation	*	op	=	[[NetworkOperation alloc] init];
	op.delegate					=	self;
	op.instanceCode				=	kPodcastFeedCode;
	op.baseURL					=	@"http://feeds.feedburner.com";
	op.URI						=	@"/thetalkshow";
	op.parseType				=	ParseXML;
	op.xPath					=	@"item";
	op.connectionID				=	[self generateConnectionID];
	[operationQueue addOperation:op];
	[op release];
}
- (void)twitterSearchFeed
{
	//	
	//	*UNREVISEDCOMMENTS*
	//	
	NetworkOperation	*	op	=	[[NetworkOperation alloc] init];
	op.delegate					=	self;
	op.instanceCode				=	kTwitterSearchFeedCode;
	op.baseURL					=	@"http://search.twitter.com";
	op.URI						=	@"/search.json?q=+Asynchronous";
	op.parseType				=	ParseJSONDictionary;
	[operationQueue addOperation:op];
	op.connectionID				=	[self generateConnectionID];
	[op release];
}
- (void)twitterUserFeed
{
	//	
	//	*UNREVISEDCOMMENTS*
	//	
	NetworkOperation	*	op	=	[[NetworkOperation alloc] init];
	op.delegate					=	self;
	op.instanceCode				=	kTwitterUserFeedCode;
	op.baseURL					=	@"http://twitter.com";
	op.URI						=	@"/statuses/user_timeline/gruber.json";
	op.parseType				=	ParseJSONArray;
	[operationQueue addOperation:op];
	op.connectionID				=	[self generateConnectionID];
	[op release];
}
- (void)postPrint
{
	//	
	//	*UNREVISEDCOMMENTS*
	//	
	NetworkOperation	*	op	=	[[NetworkOperation alloc] init];
	op.delegate					=	self;
	op.requestType				=	POST;
	op.parseType				=	ParseXML;
	op.xPath					=	@"root";
	op.instanceCode				=	kPostPrintCode;
	op.URI						=	@"/ESModelAPI/Post/Form/";
	op.bodyBufferDict			=	[NSDictionary dictionaryWithObjectsAndKeys:
									 @"valueOne", @"keyOne",
									 @"valueTwo", @"keyTwo", nil];
	op.connectionID				=	[self generateConnectionID];
	[operationQueue addOperation:op];
	[op release];
}
- (void)postFilePrint
{
	//	
	//	*UNREVISEDCOMMENTS*
	//	
	NetworkOperation	*	op	=	[[NetworkOperation alloc] init];
	op.delegate					=	self;
	op.requestType				=	MULTI;
	op.parseType				=	ParseXML;
	op.xPath					=	@"root";
	op.instanceCode				=	kPostFilePrintCode;
	op.URI						=	@"/ESModelAPI/Post/Multipart/";
	op.bodyBufferDict				=	[NSDictionary dictionaryWithObjectsAndKeys:
									 @"valueOne", @"keyOne",
									 @"valueTwo", @"keyTwo", nil];
	NSData			*	data	=	[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"File" ofType:@"txt"]];
	op.bodyDataArray			=	[NSArray arrayWithObjects:
									 [NSDictionary dictionaryWithObjectsAndKeys:
									  @"uploadedfile", @"fieldName",
									  @"file.txt", @"fileName",
									  @"text/plain", @"contentType",
									  data, @"data", nil], nil];
	op.connectionID				=	[self generateConnectionID];
	[operationQueue addOperation:op];
	[op release];	
}
- (void)postMultiFilePrint
{
	//	
	//	*UNREVISEDCOMMENTS*
	//	
	NetworkOperation	*	op	=	[[NetworkOperation alloc] init];
	op.delegate					=	self;
	op.requestType				=	MULTI;
	op.parseType				=	ParseXML;
	op.xPath					=	@"root";
	op.instanceCode				=	6;
	op.URI						=	@"/ESModelAPI/Post/Multipart/";
	op.bodyBufferDict				=	[NSDictionary dictionaryWithObjectsAndKeys:
									 @"valueOne", @"keyOne",
									 @"valueTwo", @"keyTwo", nil];
	NSData			*	txtdata	=	[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"File" ofType:@"txt"]];
	NSData			*	imgdata	=	[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Image" ofType:@"jpg"]];
	op.bodyDataArray			=	[NSArray arrayWithObjects:
									 [NSDictionary dictionaryWithObjectsAndKeys:
									  @"uploadedtxtfile", @"fieldName",
									  @"file.txt", @"fileName",
									  @"text/plain", @"contentType",
									  txtdata, @"data", nil], 
									 [NSDictionary dictionaryWithObjectsAndKeys:
									  @"uploadedimgfile", @"fieldName",
									  @"image.jpg", @"fileName",
									  @"image/jpeg", @"contentType",
									  imgdata, @"data", nil], nil];
	op.connectionID				=	[self generateConnectionID];
	[operationQueue addOperation:op];
	[op release];
}
- (void)timeout
{
	//	
	//	Call a URL that will stall for 20 seconds,
	//	which should always timeout
	//	
	NetworkOperation	*	op	=	[[NetworkOperation alloc] init];
	op.delegate					=	self;
	op.instanceCode				=	kTimeoutCode;
	op.URI						=	@"/ESModelAPI/Timeout/";
	op.parseType				=	NoParse;
	op.connectionID				=	[self generateConnectionID];
	[operationQueue addOperation:op];
	[op release];
}
- (void)forbiddenURL
{
	//	
	//	Call a URL that returns a 403
	//	
	NetworkOperation	*	op	=	[[NetworkOperation alloc] init];
	op.delegate					=	self;
	op.instanceCode				=	kForbiddenURLCode;
	op.URI						=	@"/ESModelAPI/Forbidden/";
	op.parseType				=	NoParse;
	op.connectionID				=	[self generateConnectionID];
	[operationQueue addOperation:op];
	[op release];
}
- (void)missingFile
{
	//	
	//	Call a URL that returns a 404
	//	
	NetworkOperation	*	op	=	[[NetworkOperation alloc] init];
	op.delegate					=	self;
	op.instanceCode				=	kBadURLCode;
	op.URI						=	@"/ESModelAPI/DoesntExist/";
	op.parseType				=	NoParse;
	op.connectionID				=	[self performSelector:@selector(generateConnectionID)];
	[operationQueue addOperation:op];
	[op release];
}
- (void)badServerURL
{
	//	
	//	Call a URL that returns a 500
	//	
	NetworkOperation	*	op	=	[[NetworkOperation alloc] init];
	op.delegate					=	self;
	op.instanceCode				=	kBadServerURLCode;
	op.URI						=	@"/ESModelAPI/BadResponse/";
	op.parseType				=	NoParse;
	op.connectionID				=	[self generateConnectionID];
	[operationQueue addOperation:op];
	[op release];
}
- (void)unavailableURL
{
	//	
	//	Call a URL that returns a 503
	//	
	NetworkOperation	*	op	=	[[NetworkOperation alloc] init];
	op.delegate					=	self;
	op.instanceCode				=	kUnavailableURLCode;
	op.URI						=	@"/ESModelAPI/Unavailable/";
	op.parseType				=	NoParse;
	op.connectionID				=	[self generateConnectionID];
	[operationQueue addOperation:op];
	[op release];
}
- (void)putCreateURL
{
	//	
	//	*UNREVISEDCOMMENTS*
	//	
	NetworkOperation	*	op	=	[[NetworkOperation alloc] init];
	op.delegate					=	self;
	op.requestType				=	PUT;
	op.parseType				=	NoParse;
	op.instanceCode				=	kPutCreateURL;
	op.URI						=	@"/ESModelAPI/Put/Created/index.php";
	op.headerDict				=	[NSDictionary dictionaryWithObjectsAndKeys:
									 @"Header_Value_One", @"Header_Field_One",
									 @"Header_Value_Two", @"Header_Field_Two", nil];
	op.bodyDataArray				=	[NSArray arrayWithObject:[@"Put Test String Encoded As Data\n" dataUsingEncoding:NSUTF8StringEncoding]];
	op.connectionID				=	[self generateConnectionID];
	[operationQueue addOperation:op];
	[op release];
}
- (void)putNoContentURL
{
	//	
	//	*UNREVISEDCOMMENTS*
	//	
	NetworkOperation	*	op	=	[[NetworkOperation alloc] init];
	op.delegate					=	self;
	op.requestType				=	PUT;
	op.parseType				=	NoParse;
	op.instanceCode				=	kPutCreateURL;
	op.URI						=	@"/ESModelAPI/Put/NoContent/index.php";
	op.headerDict				=	[NSDictionary dictionaryWithObjectsAndKeys:
									 @"Header_Value_One", @"Header_Field_One",
									 @"Header_Value_Two", @"Header_Field_Two", nil];
	op.bodyDataArray				=	[NSArray arrayWithObject:[@"Put Test String Encoded As Data\n" dataUsingEncoding:NSUTF8StringEncoding]];
	op.connectionID				=	[self generateConnectionID];
	[operationQueue addOperation:op];
	[op release];
}
/******************************************************************************/
#pragma mark -
#pragma mark Network Operation Delegate
#pragma mark -
/******************************************************************************/
- (void)networkOperationDidComplete:(NetworkOperation *)operation withResult:(id)result
{
	id	value	=	nil;
	if ([result isKindOfClass:[NSData class]])
		value	=	[[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease];
	else
		value	=	result;
	NSInteger	statusCode	=	0;
	if ([operation.response isKindOfClass:[NSHTTPURLResponse class]])
		statusCode	=	[(NSHTTPURLResponse *)operation.response statusCode];
	NSLog(@"\n\nOperation Complete for:\nInstance Code: %d\nConnectionID: %@\nURL: %@%@\nResponse Status Code: %d\n\n%@\n\n", 
		  operation.instanceCode,
		  operation.connectionID,
		  operation.baseURL,
		  operation.URI,
		  statusCode,
		  value);
	// switch on instance code and or connectionID and forward results to wherever it should go
}
- (void)networkOperationDidFail:(NetworkOperation *)operation withError:(NSError *)error
{
	NSInteger	statusCode	=	0;
	if ([operation.response isKindOfClass:[NSHTTPURLResponse class]])
		statusCode	=	[(NSHTTPURLResponse *)operation.response statusCode];
	NSLog(@"\n\nOperation Failed for:\nInstance Code: %d\nConnectionID: %@\nURL: %@%@\nError: %@\nResponse Status Code: %d\n%@\n\n", 
		  operation.instanceCode,
		  operation.connectionID,
		  operation.baseURL,
		  operation.URI,
		  error,
		  statusCode,
		  [self logNSURLError:error.code]);
	// Report error
}
/******************************************************************************/
#pragma mark -
#pragma mark Memory Management
#pragma mark -
/******************************************************************************/
- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}
- (void)dealloc 
{
	[operationQueue cancelAllOperations];
	[operationQueue release]; operationQueue = nil;
    [super dealloc];
}
/******************************************************************************/
#pragma mark -
#pragma mark 
#pragma mark -
/******************************************************************************/
- (NSString *)logNSURLError:(int)errorCode
{
	switch (errorCode) {
		case NSURLErrorUnknown:
			//Returned when the URL Loading system encounters an error that it cannot interpret.
			//This can occur when an error originates from a lower level framework or library. 
			//Whenever this error code is received, it is a bug, and should be reported to Apple.
			return @"NSURLErrorUnknown";
			break;
		case NSURLErrorCancelled:
			//Returned when an asynchronous load is canceled.
			//A Web Kit framework delegate will receive this error when it performs a cancel 
			//operation on a loading resource. Note that an NSURLConnection or NSURLDownload 
			//delegate will not receive this error if the download is canceled.
			return @"NSURLErrorCancelled";
			break;
		case NSURLErrorBadURL:
			//Returned when a URL is sufficiently malformed that a URL request cannot be initiated
			return @"NSURLErrorBadURL";
			break;
		case NSURLErrorTimedOut:
			//Returned when an asynchronous operation times out.
			//NSURLConnection will send this error to its delegate when the timeoutInterval in 
			//NSURLRequest expires before a load can complete.
			return @"NSURLErrorTimedOut";
			break;
		case NSURLErrorUnsupportedURL:
			//Returned when a properly formed URL cannot be handled by the framework.
			//The most likely cause is that there is no available protocol handler for the URL.
			return @"NSURLErrorUnsupportedURL";
			break;
		case NSURLErrorCannotFindHost:
			//Returned when the host name for a URL cannot be resolved.
			return @"Returned when the host name for a URL cannot be resolved.";
			break;
		case NSURLErrorCannotConnectToHost:
			//Returned when an attempt to connect to a host has failed.
			//This can occur when a host name resolves, but the host is down or may not be 
			//accepting connections on a certain port.
			return @"NSURLErrorCannotConnectToHost";
			break;
		case NSURLErrorDataLengthExceedsMaximum:
			//Returned when the length of the resource data exceeds the maximum allowed.
			return @"NSURLErrorDataLengthExceedsMaximum";
			break;
		case NSURLErrorNetworkConnectionLost:
			//Returned when a client or server connection is severed in the middle of an in-progress load.
			return @"NSURLErrorNetworkConnectionLost";
			break;
		case NSURLErrorDNSLookupFailed:
			//See NSURLErrorCannotFindHost
			return @"NSURLErrorDNSLookupFailed";
			break;
		case NSURLErrorHTTPTooManyRedirects:
			//Returned when a redirect loop is detected or when the threshold for number of allowable 
			//redirects has been exceeded (currently 16.
			return @"NSURLErrorHTTPTooManyRedirects";
			break;
		case NSURLErrorResourceUnavailable:
			//Returned when a requested resource cannot be retrieved.
			//Examples are “file not found”, and data decoding problems that prevent data from 
			//being processed correctly.
			return @"NSURLErrorResourceUnavailable";
			break;
		case NSURLErrorNotConnectedToInternet:
			//Returned when a network resource was requested, but an internet connection is 
			//not established and cannot be established automatically, either through a lack 
			//of connectivity, or by the user's choice not to make a network connection automatically.
			return @"NSURLErrorNotConnectedToInternet";
			break;
		case NSURLErrorRedirectToNonExistentLocation:
			//Returned when a redirect is specified by way of server response code, but the 
			//server does not accompany this code with a redirect URL.
			return @"NSURLErrorRedirectToNonExistentLocation";
			break;
		case NSURLErrorBadServerResponse:
			//Returned when the URL Loading system receives bad data from the server.
			//This is equivalent to the “500 Server Error” message sent by HTTP servers.
			return @"NSURLErrorBadServerResponse";
			break;
		case NSURLErrorUserCancelledAuthentication:
			//Returned when an asynchronous request for authentication is cancelled by the user.
			//This is typically incurred by clicking a “Cancel” button in a username/password dialog, 
			//rather than the user making an attempt to authenticate.
			return @"NSURLErrorUserCancelledAuthentication";
			break;
		case NSURLErrorUserAuthenticationRequired:
			//Returned when authentication is required to access a resource.
			return @"NSURLErrorUserAuthenticationRequired";
			break;
		case NSURLErrorZeroByteResource:
			//Returned when a server reports that a URL has a non-zero content length, but 
			//terminates the network connection “gracefully” without sending any data.
			return @"NSURLErrorUserAuthenticationRequired";
			break;
		case NSURLErrorCannotDecodeRawData:
			//Returned when content data received during an NSURLConnection request cannot be 
			//decoded for a known content encoding.
			return @"NSURLErrorCannotDecodeRawData";
			break;
		case NSURLErrorCannotDecodeContentData:
			//Returned when content data received during an NSURLConnection request has an unknown 
			//content encoding.
			return @"NSURLErrorCannotDecodeContentData";
			break;
		case NSURLErrorCannotParseResponse:
			//Returned when a response to an NSURLConnection request cannot be parsed.
			return @"NSURLErrorCannotParseResponse";
			break;
		case NSURLErrorInternationalRoamingOff:
			//Returned when a connection would require activating a data context while roaming, 
			//but international roaming is disabled.
			return @"NSURLErrorInternationalRoamingOff";
			break;
		case NSURLErrorCallIsActive:
			//Returned when a connection is attempted while a phone call is active on a network 
			//that does not support simultaneous phone and data communication (EDGE or GPRS.
			return @"NSURLErrorCallIsActive";
			break;
		case NSURLErrorRequestBodyStreamExhausted:
			//Returned when a body stream is needed but the client does not provide one. 
			//This impacts clients on iOS that send a POST request using a body stream but do not 
			//implement the NSURLConnection delegate method connection:needNewBodyStream.
			return @"NSURLErrorRequestBodyStreamExhausted";
			break;
		case NSURLErrorFileDoesNotExist:
			//Returned when a file does not exist.
			return @"NSURLErrorFileDoesNotExist";
			break;
		case NSURLErrorFileIsDirectory:
			//Returned when a request for an FTP file results in the server responding that the 
			//file is not a plain file, but a directory.
			return @"NSURLErrorFileIsDirectory";
			break;
		case NSURLErrorNoPermissionsToReadFile:
			//Returned when a resource cannot be read due to insufficient permissions.
			return @"NSURLErrorNoPermissionsToReadFile";
			break;
		case NSURLErrorSecureConnectionFailed:
			//Returned when an attempt to establish a secure connection fails for reasons 
			//which cannot be expressed more specifically.
			return @"NSURLErrorSecureConnectionFailed";
			break;
		case NSURLErrorServerCertificateHasBadDate:
			//Returned when a server certificate has a date which indicates it has expired, 
			//or is not yet valid.
			return @"NSURLErrorServerCertificateHasBadDate";
			break;
		case NSURLErrorServerCertificateUntrusted:
			//Returned when a server certificate is signed by a root server which is not trusted.
			return @"NSURLErrorServerCertificateUntrusted";
			break;
		case NSURLErrorServerCertificateHasUnknownRoot:
			//Returned when a server certificate is not signed by any root server.
			return @"NSURLErrorServerCertificateHasUnknownRoot";
			break;
		case NSURLErrorServerCertificateNotYetValid:
			//Returned when a server certificate is not yet valid.
			return @"NSURLErrorServerCertificateNotYetValid";
			break;
		case NSURLErrorClientCertificateRejected:
			//Returned when a server certificate is rejected.
			return @"NSURLErrorClientCertificateRejected";
			break;
		case NSURLErrorClientCertificateRequired:
			//Returned when a client certificate is required to authenticate an 
			//SSL connection during an NSURLConnection request.
			return @"NSURLErrorClientCertificateRequired";
			break;
		case NSURLErrorCannotLoadFromNetwork:
			//Returned when a specific request to load an item only from the cache cannot be satisfied.
			//This error is sent at the point when the library would go to the network accept for the 
			//fact that is has been blocked from doing so by the “load only from cache” directive.
			return @"NSURLErrorCannotLoadFromNetwork";
			break;
		case NSURLErrorCannotCreateFile:
			//Returned when NSURLDownload object was unable to create the downloaded file on disk due to a I/O failure.
			return @"NSURLErrorCannotCreateFile";
			break;
		case NSURLErrorCannotOpenFile:
			//Returned when NSURLDownload was unable to open the downloaded file on disk.
			return @"NSURLErrorCannotOpenFile";
			break;
		case NSURLErrorCannotCloseFile:
			//Returned when NSURLDownload was unable to close the downloaded file on disk.
			return @"NSURLErrorCannotCloseFile";
			break;
		case NSURLErrorCannotWriteToFile:
			//Returned when NSURLDownload was unable to write to the downloaded file on disk.
			return @"NSURLErrorCannotWriteToFile";
		case NSURLErrorCannotRemoveFile:
			//Returned when NSURLDownload was unable to remove a downloaded file from disk.
			return @"NSURLErrorCannotRemoveFile";
		case NSURLErrorCannotMoveFile:
			//Returned when NSURLDownload was unable to move a downloaded file on disk.
			return @"NSURLErrorCannotMoveFile";
		case NSURLErrorDownloadDecodingFailedMidStream:
			//Returned when NSURLDownload failed to decode an encoded file during the download.
			return @"NSURLErrorDownloadDecodingFailedMidStream";
		case NSURLErrorDownloadDecodingFailedToComplete:
			//Returned when NSURLDownload failed to decode an encoded file after downloading.
			return @"NSURLErrorDownloadDecodingFailedToComplete";
		default:
			break;
	}
	return nil;
}

@end
