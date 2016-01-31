//
//  LocDatabase.m
//  CarSocial
//
//  Created by wang jam on 9/26/14.
//  Copyright (c) 2014 jam wang. All rights reserved.
//

#import "LocDatabase.h"
#import <CoreData/CoreData.h>

#import "macro.h"


@implementation LocDatabase
{
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *psc;
    NSPersistentStore *store;
    NSManagedObjectContext *context;
}

- (BOOL)connectToDatabase:(NSString*)fileName
{
    model = [NSManagedObjectModel mergedModelFromBundles:nil];
    //NSManagedObjectModel* model = [[NSManagedObjectModel alloc] init];

    // 传入模型对象，初始化NSPersistentStoreCoordinator
    psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    // 构建SQLite数据库文件的路径
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:fileName]];
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) { // 直接抛异常
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
        return false;
    }
    // 初始化上下文，设置persistentStoreCoordinator属性
    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = psc;

    return YES;
}

- (BOOL)addStock:(StockInfoModel*)stockmodel
{
    NSLog(@"addStock");
    
    if(![self deleteStock:stockmodel]){
        return false;
    }
    
    NSError* error;
    MyStock* msg = [NSEntityDescription insertNewObjectForEntityForName:@"MyStock" inManagedObjectContext:context];
    msg.stock_code = stockmodel.stock_code;
    msg.timestamp = [[NSDate date] timeIntervalSince1970];
    
    
    if (![context save:&error]) {
        NSLog(@"Error %@", [error localizedDescription]);
        return FALSE;
    }
    
    return TRUE;

}

- (BOOL)deleteStock:(StockInfoModel*)stockmodel
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"MyStock" inManagedObjectContext:context]];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:[[NSString alloc] initWithFormat:@"stock_code = '%@'",stockmodel.stock_code]];
    
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor* sortDesc = [[NSSortDescriptor alloc] initWithKey:@"stock_code" ascending:NO];
    NSArray* desc = [NSArray arrayWithObject:sortDesc];
    [fetchRequest setSortDescriptors:desc];
    
    NSFetchedResultsController* fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"Root"];
    
    NSError* error;
    if (![fetchController performFetch:&error]) {
        NSLog(@"Error %@", [error localizedDescription]);
        return FALSE;
    }
    
    for (MyStock* msg in fetchController.fetchedObjects) {
        [context deleteObject:msg];
    }
    
    if (![context save:&error]) {
        NSLog(@"Error %@", [error localizedDescription]);
        return FALSE;
    }
    return true;

}

- (NSMutableArray*)getStocklist
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"MyStock" inManagedObjectContext:context]];
    
    
    
    NSSortDescriptor* sortDesc = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    NSArray* desc = [NSArray arrayWithObject:sortDesc];
    [fetchRequest setSortDescriptors:desc];
    
    NSFetchedResultsController* fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"Root"];
    
    NSError* error;
    if (![fetchController performFetch:&error]) {
        NSLog(@"Error %@", [error localizedDescription]);
        return FALSE;
    }
    
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (MyStock* msg in fetchController.fetchedObjects) {
        StockInfoModel* stockModel = [[StockInfoModel alloc] init];
        stockModel.stock_code = msg.stock_code;
        
        [result addObject:stockModel];
    }
    return result;

}


- (BOOL)addLookStock:(StockInfoModel*)stockmodel
{
    NSLog(@"addStock");
    
    if(![self deleteLookStock:stockmodel]){
        return false;
    }
    
    NSError* error;
    LookStock* msg = [NSEntityDescription insertNewObjectForEntityForName:@"LookStock" inManagedObjectContext:context];
    msg.stock_code = stockmodel.stock_code;
    
    
    if (![context save:&error]) {
        NSLog(@"Error %@", [error localizedDescription]);
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)deleteLookStock:(StockInfoModel*)stockmodel
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"LookStock" inManagedObjectContext:context]];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:[[NSString alloc] initWithFormat:@"stock_code = '%@'",stockmodel.stock_code]];
    
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor* sortDesc = [[NSSortDescriptor alloc] initWithKey:@"stock_code" ascending:NO];
    NSArray* desc = [NSArray arrayWithObject:sortDesc];
    [fetchRequest setSortDescriptors:desc];
    
    NSFetchedResultsController* fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"Root"];
    
    NSError* error;
    if (![fetchController performFetch:&error]) {
        NSLog(@"Error %@", [error localizedDescription]);
        return FALSE;
    }
    
    for (LookStock* msg in fetchController.fetchedObjects) {
        [context deleteObject:msg];
    }
    
    if (![context save:&error]) {
        NSLog(@"Error %@", [error localizedDescription]);
        return FALSE;
    }
    return true;
}

- (BOOL)isLookStock:(StockInfoModel*)stockmodel
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"LookStock" inManagedObjectContext:context]];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:[[NSString alloc] initWithFormat:@"stock_code = '%@'",stockmodel.stock_code]];
    
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor* sortDesc = [[NSSortDescriptor alloc] initWithKey:@"stock_code" ascending:NO];
    NSArray* desc = [NSArray arrayWithObject:sortDesc];
    [fetchRequest setSortDescriptors:desc];
    
    NSFetchedResultsController* fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"Root"];
    
    NSError* error;
    if (![fetchController performFetch:&error]) {
        NSLog(@"Error %@", [error localizedDescription]);
        return FALSE;
    }
    
    if([fetchController.fetchedObjects count]>0){
        return true;
    }else{
        return false;
    }
}

- (BOOL)addFollow:(UserInfoModel*)userModel
{
    NSLog(@"addStock");
    
    if(![self delFollow:userModel]){
        return false;
    }
    
    NSError* error;
    FollowUser* msg = [NSEntityDescription insertNewObjectForEntityForName:@"FollowUser" inManagedObjectContext:context];
    msg.user_id = userModel.user_id;
    
    
    if (![context save:&error]) {
        NSLog(@"Error %@", [error localizedDescription]);
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)delFollow:(UserInfoModel*)userModel
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"FollowUser" inManagedObjectContext:context]];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:[[NSString alloc] initWithFormat:@"user_id = '%@'",userModel.user_id]];
    
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor* sortDesc = [[NSSortDescriptor alloc] initWithKey:@"user_id" ascending:NO];
    NSArray* desc = [NSArray arrayWithObject:sortDesc];
    [fetchRequest setSortDescriptors:desc];
    
    NSFetchedResultsController* fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"Root"];
    
    NSError* error;
    if (![fetchController performFetch:&error]) {
        NSLog(@"Error %@", [error localizedDescription]);
        return FALSE;
    }
    
    for (FollowUser* msg in fetchController.fetchedObjects) {
        [context deleteObject:msg];
    }
    
    if (![context save:&error]) {
        NSLog(@"Error %@", [error localizedDescription]);
        return FALSE;
    }
    return true;
}

- (BOOL)isFollow:(UserInfoModel*)userModel
{
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"FollowUser" inManagedObjectContext:context]];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:[[NSString alloc] initWithFormat:@"user_id = '%@'",userModel.user_id]];
    
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor* sortDesc = [[NSSortDescriptor alloc] initWithKey:@"user_id" ascending:NO];
    NSArray* desc = [NSArray arrayWithObject:sortDesc];
    [fetchRequest setSortDescriptors:desc];
    
    NSFetchedResultsController* fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"Root"];
    
    NSError* error;
    if (![fetchController performFetch:&error]) {
        NSLog(@"Error %@", [error localizedDescription]);
        return FALSE;
    }
    
    if([fetchController.fetchedObjects count]>0){
        return true;
    }else{
        return false;
    }
}


@end
