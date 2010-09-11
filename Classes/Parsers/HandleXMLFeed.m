//	
//	HandleXMLFeed.m
//	
//  Copyright 2009 Doug Russell
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

#import "HandleXMLFeed.h"
#import "TouchXML.h"

@interface HandleXMLFeed ()
- (NSDictionary *)processNode:(CXMLNode *)node;
@end

@implementation HandleXMLFeed
@synthesize feedEntries;
@synthesize data	=	_data;
@synthesize xpath	=	_xpath;

- (id)initWithData:(NSData *)data xPath:(NSString *)xPath
{
	if ((self = [super init]))
	{
		self.feedEntries	=	[[[NSMutableArray alloc] init] autorelease];
		self.data			=	data;
		self.xpath			=	xPath;
	}
	return self;
}
- (NSArray *)parse
{
	// Create a new rssParser object based on the TouchXML "CXMLDocument" class, this is the
	// object that actually grabs and processes the RSS data
	CXMLDocument	*	rssParser	=	[[[CXMLDocument alloc] initWithData:self.data options:0 error:nil] autorelease];
	
	// Create a new Array object to be used with the looping of the results from the rssParser
	NSArray			*	resultNodes	=	nil;
	
	// Set the resultNodes Array to contain an object for every instance of an  node in our RSS feed
	resultNodes						=	[rssParser nodesForXPath:_xpath error:nil];
	
	// Loop through the resultNodes to access each items actual data

	for (CXMLElement *resultElement in resultNodes) 
	{
		NSDictionary	*	feedItem	=	[self processNode:(CXMLElement *)resultElement];
		if (feedItem)
			[feedEntries addObject:feedItem];
	}
	
	return (NSArray *)feedEntries;
}
- (NSDictionary *)processNode:(CXMLNode *)node
{
	// Create a temporary MutableDictionary to store the items fields in, 
	// which will eventually end up in feedEntries
	NSMutableDictionary	*	feedItem	=	[NSMutableDictionary dictionary];
	
	// Create a counter variable as type "int"
	int	counter	=	0;
	
	id	strVal	=	nil;
	// Loop through the children of the current  node
	for(counter = 0; counter < [node childCount]; counter++) 
	{
		CXMLNode	*	child	=	[node childAtIndex:counter];
		
		NSMutableDictionary	*	attribDict	=	nil;
		if ([child isMemberOfClass:[CXMLElement class]])
		{
			NSArray	*	attributes	=	[(CXMLElement *)child attributes];
			if (attributes && attributes.count > 0)
			{
				attribDict	=	[NSMutableDictionary dictionary];
				//NSLog(@"Attributes For: %@", [child name]);
				for (CXMLNode *attribute in attributes)
				{
					//NSLog(@"%@ : %@", [attribute name], [attribute stringValue]);
					[attribDict setObject:[attribute stringValue] forKey:[attribute name]];
				}
			}
		}
		
		if (attribDict)
			[feedItem setObject:attribDict forKey:[NSString stringWithFormat:@"%@-attributes", [child name]]];
		
		strVal					=	[child stringValue];
		
		if ([[[[strVal stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] length] == 0)
			strVal	=	nil;
		
		if (!strVal) 
		{
			strVal				=	[self processNode:child];
			if ([[strVal allKeys] count] == 0)
				strVal = @"";
		}
		
		if (strVal) // Add each field to the feedItem Dictionary with the node name as key and node value as the value
			[feedItem setObject:strVal forKey:[child name]];
		
		strVal	=	nil;
	}
	
	return (NSDictionary *)feedItem;
}
- (void)dealloc
{
	[feedEntries release];
	[_data release];
	[_xpath release];
	[super dealloc];
}

@end
