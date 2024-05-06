//
//  NSData+Brotli.h
//  Brotli
//
//  Created by Karl von Randow on 30/03/18.
//

#include <Foundation/Foundation.h>

@interface NSData (Brotli)

- (nullable NSData *)tj_brotliCompressed; // Always level 11 (highest)
- (nullable NSData *)tj_brotliDecompressed;

@end
