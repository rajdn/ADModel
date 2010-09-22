//	
//	NetworkOperationDelegate.h
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

@class NetworkOperation;

@protocol NetworkOperationDelegate
//	
//	Operation completed successfully, with given result
//	
- (void)networkOperationDidComplete:(NetworkOperation *)operation withResult:(id)result;
//	
//	Operation failed with given error, it is also often worth referencing the 
//	operation.result property for server response codes
//	
- (void)networkOperationDidFail:(NetworkOperation *)operation withError:(NSError *)error;
@optional

@end

@protocol NetworkOperationQueueDelegate
//	
//	Dequeue completed, cancelled or failed operation
//	
- (void)removeNetworkOperation:(NetworkOperation *)operation;
//	
//	NSOperationQueue for parsing XML and JSON
//	
- (NSOperationQueue *)parseQueue;
@optional

@end
