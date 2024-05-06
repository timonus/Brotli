//
//  NSData+Brotli.m
//  Brotli
//
//  Created by Karl von Randow on 30/03/18.
//

#import "NSData+TJBrotli.h"

#import "encode.h"

@implementation NSData (Brotli)

- (NSData *)tj_brotliCompressed {
    const size_t maxCompressedSize = BrotliEncoderMaxCompressedSize(self.length);
    uint8_t* compressedBuffer = (uint8_t*) malloc(maxCompressedSize * sizeof(uint8_t));

    size_t compressedSize = maxCompressedSize;

    if (!BrotliEncoderCompress(BROTLI_DEFAULT_QUALITY,
                               BROTLI_DEFAULT_WINDOW,
                               BROTLI_MODE_GENERIC,
                               (size_t) self.length,
                               (uint8_t *) self.bytes,
                               &compressedSize,
                               compressedBuffer)) {
        return nil;
    }

    /* Make a decision about whether to reuse our existing buffer without copying the data, or
       to make a new buffer.
     */
    if (compressedSize < maxCompressedSize * 0.8 && maxCompressedSize > 8192) {
        /* If the result is less than 80% of the buffer, and the buffer is bigger than 8KB,
           then let's copy and free that extra space as the wasted space is > 1.6 KB.
           Arbitrary numbers.
         */
        NSData *result = [NSData dataWithBytes:compressedBuffer length:compressedSize];
        free(compressedBuffer);
        return result;
    } else {
        return [NSData dataWithBytesNoCopy:compressedBuffer length:compressedSize freeWhenDone:YES];
    }
}

- (NSData *)tj_brotliDecompressed {
    // Undocumented trick
    return [self decompressedDataUsingAlgorithm:NSDataCompressionAlgorithmZlib + 1 error:nil];
}

@end
