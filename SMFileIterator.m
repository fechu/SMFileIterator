/**
 @file SMFileIterator.m
 
 @author Sandro Meier <sandro.meier@fidelisfactory.ch>
 @date 10.8.2012 
 */

#import "SMFileIterator.h"

@interface SMFileIterator ()
/**
 This method should be used to pass a path to the pathBlock. 
 In this method all the regex checking is done.
 */
- (void)publishPath:(NSString *)path isFolder:(BOOL)folder;

/**
 Iterates over a folder
*/
- (void)iterateFolderAtPath:(NSString *)path;
@end

@implementation SMFileIterator

@synthesize pathBlock;
@synthesize finishBlock;
@synthesize pathRegex;
@synthesize fileExtension;

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
    
    // Check if we have a path block
    if (!self.pathBlock) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"No pathBlock was set but iteration was started." userInfo:nil] raise];
    }
    
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
            [self publishPath:path isFolder:isDirectory];
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

#pragma mark - Private Methods

- (void)publishPath:(NSString *)aPath isFolder:(BOOL)folder
{
    // Check regex.
    if (self.pathRegex) {
        NSRange range = [self.pathRegex rangeOfFirstMatchInString:path options:0 range:NSMakeRange(0, path.length)];
        if (range.location == NSNotFound) {
            // path does not match regex.
            return;
        }
    } else {
        // Call the block
        self.pathBlock(aPath, folder);
    }
}

- (void)iterateFolderAtPath:(NSString *)aPath
{
    // It's a folder so we report the folder.
    [self publishPath:aPath isFolder:true];
    
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
                [self publishPath:fullPath isFolder:false];
            }
        }
    }
}

#pragma mark - Custom Setter

- (void)setFileExtension:(NSString *)extension
{
    // Set the correct regex that matches the extension.
    NSString *pattern = [NSString stringWithFormat:@"^.*\\.%@$", extension];
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                         options:NSRegularExpressionCaseInsensitive error:NULL];
    self.pathRegex = exp;
}

@end
