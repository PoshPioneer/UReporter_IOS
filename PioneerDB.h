//
//  SongsDB.h
//  SongsList
//
//  Created by Arun Negi on 18/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface TOIDB : NSObject {

}

+ (void) copyDatabaseIfNeeded;
+ (NSString *) getDBPath;

+(BOOL)saveItems:(NSString *)itemName;
+ (NSMutableArray*)getAllSongs;
+ (NSMutableArray*)getAllPaidSongs;
+(BOOL)isSongExist:(NSString *)songName;
+(BOOL)isPaidSong:(NSString *)songName;
+(BOOL)deleteSong:(NSString*)songName;
@end
