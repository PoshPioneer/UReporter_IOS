#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "LikeDetail.h"
@interface DBController : NSObject

+ (void) copyDatabaseIfNeeded;
+ (NSString *) getDBPath;

+(BOOL)insertIntoLike_Info:(LikeDetail *)pro;
+(NSMutableArray*)getAllLike_Info;
+(BOOL)updateLike_Info:(LikeDetail *)key;
+(NSArray *)getSingleLike_Info:(NSString *)key;
+(BOOL)deleteSingleRecordsof_Like_Info:(NSString *)key;

@end
    