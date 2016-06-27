#import "DBController.h"

@implementation DBController

+(void)displayError:(NSString*)errMsg{
	NSAssert(0,errMsg);
}

+ (void) copyDatabaseIfNeeded{
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"PioneerDB"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
	
}


+ (NSString *) getDBPath {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
    NSLog(@"Datapath=%@",documentsDir);
	return [documentsDir stringByAppendingPathComponent:@"PioneerDB"];
}



#pragma mark     Update Data from database


+(BOOL)updateLike_Info:(LikeDetail *)key
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
            
            NSLog(@"Exitsing data, Update Please");
                    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE Like set feedID ='%@',status = '%@' WHERE feedID = ?",
                                           key.feedID,
                                           key.status
                                        ];
                      //update the 'to be updated' buddies
                    const char *upd_client_tooth_sql = [updateSQL UTF8String];
                   	
            
			sqlite3_stmt *upd_client_tooth_statement;
			if (sqlite3_prepare_v2(database, upd_client_tooth_sql, -1, &upd_client_tooth_statement, NULL) != SQLITE_OK) {
				NSAssert1(0, @"Error: during prepare '%s'.", sqlite3_errmsg(database));
			}
			
			sqlite3_bind_text(upd_client_tooth_statement, 1,[key.feedID UTF8String],-1,SQLITE_TRANSIENT);
   			
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



#pragma mark     Showing Data from database

+(NSArray *)getSingleLike_Info:(NSString *)key

