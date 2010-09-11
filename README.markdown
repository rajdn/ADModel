ADModel
=======

ADModel is my attempt to create an easy to use interface for managing batches of asynchronous network connections and offer simple parsing for JSON and xml.

Asynchronous Networking
------------

NetworkOperationQueue, inspired substantially by NSOperationQueue accepts instances NetworkOperation to which you can assign an NSURLRequest or the constituents of a request, which will then generate an appropriate request. Connections are executed using NSURLConnection asynchronously, currently on the main threads run loop, although that may change.

Parsing
----------------

Any data retrieved by a NetworkOperation can either be returned as is, or passed of to an NSOperationsQueue which can be used to parse XML or JSON.

Usage
----------------

Reference the sample calls in the ADModel project to see how it can be used.

