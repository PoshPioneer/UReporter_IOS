//
//  SongsDB.m
//  SongsList
//
//  Created by Arun Negi on 18/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TOIDB.h"


@implementation TOIDB


+(void)displayError:(NSString*)errMsg
{
	NSAssert(0,errMsg);
}

+ (void) copyDatabaseIfNeeded {	
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"TOI_DB"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
	
}


+ (NSString *) getDBPath {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"TOI_DB"];
}

+(BOOL)saveItems:(NSDictionary *)dic
{
    
    /*
	BOOL userSaved=NO;	
	BOOL existsSong=NO;
	
	for(NSString *existsSongName in [self getAllSongs])
	{
		if([existsSongName isEqualToString:songName])
		{
			existsSong=YES;
			userSaved=YES;
			break;
		}
	}

	*/
    
//	if(songName && !existsSong)
//	{
		
		sqlite3 *database;
		
		if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) 
		{
			
			const char *enableForeignKeySQL="PRAGMA foreign_keys = ON";
			if(sqlite3_exec(database, enableForeignKeySQL, NULL, NULL, NULL)==SQLITE_OK)
			{
				//NSLog(@"foreign key enabled");
				
				
				
				//BEGIN EXCLUSIVE TRANSACTION
				
				const char *sql1 = "BEGIN EXCLUSIVE TRANSACTION";
				sqlite3_stmt *begin_statement;
				if (sqlite3_prepare_v2(database, sql1, -1, &begin_statement, NULL) != SQLITE_OK)
				{
					[self displayError:[NSString stringWithFormat: @"Error14: failed to prepare statement with message '%s'.", sqlite3_errmsg(database)]];
				}
				// Execute the query.
				int success = sqlite3_step(begin_statement);
				// Handle errors.
				if (success != SQLITE_DONE) 
				{
					[self displayError:[NSString stringWithFormat: @"Error15: failed to insert with message '%s'.", sqlite3_errmsg(database)]];
				}
				sqlite3_finalize(begin_statement);
				
				
				
				//Save New Questions To The Database
				const char *sql = "insert into Songs(SongName) values (?)";
				sqlite3_stmt *statement;
				if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
					NSAssert1(0, @"Error: during prepare '%s'.", sqlite3_errmsg(database));
				}
				
				
				
				sqlite3_bind_text(statement, 1, [songName UTF8String],-1,SQLITE_TRANSIENT);
				
				
				success = sqlite3_step(statement);
				
				if (success != SQLITE_DONE) 
				{
					NSAssert1(0, @"Error: during exec '%s'.", sqlite3_errmsg(database));
				}
				sqlite3_finalize(statement);
				
				
				
				//COMMIT EXCLUSIVE TRANSACTION
				
				const char *sql2 = "COMMIT TRANSACTION"; 
				sqlite3_stmt *commit_statement; 
				if (sqlite3_prepare_v2(database, sql2, -1, &commit_statement, NULL) != SQLITE_OK)
				{
					[self displayError:[NSString stringWithFormat: @"Error16: failed to prepare statement with message '%s'.", sqlite3_errmsg(database)]];
				}
				// Execute the query.
				int success1 = sqlite3_step(commit_statement);
				// Handle errors.
				if (success1 != SQLITE_DONE) 
				{
					[self displayError:[NSString stringWithFormat: @"Error17: failed to insert with message '%s'.", sqlite3_errmsg(database)]];
				}
				else {
					//flag it that there are no new questions to be saved
					userSaved=YES;
				}
				sqlite3_finalize(commit_statement);
			}
			else 
			{
				//NSLog(@"foreign key not enabled");
			}
			
			sqlite3_close(database);
			//NSLog(@"sqlite3_close executed");
		}
		else 
		{
			sqlite3_close(database);
			//NSLog(@"sqlite3_close executed");
			
		}
		
	//}
	return userSaved;
}