{
    
    NSMutableArray *p_info = [[NSMutableArray alloc] init];
    
    sqlite3 *database;
	
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK)
        {
		
		const char *enableForeignKeySQL="PRAGMA foreign_keys = ON";
		if(sqlite3_exec(database, enableForeignKeySQL, NULL, NULL, NULL)==SQLITE_OK)
            {
                //NSLog(@"foreign key enabled");
			
			sqlite3_stmt *statement;
			

    
    
    if (sqlite3_prepare_v2(database, "SELECT feedID,status from Like where feedID= ?", -1, &statement, NULL) == SQLITE_OK ) {
        sqlite3_bind_text(statement, 1,[key UTF8String],-1,SQLITE_TRANSIENT);
        if (sqlite3_step(statement) == SQLITE_ROW)  {
            LikeDetail  *info = [[LikeDetail alloc] init];
            
                // The second parameter is the column index (0 based) in
                // the result set.
            
            char *feedID = (char *)sqlite3_column_text(statement, 0);
            char *status = (char *)sqlite3_column_text(statement, 1);
           
            
                // Set all the attributes of the Entity
            
            info.feedID = (feedID) ? [NSString stringWithUTF8String:feedID] : @"";
            
            info.status = (status) ? [NSString stringWithUTF8String:status] : @"";
            
            
                // Add the entity to the products array
            [p_info addObject:info];
            
            
        }
        
            // Finalize the statement
        sqlite3_finalize(statement);
    }

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
	return p_info;
}

/*
+(NSMutableArray*)getAllUser_Info{
    NSMutableArray *p_info = [[NSMutableArray alloc] init];
    
    sqlite3 *database;
	
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK)
        {
		
		const char *enableForeignKeySQL="PRAGMA foreign_keys = ON";
		if(sqlite3_exec(database, enableForeignKeySQL, NULL, NULL, NULL)==SQLITE_OK)
            {
                //NSLog(@"foreign key enabled");
			
			sqlite3_stmt *statement;
			
			
            const char *sql;
            
                // The array of products that we will create
            
            
            
            sql = "SELECT userId,accessToken,address,badgeCount,city,email,goal,goalId,groupId,groupName,name,nextRoundTableDate,phone,profileImage,roundTableId,state,userBio,userType,zipCode,goalBenifits,currentRoundTableDate,nextRoundTableId from UserDetails";
            
            
            
            
			if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK)
				NSAssert1(0, @"Error while creating getUserWithUsername statement. '%s'", sqlite3_errmsg(database));
			
			
			while(sqlite3_step(statement)==SQLITE_ROW)
                {
              UserDetail  *info = [[UserDetail alloc] init];
                
                    // The second parameter is the column index (0 based) in
                    // the result set.
                
                char *userId = (char *)sqlite3_column_text(statement, 0);
                char *accessToken = (char *)sqlite3_column_text(statement, 1);
                char *address = (char *)sqlite3_column_text(statement, 2);
                char *badgeCount = (char *)sqlite3_column_text(statement, 3);
                char *city = (char *)sqlite3_column_text(statement, 4);
                char *email = (char *)sqlite3_column_text(statement, 5);
                char *goal = (char *)sqlite3_column_text(statement, 6);
                char *goalId = (char *)sqlite3_column_text(statement, 7);
                char *groupId = (char *)sqlite3_column_text(statement, 8);
                char *groupName = (char *)sqlite3_column_text(statement, 9);
                char *name = (char *)sqlite3_column_text(statement, 10);
                char *nextRoundTableDate = (char *)sqlite3_column_text(statement, 11);
                char *phone = (char *)sqlite3_column_text(statement, 12);
                char *profileImage = (char *)sqlite3_column_text(statement, 13);
                char *roundTableId = (char *)sqlite3_column_text(statement, 14);
                char *state = (char *)sqlite3_column_text(statement, 15);
                char *userBio = (char *)sqlite3_column_text(statement, 16);
                char *userType = (char *)sqlite3_column_text(statement, 17);
                char *zipCode = (char *)sqlite3_column_text(statement, 18);
                char *goalBenifits = (char *)sqlite3_column_text(statement, 19);
                char *currentRoundTableDate = (char *)sqlite3_column_text(statement, 20);
                char *nextRoundTableId = (char *)sqlite3_column_text(statement, 21);
                
                // Set all the attributes of the Entity
                
                info.userId = (userId) ? [NSString stringWithUTF8String:userId] : @"";
                
                info.accessToken = (accessToken) ? [NSString stringWithUTF8String:accessToken] : @"";
                
                info.address = (address) ? [NSString stringWithUTF8String:address] : @"";
                
                info.badgeCount = (badgeCount) ? [NSString stringWithUTF8String:badgeCount] : @"";
                
                info.city = (city) ? [NSString stringWithUTF8String:city] : @"";
                
                info.email = (email) ? [NSString stringWithUTF8String:email] : @"";
                
                info.goal = (goal) ? [NSString stringWithUTF8String:goal] : @"";
                
                info.goalId = (goalId) ? [NSString stringWithUTF8String:goalId] : @"";
                
                info.groupId = (groupId) ? [NSString stringWithUTF8String:groupId] : @"";
                
                info.groupName = (groupName) ? [NSString stringWithUTF8String:groupName] : @"";
                
                info.name = (name) ? [NSString stringWithUTF8String:name] : @"";
                
                info.nextRoundTableDate = (nextRoundTableDate) ? [NSString stringWithUTF8String:nextRoundTableDate] : @"";
                
                info.phone = (phone) ? [NSString stringWithUTF8String:phone] : @"";
                
                info.profileImage = (profileImage) ? [NSString stringWithUTF8String:profileImage] : @"";
                
                info.roundTableId = (roundTableId) ? [NSString stringWithUTF8String:roundTableId] : @"";
                
                info.state = (state) ? [NSString stringWithUTF8String:state] : @"";
                
                info.userBio = (userBio) ? [NSString stringWithUTF8String:userBio] : @"";
                
                info.userType = (userType) ? [NSString stringWithUTF8String:userType] : @"";
                
                info.zipCode = (zipCode) ? [NSString stringWithUTF8String:zipCode] : @"";
                
                info.goalBenifits = (goalBenifits) ? [NSString stringWithUTF8String:goalBenifits] : @"";
                
                info.currentRoundTableDate = (currentRoundTableDate) ? [NSString stringWithUTF8String:currentRoundTableDate] : @"";
                
                info.nextRoundTableId = (nextRoundTableId) ? [NSString stringWithUTF8String:nextRoundTableId] : @"";

                    // Add the entity to the products array
                [p_info addObject:info];
                
                
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
	return p_info;
}
*/
#pragma mark - insert Data from database

+(BOOL)insertIntoLike_Info:(LikeDetail *)pro{
    
    
	BOOL userSaved=NO;
	NSLog(@"%@",pro.feedID);
    
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
                
            const char *sql;
            
            sql = "insert into Like(feedID,status) values (?,?)";
            
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: during prepare '%s'.", sqlite3_errmsg(database));
            }
            

            
            sqlite3_bind_text(statement, 1, [pro.feedID UTF8String],-1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [pro.status UTF8String],-1,SQLITE_TRANSIENT);
                
            
            
            
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
    
	
	return userSaved;
}

