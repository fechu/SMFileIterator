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


@end
