
#import <Foundation/Foundation.h>
#import "MDNSPlugin.h"
#import "MDNSDelegate.h"

@interface MDNSPlugin ()

// Properties
@property(nonatomic, retain) MDNSDelegate* delegate;
@property(nonatomic, retain) NSNetServiceBrowser *serviceBrowser;
@property(nonatomic, retain) NSMutableDictionary* services;
@property(nonatomic) NSTimeInterval resolveTimeout;
@property(nonatomic) BOOL enableUpdating;

// Methods
-(void)startDiscovery:(NSString* )serviceType inDomain:(NSString* )domain enableUpdating:(BOOL)enableUpdating resolveTimeout:(NSTimeInterval)timeout;
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
    id serviceType = [args objectForKey:@"serviceType"];
    id domain = [args objectForKey:@"domain"];
    id enableUpdating = [args objectForKey:@"enableUpdating"];
    if([domain isKindOfClass:[NSString class]] == NO || [(NSString* )domain isEqualToString:@""] == YES) {
      domain = @"local";
    }
    if([enableUpdating isKindOfClass:[NSNumber class]] == NO) {
      enableUpdating = [NSNumber numberWithBool:NO];
    }
    [self startDiscovery:serviceType inDomain:domain enableUpdating:[enableUpdating boolValue] resolveTimeout:[self resolveTimeout]];
    result([NSNull null]);
  } else if ([@"stopDiscovery" isEqualToString:call.method]) {
    [self stopDiscovery];
    result([NSNull null]);
  } else if ([@"resolveService" isEqualToString:call.method]) {
    NSDictionary* args = (NSDictionary* )call.arguments;
    id name = [args objectForKey:@"name"];
    id resolve = [args objectForKey:@"resolve"];
    if([resolve isKindOfClass:[NSNumber class]] == NO) {
      resolve = [NSNumber numberWithBool:NO];
    }
    [self resolveServiceWithName:name resolve:[resolve boolValue]];
    result([NSNull null]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

-(void)startDiscovery:(NSString* )serviceType inDomain:(NSString* )domain enableUpdating:(BOOL)enableUpdating resolveTimeout:(NSTimeInterval)timeout {
  // If already started, then stop discovery
  [self stopDiscovery];

  // Initizalize browser
  self.resolveTimeout = timeout;
  self.enableUpdating = enableUpdating;
  self.services = [[NSMutableDictionary alloc] init];
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
  [self.services removeAllObjects];
  self.services = nil;
  self.serviceBrowser = nil;
}

-(void)resolveServiceWithName:(NSString* )name resolve:(BOOL)resolve {
  NSNetService* aNetService = [[self services] objectForKey:name];
  if(aNetService != nil && resolve) {
    [aNetService resolveWithTimeout:self.resolveTimeout];
    if([self enableUpdating]) {
      [aNetService startMonitoring];
    }
  } else if (aNetService != nil && resolve == NO) {
    [self.services removeObjectForKey:[aNetService name]];  
  } else {
    NSLog(@"Warn: Cannot resolve service with name: %@:",name);
  }
}

#pragma mark NSNetServiceDelegate
-(void)netServiceDidResolveAddress:(NSNetService* )aNetService {
  [[self services] setObject:aNetService forKey:[aNetService name]];
  [self.delegate onServiceResolved:aNetService];  
}

-(void)netService:(NSNetService* )sender didNotResolve:(NSDictionary* )errorDict {  
  NSLog(@"Error: didNotResolve: %@: %@",sender,errorDict);
  [self.services removeObjectForKey:[sender name]];  
}

-(void)netService:(NSNetService* )sender didUpdateTXTRecordData:(NSData* )data {
  [self.delegate onServiceUpdated:sender];
}

#pragma NSNetServiceBrowserDelegate
-(void)netServiceBrowser:(NSNetServiceBrowser* )aNetServiceBrowser didFindService:(NSNetService* )aNetService moreComing:(BOOL)moreComing {
  [aNetService setDelegate:self];
  [[self services] setObject:aNetService forKey:[aNetService name]];
  [self.delegate onServiceFound:aNetService];  
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreServicesComing {
  if([self enableUpdating]) {
    [aNetService stopMonitoring];
  }
  [self.services removeObjectForKey:[aNetService name]];
  [self.delegate onServiceRemoved:aNetService];  
}

@end
