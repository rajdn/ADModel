ADModel
=======

ADModel is my attempt to create an easy to use interface for managing batches of asynchronous network connections and offer simple parsing for JSON and XML.

Asynchronous Networking
------------

NetworkOperationQueue, inspired substantially by NSOperationQueue accepts instances NetworkOperation to which you can assign an NSURLRequest or the constituents of a request, which will then generate an appropriate request. Connections are executed using NSURLConnection asynchronously, currently on the main threads run loop, although that may change.

Parsing
----------------

Any data retrieved by a NetworkOperation can either be returned as is, or passed of to an NSOperationsQueue which can be used to parse XML or JSON.

Usage
----------------

Reference the sample calls in the ADModel project to see how it can be used.

##NetworkOperationQueue Class Reference : 
>###Overview - 
>>Declared in NetworkOperationQueue.h
>
>###Properties - 
>####NSUInteger	maxConcurrentOperationCount
>>Maximum number of connections to dispatch at once
>>@property (nonatomic, assign)	NSUInteger	maxConcurrentOperationCount;
>
>####BOOL	suspended
>>Suspend any new connections being dispatched
>>Currently executing operations will be allowed to complete
>>@property (nonatomic, getter=isSuspended)	BOOL	suspended;
>
>###Tasks - 
>
>####Inspect Queue:
>>-(NSArray *)operations;
>>-(NSUInteger)operationsCount;
>
>####Add operations to queue:
>>-(void)addOperation:(NetworkOperation *)op;
>>-(void)addOperations:(NSArray *)ops;
>
>####Cancel:
>>-(void)cancelAllOperations;
>
>###Class Methods - 
>
>###Instance Methods - 
>
>####- (NSArray *)operations;
>>Operations currently in the queue.
>
>####- (NSUInteger)operationsCount;
>>Count of operations currently in queue
>
>####- (void)addOperation:(NetworkOperation *)op;
>>Add operation to queue and trigger queue to process it
>
>####- (void)addOperations:(NSArray *)ops;
>>Add several operations to queue and trigger queue to process them
>>Queue execution order is not based on array index
>
>####- (void)cancelAllOperations;
>>Cancel all operations currently in queue. Network connections in
>>progress will be canceled, parsing in process will not return data,
>>but may not immediately cease working.
>
>###Constants - 



##NetworkOperationQueueDelegate Protocol Reference : 
>###Overview - 
>>Declared in NetworkOperationDelegate.h
>
>###Tasks - 
>####Queue Management:
>>-(void)removeNetworkOperation:(NetworkOperation *)operation;
>>-(NSOperationQueue *)parseQueue;
>
>###Instance Methods - 
>
>####- (void)removeNetworkOperation:(NetworkOperation *)operation;
>>Dequeue completed, cancelled or failed operation
>
>####- (NSOperationQueue *)parseQueue;
>>Queue for parsing XML and JSON



##NetworkOperation Class Reference : 
>###Overview - 
>>Declared in NetworkOperation.h
>
>###Properties - 
>####id&lt;NetworkOperationDelegate, NSObject> delegate
>>@property (nonatomic, assign)	id&lt;NetworkOperationDelegate, NSObject&gt; delegate;
>####id&lt;NetworkOperationQueueDelegate, NSObject&gt; queue;
>>@property (nonatomic, assign)	id&lt;NetworkOperationQueueDelegate, NSObject&gt; queue;
>####NSString	*	baseURL;
>>@property (nonatomic, retain)	NSString	*	baseURL;
>####NSString		*	URI;
>>@property (nonatomic, retain)	NSString		*	URI;
>####BOOL	cancelled;
>>@property (nonatomic, getter=isCancelled)	BOOL	cancelled;
>####BOOL	executing;
>>@property (nonatomic, getter=isExecuting)	BOOL	executing;
>####NSInteger	instanceCode;
>>@property (nonatomic, assign)	NSInteger	instanceCode;
>####NSString	*	connectionID;
>>@property (nonatomic, retain)	NSString	*	connectionID;
>####NSDictionary	*	headerDict;
>>@property (nonatomic, retain)	NSDictionary	*	headerDict;
>####NSDictionary	*	bodyBufferDict;
>>@property (nonatomic, retain)	NSDictionary	*	bodyBufferDict;
>####NSArray	*	bodyDataArray;
>>@property (nonatomic, retain)	NSArray	*	bodyDataArray;
>####NSDictionary	*	userInfo;
>>@property (nonatomic, retain)	NSDictionary	*	userInfo;
>####NSString	*	xPath;
>>@property (nonatomic, retain)	NSString		*	xPath;
>####NetworkOperationParseType	parseType;
>>@property (nonatomic, assign)	NetworkOperationParseType	parseType;
>####NetworkRequestType	requestType;
>>@property (nonatomic, assign)	NetworkRequestType	requestType;
>
>###Tasks - 
>####Operation Management:
>>-(void)start;
>>-(void)cancel;
>
>###Class Methods - 
>
>###Instance Methods - 
>####- (void)start;
>>Called by queue to start operation. Do not call directly.
>####- (void)cancel;
>>Called by queue after cancelAllOperations call or can be called directly
>
>###Constants - 
>####NetworkOperationParseType - 
>>typedef enum {
>>	NoParse,
>>	ParseXML,
>>	ParseJSONDictionary,
>>	ParseJSONArray,
>>} NetworkOperationParseType;



##NetworkOperationDelegate Protocol Reference : 
>###Overview - 
>>Declared in NetworkOperationDelegate.h
>
>###Tasks - 
>
>###Instance Methods - 
>



##NetworkRequest Class Reference : 
>###Overview - 
>>Declared in NetworkRequest.h
>
>###Tasks - 
>
>###Class Methods - 
>
>###Instance Methods - 
>
>###Constants - 



##NetworkRequestDelegate Protocol Reference : 
>###Overview - 
>>Declared in NetworkRequestDelegate.h
>
>###Tasks - 
>
>###Instance Methods - 
>



##HandleXMLFeed Class Reference : 
>###Overview - 
>>Declared in HandleXMLFeed.h
>
>###Tasks - 
>
>###Class Methods - 
>
>###Instance Methods - 
>
>###Constants - 



Completeness
----------------

This is still very much a work in progress, it is functional, but not polished and still missing some features I'd like it to have, like better PUT/DELETE support and HTTP Authentication.

Dependancies
----------------

This project uses these two projects (kind of one project) for parsing, if you don't need one or the other, it's not to hard to take out one or both. JSON doesn't have any dependancies, XML does link against libxml2.

TouchJSON
http://github.com/schwa/TouchJSON

TouchXML
http://github.com/schwa/TouchXML
(Project must have Other Linker Flag -lxml2 and Header Search Path /usr/include/libxml2)
