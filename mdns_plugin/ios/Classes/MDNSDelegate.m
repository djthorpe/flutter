#import "MDNSDelegate.h"
#import "NSNetService+Util.h"

/////////////////////////////////////////////////////////////////////

@interface MDNSDelegate()
@end

/////////////////////////////////////////////////////////////////////

@implementation MDNSDelegate {
    FlutterEventSink _eventSink;
}

/////////////////////////////////////////////////////////////////////
#pragma FlutterStreamHandler

-(FlutterError *_Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)events {
    _eventSink = events;
    return nil;
}

-(FlutterError *_Nullable)onCancelWithArguments:(id _Nullable)arguments {
    return nil;
}

/////////////////////////////////////////////////////////////////////
#pragma Events from NSServiceBrowser

-(void)onDiscoveryStopped {
    _eventSink(@{ @"method": @"onDiscoveryStopped" });
}

-(void)onDiscoveryStarted {
    _eventSink(@{ @"method": @"onDiscoveryStarted" });
}

-(void)onServiceFound:(NSNetService* )service {
    _eventSink([MDNSDelegate serviceToDictionary:service method:@"onServiceFound"]);
}

-(void)onServiceResolved:(NSNetService* )service {
    _eventSink([MDNSDelegate serviceToDictionary:service method:@"onServiceResolved"]);
}

-(void)onServiceRemoved:(NSNetService* )service {
    _eventSink([MDNSDelegate serviceToDictionary:service method:@"onServiceRemoved"]);
}

-(void)onServiceUpdated:(NSNetService* )service {
    _eventSink([MDNSDelegate serviceToDictionary:service method:@"onServiceUpdated"]);
}

/////////////////////////////////////////////////////////////////////
#pragma Private Methods

+(NSDictionary* )serviceToDictionary:(NSNetService* )aNetService method:(NSString* )method {
    NSData* txtdata = [aNetService TXTRecordData];
    NSDictionary* dict = [NSNetService dictionaryFromTXTRecordData:txtdata];
    return @{
        @"method": method,
        @"txt": nil == dict ? [NSMutableDictionary dictionary] : dict,
        @"name": nil == [aNetService name] ? @"" : [aNetService name],
        @"type": nil == [aNetService type] ? @"" : [aNetService type],
        @"hostName": nil == [aNetService hostName] ? @"" : [aNetService hostName],
        @"address": [aNetService addressArray],
        @"port": [NSNumber numberWithLong:[aNetService port]]
    };
}

@end
