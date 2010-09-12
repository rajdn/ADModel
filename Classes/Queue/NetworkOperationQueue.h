//	
//	NetworkOperationQueue.h
//	
//	Created by Doug Russell on 9/9/10.
//  Copyright Doug Russell 2010. All rights reserved.
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
#import "NetworkOperation.h"

@interface NetworkOperationQueue : NSObject <NetworkOperationQueueDelegate>
{
@public
	//	
	//	Maximum number of connections to dispatch at once
	//	
	NSUInteger				maxConcurrentOperationCount;
	//	
	//	Suspend any new connections being dispatched
	//	Currently executing operations will be allowed
	//	to complete
	//	
	BOOL					suspended;
@private
	//	
	//	NetworkOperation instances waiting to execute or being executed
	//	
	NSMutableArray		*	_operations;
	//	
	//	Thread queue to handle xml and json parsing
	//	
	NSOperationQueue	*	_parseQueue;
}

@property (nonatomic, assign)	NSUInteger	maxConcurrentOperationCount;
@property (nonatomic, getter=isSuspended)	BOOL	suspended;

//	
//	Operations currently in the queue.
//	
- (NSArray *)operations;
//	
//	Count of operations currently in queue
//	
- (NSUInteger)operationsCount;
//	
//	Add operation to queue and trigger queue to process it
//	
- (void)addOperation:(NetworkOperation *)op;
//	
//	Add several operations to queue and trigger queue to process them
//	Queue execution order is not based on array index
//	
- (void)addOperations:(NSArray *)ops;
//	
//	Cancel all operations currently in queue. Network connections in
//	progress will be canceled, parsing in process will not return data,
//	but may not immediately cease working.
//	
- (void)cancelAllOperations;

@end
