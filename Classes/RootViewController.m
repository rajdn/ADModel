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
- (void)badURL;
- (void)forbiddenURL;
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
//	[self twitterFeed];
//	[self postPrint];
//	[self postFilePrint];
//	[self postMultiFilePrint];
//	[self timeout];
//	[self badURL];
//	[self forbiddenURL];
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
	op.bufferDict				=	[NSDictionary dictionaryWithObjectsAndKeys:
									 @"keyOne", @"valueOne",
									 @"keyTwo", @"valueTwo", nil];
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
	op.bufferDict				=	[NSDictionary dictionaryWithObjectsAndKeys:
									 @"valueOne", @"keyOne",
									 @"valueTwo", @"keyTwo", nil];
	NSData			*	data	=	[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"File" ofType:@"txt"]];
	op.dataArray				=	[NSArray arrayWithObjects:
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
	op.bufferDict				=	[NSDictionary dictionaryWithObjectsAndKeys:
									 @"valueOne", @"keyOne",
									 @"valueTwo", @"keyTwo", nil];
	NSData			*	txtdata	=	[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"File" ofType:@"txt"]];
	NSData			*	imgdata	=	[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Image" ofType:@"jpg"]];
	op.dataArray				=	[NSArray arrayWithObjects:
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
- (void)badURL
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
/******************************************************************************/
#pragma mark -
#pragma mark Network Operation Delegate
#pragma mark -
/******************************************************************************/
- (void)networkOperationDidComplete:(NetworkOperation *)operation withResult:(id)result
{
	NSLog(@"Operation Complete for:\nInstance Code: %d\nConnectionID: %@\nURL: %@%@\n", 
		  operation.instanceCode,
		  operation.connectionID,
		  operation.baseURL,
		  operation.URI);
	if ([result isKindOfClass:[NSData class]])
		NSLog(@"\n\n\n%@\n\n\n", [[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease]);
	else
		NSLog(@"\n\n\n%@\n\n\n", result);
	// switch on instance code and or connectionID and forward results to wherever it should go
}
- (void)networkOperationDidFail:(NetworkOperation *)operation withError:(NSError *)error
{
	NSLog(@"Operation Failed for:\nInstance Code: %d\nConnectionID: %@\nURL: %@%@\n", 
		  operation.instanceCode,
		  operation.connectionID,
		  operation.baseURL,
		  operation.URI);
	NSLog(@"\n\n\n%@\n\n\n", error);
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

@end
