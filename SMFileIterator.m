/**
 @file SMFileIterator.m
 
 @author Sandro Meier <sandro.meier@fidelisfactory.ch>
 @date 10.8.2012 
 */

#import "SMFileIterator.h"

@interface SMFileIterator ()
- (void)iterateFolderAtPath:(NSString *)path;
@end

@implementation SMFileIterator

@synthesize pathBlock;
@synthesize finishBlock;

- (id)initWithPath:(NSString *)aPath
{
    self = [super init];
    if (self) {
        if (aPath) {
            path = aPath;
        }
        else {
           // Throw an exception
            [[NSException exceptionWithName:NSInvalidArgumentException reason:@"The path cannot not be nil." userInfo:nil] raise];
        }
    }
    return self;
}

- (void)start
{
    // Start iterating
    BOOL isDirectory = false;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
        // The Path exists.
        if (isDirectory) {
            // continue with the contents.
            [self iterateFolderAtPath:path];
        }
        else {
            // It's not a directory. So just call the block.
            pathBlock(path, isDirectory);
        }
    }
    else {
        // Raise an exception because the path didn't exist.
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"The file or folder at the given path does not exist." userInfo:nil] raise];
    }
    
    // Finished...
    if (self.finishBlock) {
        self.finishBlock();
    }
}

- (void)iterateFolderAtPath:(NSString *)aPath
{
    // It's a folder so we report the folder.
    pathBlock(aPath, true);
    
    NSError *error = nil;
    NSArray *folderContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:aPath error:&error];
    
    if (error) {
        // It failed to read the directory contents of a folder...
        
    }
    
    for (NSString *fileName in folderContents) {
        BOOL isDirectory;
        NSString *fullPath = [aPath stringByAppendingPathComponent:fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDirectory]) {
            if (isDirectory) {
                // Go on with the hirarchy
                [self iterateFolderAtPath:fullPath];
            }
            else {
                // Just execute the block and go on...
                pathBlock(fullPath, false);
            }
        }
    }
}

@end