/*

+ (NSMutableArray*)getAllSongs
{
	NSMutableArray *DaysArray=[[[NSMutableArray alloc]init]autorelease];
	
    sqlite3 *database;
	
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) 
	{
		
		const char *enableForeignKeySQL="PRAGMA foreign_keys = ON";
		if(sqlite3_exec(database, enableForeignKeySQL, NULL, NULL, NULL)==SQLITE_OK)
		{
			//NSLog(@"foreign key enabled");
			
			sqlite3_stmt *statement;
			
			
			const char *sql = "select * from Songs";
			
			
			if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK)
				NSAssert1(0, @"Error while creating getUserWithUsername statement. '%s'", sqlite3_errmsg(database));
			
			
			NSString *songName=nil;
			while(sqlite3_step(statement)==SQLITE_ROW) 
			{
				 songName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				
				
				
				[DaysArray addObject:songName];
			}
			
			sqlite3_finalize(statement);
			//NSLog(@"sqlite3_finalize executed");
			
			
			
			
		}
		else 
		{
			//NSLog(@"foreign key not enabled");
		}
		
		sqlite3_close(database);
		//NSLog(@"sqlite3_close executed");
	}
	else 
	{
		sqlite3_close(database);
		//NSLog(@"sqlite3_close executed");
		
	}	
	return DaysArray;
}


+ (NSMutableArray*)getAllPaidSongs
{
	NSMutableArray *DaysArray=[[[NSMutableArray alloc]init]autorelease];
	
    sqlite3 *database;
	
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) 
	{
		
		const char *enableForeignKeySQL="PRAGMA foreign_keys = ON";
		if(sqlite3_exec(database, enableForeignKeySQL, NULL, NULL, NULL)==SQLITE_OK)
		{
			//NSLog(@"foreign key enabled");
			
			sqlite3_stmt *statement;
			
			
			const char *sql = "select * from PaidSongs";
			
			
			if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK)
				NSAssert1(0, @"Error while creating getUserWithUsername statement. '%s'", sqlite3_errmsg(database));
			
			
			NSString *songName=nil;
			while(sqlite3_step(statement)==SQLITE_ROW) 
			{
                songName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];

				
				
				
				[DaysArray addObject:songName];
			}
			
			sqlite3_finalize(statement);
			//NSLog(@"sqlite3_finalize executed");
			
			
			
			
		}
		else 
		{
			//NSLog(@"foreign key not enabled");
		}
		
		sqlite3_close(database);
		//NSLog(@"sqlite3_close executed");
	}
	else 
	{
		sqlite3_close(database);
		//NSLog(@"sqlite3_close executed");
		
	}	
	return DaysArray;
}

+(BOOL)isSongExist:(NSString *)songName
{
    BOOL isSongExist=NO;
    
    NSMutableArray *getAllSong=[self getAllSongs];
    for(NSString *str in getAllSong)
    {
        NSArray *array=[str componentsSeparatedByString:@"."];
        
        if([array count]!=0)
        {
            if([[array objectAtIndex:0] isEqualToString:songName])
            {
                isSongExist=YES;
                break;
            }
        }
        
    }
    
    return isSongExist;
}


+(BOOL)isPaidSong:(NSString *)songName
{
    BOOL isSongExist=NO;
    
    NSMutableArray *getAllSong=[self getAllPaidSongs];
    for(NSString *str in getAllSong)
    {
        NSArray *array=[str componentsSeparatedByString:@"."];
        
        if([array count]!=0)
        {
            if([[array objectAtIndex:0] isEqualToString:songName])
            {
                isSongExist=YES;
                break;
            }
        }
        
    }
    
    return isSongExist;
}




+(BOOL)deleteSong:(NSString*)songName
{
	sqlite3 *database;	
	BOOL songDeletedSuccessfully=NO;
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK) 
	{
		
		const char *enableForeignKeySQL="PRAGMA foreign_keys = ON";
		if(sqlite3_exec(database, enableForeignKeySQL, NULL, NULL, NULL)==SQLITE_OK)
		{
			//NSLog(@"foreign key enabled");
			
            
			//BEGIN EXCLUSIVE TRANSACTION
			
			const char *sql1 = "BEGIN EXCLUSIVE TRANSACTION";
			sqlite3_stmt *begin_statement;
			if (sqlite3_prepare_v2(database, sql1, -1, &begin_statement, NULL) != SQLITE_OK)
			{
				[self displayError:[NSString stringWithFormat: @"Error14: failed to prepare statement with message '%s'.", sqlite3_errmsg(database)]];
			}
			// Execute the query.
			int success = sqlite3_step(begin_statement);
			// Handle errors.
			if (success != SQLITE_DONE) 
			{
				[self displayError:[NSString stringWithFormat: @"Error15: failed to insert with message '%s'.", sqlite3_errmsg(database)]];
			}
			sqlite3_finalize(begin_statement);
			
			
			
			//update the 'to be updated' buddies
			const char *upd_client_tooth_sql = "delete from PaidSongs where SongName=?";
			
			sqlite3_stmt *upd_client_tooth_statement;
			if (sqlite3_prepare_v2(database, upd_client_tooth_sql, -1, &upd_client_tooth_statement, NULL) != SQLITE_OK) {
				NSAssert1(0, @"Error: during prepare '%s'.", sqlite3_errmsg(database));
			}		
			
			sqlite3_bind_text(upd_client_tooth_statement, 1, [songName UTF8String],-1,SQLITE_TRANSIENT);
            
			
			success = sqlite3_step(upd_client_tooth_statement);
			
			sqlite3_reset(upd_client_tooth_statement);
			if (success != SQLITE_DONE) 
			{
				NSAssert1(0, @"Error: during exec '%s'.", sqlite3_errmsg(database));
			}			
			
			
			sqlite3_finalize(upd_client_tooth_statement);
			//NSLog(@"sqlite3_finalize executed");	
			
			
			
            //COMMIT EXCLUSIVE TRANSACTION
			
			const char *sql2 = "COMMIT TRANSACTION"; 
			sqlite3_stmt *commit_statement; 
			if (sqlite3_prepare_v2(database, sql2, -1, &commit_statement, NULL) != SQLITE_OK)
			{
				[self displayError:[NSString stringWithFormat: @"Error16: failed to prepare statement with message '%s'.", sqlite3_errmsg(database)]];
			}
			// Execute the query.
			int success1 = sqlite3_step(commit_statement);
			// Handle errors.
			if (success1 != SQLITE_DONE) 
			{
				[self displayError:[NSString stringWithFormat: @"Error17: failed to insert with message '%s'.", sqlite3_errmsg(database)]];
			}
			else 
			{
				songDeletedSuccessfully=YES;
			}
			sqlite3_finalize(commit_statement);
			
			
		}
		else 
		{
			//NSLog(@"foreign key not enabled");
		}
		
		sqlite3_close(database);
		//NSLog(@"sqlite3_close executed");
	}
	else 
	{
		sqlite3_close(database);
		//NSLog(@"sqlite3_close executed");
		
	}	
	
	return songDeletedSuccessfully;
}
*/



@end
