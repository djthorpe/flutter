#import <Flutter/Flutter.h>

@interface MDNSDelegate : NSObject <FlutterStreamHandler>
-(void)onDiscoveryStopped;
-(void)onDiscoveryStarted;
-(void)onServiceFound:(NSNetService* )service;
-(void)onServiceResolved:(NSNetService* )service;
-(void)onServiceUpdated:(NSNetService* )service;
-(void)onServiceRemoved:(NSNetService* )service;
@end