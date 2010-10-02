//	
//	NetworkOperationQueue.m
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

#import "NetworkOperationQueue.h"

@interface NetworkOperationQueue ()
- (NSMutableArray *)_operations;
- (NSOperationQueue *)parseQueue;
- (void)processQueue;
@end

@implementation NetworkOperationQueue
@synthesize maxConcurrentOperationCount;
@dynamic	suspended;

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
		_operations	=	nil;
		_parseQueue	=	nil;
	}
	return self;
}
- (void)dealloc
{
	CleanRelease(_operations);
	[_parseQueue cancelAllOperations];
	CleanRelease(_parseQueue);
	[super dealloc];
}
/******************************************************************************/
#pragma mark -
#pragma mark Add Operations
#pragma mark -
/******************************************************************************/
- (void)addOperation:(NetworkOperation *)op
{
	//	
	//	Assign queue, add operation to operations waiting for execution
	//	or already executing, check queue for available slots
	//	
	[op setQueue:self];
	[[self _operations] addObject:op];
	[self processQueue];
}
- (void)addOperations:(NSArray *)ops
{
	//	
	//	Assign queue, add operation to operations waiting for execution
	//	or already executing, check queue for available slots
	//	
	[ops makeObjectsPerformSelector:@selector(setQueue:) withObject:self];
	[[self _operations] addObjectsFromArray:ops];
	[self processQueue];
}
/******************************************************************************/
#pragma mark -
#pragma mark 
#pragma mark -
/******************************************************************************/
- (void)cancelAllOperations
{
	//	
	//	Cancel all network operations
	//	
	[[self _operations] makeObjectsPerformSelector:@selector(cancel)];
	//	
	//	Cancel all parsing operations
	//	
	[[self parseQueue] cancelAllOperations];
}
/******************************************************************************/
#pragma mark -
#pragma mark A Wee Bit Of Insight
#pragma mark -
/******************************************************************************/
- (NSArray *)operations
{
	return (NSArray *)[self _operations];
}
- (NSMutableArray *)_operations
{
	//	
	//	Initialize if necessary and return operations array
	//	
	if (_operations == nil)
		_operations = [[NSMutableArray alloc] init];
	return _operations;
}
- (NSUInteger)operationsCount
{
	return [[self _operations] count];
}
- (NSOperationQueue *)parseQueue
{
	//	
	//	Initialize if necessary and return parsing operations queue
	//	
	if (_parseQueue == nil)
	{
		_parseQueue	=	[[NSOperationQueue alloc] init];
		[_parseQueue setMaxConcurrentOperationCount:[[NSProcessInfo processInfo] activeProcessorCount] + 1];
	}
	return _parseQueue;
}
/******************************************************************************/
#pragma mark -
#pragma mark The Business
#pragma mark -
/******************************************************************************/
- (BOOL)suspended
{
	return suspended;
}
- (void)setSuspended:(BOOL)shouldSuspend
{
	suspended	=	shouldSuspend;
	[self processQueue];
}
- (void)processQueue
{
	if (suspended)
		return;
	@synchronized(self)
	{
		//	
		//	Find inactive operations
		//	
		NSMutableSet	*	inactiveOperations	=	[[NSMutableSet alloc] init];
		__block NSInteger	activeOperations	=	0;
		NSArray			*	currentOperations	=	[NSArray arrayWithArray:[self _operations]];
		[currentOperations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			if ([(NetworkOperation *)obj isExecuting] && ![(NetworkOperation *)obj isDone])
				activeOperations += 1;
			else
				[inactiveOperations addObject:obj];
		}];
		//	
		//	Start as many operations as there are slots available in the queue
		//	
		NSInteger			availableSlots		=	maxConcurrentOperationCount - activeOperations;
		for (NSInteger i = 0; i < MIN(availableSlots, [inactiveOperations count]); i++)
		{
			NetworkOperation	*	op	=	(NetworkOperation *)[inactiveOperations anyObject];
			[op start];
			[inactiveOperations removeObject:op];
		}
		CleanRelease(inactiveOperations);
	}
}
- (void)removeNetworkOperation:(NetworkOperation *)operation
{
	//	
	//	Remove operation, check queue for available slots
	//	
	[[self _operations] removeObject:operation];
	[self processQueue];
}

@end