#pragma mark - get Data from database

+(NSMutableArray*)getAllLike_Info
{
    NSMutableArray *p_info = [[NSMutableArray alloc] init];
    
    sqlite3 *database;
	
	if(sqlite3_open([[self getDBPath] UTF8String], &database) == SQLITE_OK)
        {
		
		const char *enableForeignKeySQL="PRAGMA foreign_keys = ON";
		if(sqlite3_exec(database, enableForeignKeySQL, NULL, NULL, NULL)==SQLITE_OK)
            {
                //NSLog(@"foreign key enabled");
			
			sqlite3_stmt *statement;
			
			
            const char *sql;
            
                // The array of products that we will create
            
            
            sql = "SELECT * from Like";
            
			if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK)
				NSAssert1(0, @"Error while creating getUserWithUsername statement. '%s'", sqlite3_errmsg(database));
			
			
			while(sqlite3_step(statement)==SQLITE_ROW)
                {
                    
                LikeDetail  *info = [[LikeDetail alloc] init];
                
                    // The second parameter is the column index (0 based) in
                    // the result set.
                
                char *feedID = (char *)sqlite3_column_text(statement, 0);
                char *status = (char *)sqlite3_column_text(statement, 1);
              
                
                // Set all the attributes of the Entity
                
                info.feedID = (feedID) ? [NSString stringWithUTF8String:feedID] : @"";
                
                info.status = (status) ? [NSString stringWithUTF8String:status] : @"";
                
                // Add the entity to the products array
                    
                [p_info addObject:info];
                
                
                }
			
			sqlite3_finalize(statement);
 	
			
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
	return p_info;
 
}

#pragma mark - update Data from database
/*
+(BOOL)updateEvalution_Info:(EvalutionForm *)key
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
            
            NSLog(@"Exitsing data, Update Please");
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE EvalutionForm set accessToken ='%@',ansToQuest1 = '%@',ansToQuest2 = '%@',ansToQuest3 = '%@',ansToQuest4 = '%@',ansToQuest5 = '%@',ansToQuest6 = '%@',groupId = '%@',roundTableId = '%@'  WHERE userId = ?",
                                   key.accessToken,
                                   key.ansToQuest1,
                                   key.ansToQuest2,
                                   key.ansToQuest3,
                                   key.ansToQuest4,
                                   key.ansToQuest5,
                                   key.ansToQuest6,
                                   key.groupId,
                                   key.roundTableEventId
                                   ];
                //update the 'to be updated' buddies
            const char *upd_client_tooth_sql = [updateSQL UTF8String];
            
            
			sqlite3_stmt *upd_client_tooth_statement;
			if (sqlite3_prepare_v2(database, upd_client_tooth_sql, -1, &upd_client_tooth_statement, NULL) != SQLITE_OK) {
				NSAssert1(0, @"Error: during prepare '%s'.", sqlite3_errmsg(database));
			}
			
			sqlite3_bind_text(upd_client_tooth_statement, 1,[key.userId UTF8String],-1,SQLITE_TRANSIENT);
   			
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

#pragma mark - delete Data from database


+(BOOL)deleteSingleRecordsof_Like_Info:(NSString *)key
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
			
			
            NSLog(@"Exitsing data, Update Please");
            NSString *deleteSQL = @"delete from Like WHERE feedID = ?";
                                  
                //update the 'to be updated' buddies
            const char *upd_client_tooth_sql = [deleteSQL UTF8String];
            
    
			
			sqlite3_stmt *upd_client_tooth_statement;
			if (sqlite3_prepare_v2(database, upd_client_tooth_sql, -1, &upd_client_tooth_statement, NULL) != SQLITE_OK) {
				NSAssert1(0, @"Error: during prepare '%s'.", sqlite3_errmsg(database));
			}
			
            sqlite3_bind_text(upd_client_tooth_statement, 1,[key UTF8String],-1,SQLITE_TRANSIENT);

			
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



@end