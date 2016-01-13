//
//  MyStock+CoreDataProperties.h
//  stockFront
//
//  Created by wang jam on 1/13/16.
//  Copyright © 2016 jam wang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MyStock.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyStock (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *stock_code;
@property (nullable, nonatomic, retain) NSInteger timestamp;


@end

NS_ASSUME_NONNULL_END
