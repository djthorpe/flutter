
#import <Foundation/Foundation.h>
#import "MDNSPlugin.h"
#import "MDNSDelegate.h"

@interface MDNSPlugin ()

// Properties
@property(nonatomic, retain) MDNSDelegate* delegate;
@property(nonatomic, retain) NSNetServiceBrowser *serviceBrowser;
@property(nonatomic, retain) NSMutableArray* services;
@property(nonatomic) NSTimeInterval resolveTimeout;

// Methods
-(void)startDiscovery:(NSString* )serviceType inDomain:(NSString* )domain;
-(void)stopDiscovery;
@end

@implementation MDNSPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  // Channel for method calls
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"mdns_plugin"
            binaryMessenger:[registrar messenger]];
  MDNSPlugin* instance = [[MDNSPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  // Channel for delegate calls
  FlutterEventChannel* delegate = [[FlutterEventChannel alloc]
            initWithName:@"mdns_plugin_delegate"
         binaryMessenger:registrar.messenger
                   codec:[FlutterStandardMethodCodec sharedInstance]];
    instance.delegate = [[MDNSDelegate alloc] init];
    [delegate setStreamHandler:instance.delegate];  
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"startDiscovery" isEqualToString:call.method]) {
    NSDictionary* args = (NSDictionary* )call.arguments;
    NSString* serviceType = [args objectForKey:@"serviceType"];
    NSString* domain = @"local";
// TODO    NSString* domain = [args objectForKey:@"domain"];
    if(domain == nil || [domain isEqualToString:@""]) {
      [self startDiscovery:serviceType inDomain:@"local" resolveTimeout:5.0];
    } else {
      [self startDiscovery:serviceType inDomain:domain resolveTimeout:5.0];
    }
    result([NSNull null]);
  } else if ([@"stopDiscovery" isEqualToString:call.method]) {
      [self stopDiscovery];
      result([NSNull null]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

-(void)startDiscovery:(NSString* )serviceType inDomain:(NSString* )domain resolveTimeout:(NSTimeInterval)timeout {
  // If already started, then stop discovery
  [self stopDiscovery];

  // Initizalize browser
  self.resolveTimeout = timeout;
  self.services = [[NSMutableArray alloc] init];
  self.serviceBrowser = [[NSNetServiceBrowser alloc] init];
  self.serviceBrowser.delegate = self;

  // Callback
  [self.delegate onDiscoveryStarted];

  // Start search
  [self.serviceBrowser searchForServicesOfType:serviceType inDomain:domain];
}

-(void)stopDiscovery {
  if(self.serviceBrowser != nil) {
    [self.serviceBrowser stop];
    [self.delegate onDiscoveryStopped];
  }
  self.services = nil;
  self.serviceBrowser = nil;
}

#pragma mark NSNetServiceDelegate
-(void)netServiceDidResolveAddress:(NSNetService* )aNetService {
  [self.delegate onServiceResolved:aNetService];  
}

-(void)netService:(NSNetService* )sender didNotResolve:(NSDictionary* )errorDict {
  // Ignore the "didNotResolve" message
}

-(void)netService:(NSNetService* )sender didUpdateTXTRecordData:(NSData* )data {
  [self.delegate onServiceUpdated:sender];
}

#pragma NSNetServiceBrowserDelegate
-(void)netServiceBrowser:(NSNetServiceBrowser* )aNetServiceBrowser didFindService:(NSNetService* )aNetService moreComing:(BOOL)moreComing {
  [self.delegate onServiceFound:aNetService];  
  [aNetService setDelegate:self];
  [[self services] addObject:aNetService];
  [aNetService resolveWithTimeout:self.resolveTimeout];
  [aNetService startMonitoring];
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreServicesComing {
  [aNetService stopMonitoring];
  [self.services removeObject:aNetService];
  [self.delegate onServiceRemoved:aNetService];  
}

@end
