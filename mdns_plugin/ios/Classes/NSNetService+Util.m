#import "NSNetService+Util.h"
#include <arpa/inet.h>

// Source:
// https://stackoverflow.com/questions/938521/iphone-bonjour-nsnetservice-ip-address-and-port

@implementation NSNetService (Util)
-(NSArray* )addressArray {
    NSMutableArray* retVal = [NSMutableArray array];
    char addressBuffer[INET6_ADDRSTRLEN];

    for (NSData *data in self.addresses) {
        memset(addressBuffer, 0, INET6_ADDRSTRLEN);
        typedef union {
            struct sockaddr sa;
            struct sockaddr_in ipv4;
            struct sockaddr_in6 ipv6;
        } ip_socket_address;

        ip_socket_address *socketAddress = (ip_socket_address *)[data bytes];
        if (socketAddress && (socketAddress->sa.sa_family == AF_INET || socketAddress->sa.sa_family == AF_INET6)) {
            const char *addressStr = inet_ntop(socketAddress->sa.sa_family,
                                               (socketAddress->sa.sa_family == AF_INET ? (void *)&(socketAddress->ipv4.sin_addr) : (void *)&(socketAddress->ipv6.sin6_addr)),
                                               addressBuffer,
                                               sizeof(addressBuffer));

            int port = ntohs(socketAddress->sa.sa_family == AF_INET ? socketAddress->ipv4.sin_port : socketAddress->ipv6.sin6_port);
            if (addressStr && port) {
                [retVal addObject:@[ [NSString stringWithCString:addressStr encoding:kCFStringEncodingUTF8], @(port)]];
            }
        }
    }
    return retVal;
}

@end
