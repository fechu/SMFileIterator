/**
 @file SMFileIterator.h
 
 @author Sandro Meier <sandro.meier@fidelisfactory.ch>
 @date 10.8.2012 
 */

#import <Foundation/Foundation.h>

// Deklare the Block types
typedef void (^SMFileIteratorFoundPathBlock)(NSString *path, BOOL isFolder);
typedef void (^SMFileIteratorFinishBlock)(void);

@interface SMFileIterator : NSObject {
    NSString *path;
}

/**
 Initialize an instance with a path.
 */
- (id)initWithPath:(NSString *)path;

/**
 Starts the process.
 pathBlock will be called on every found path that matches the criterias.
 */
- (void)start;

/**
 Containing a Block that is executed on every path that matches the criterias.
 */
@property(nonatomic, strong) SMFileIteratorFoundPathBlock pathBlock;

/**
 Is called as soon as the opration finishes.
 */
@property(nonatomic, strong) SMFileIteratorFinishBlock finishBlock;

/**
 Regex to use for all paths before giving them to the pathBlock. 
 Only paths that match this regex will be forwarded to the path block.
 Default is nil.
 */
@property (nonatomic, strong) NSRegularExpression *pathRegex;

/**
 Set a file extension. Only pathes that end with this extension are returned to the pathBlock.
 Example:
    [iterator setFileExtension:@"html"];
    
    /test/help.html     TRUE
    /test/info.php      FALSE
    /test/infohtml      FALSE
    /test/status.html   TRUE
 
 This method only sets a REGEX matching the file extension.
 */
@property (nonatomic, strong) NSString *fileExtension;

@end
