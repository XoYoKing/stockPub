//
//  LookStock+CoreDataProperties.h
//  stockFront
//
//  Created by wang jam on 1/14/16.
//  Copyright © 2016 jam wang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LookStock.h"

NS_ASSUME_NONNULL_BEGIN

@interface LookStock (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *stock_code;

@end

NS_ASSUME_NONNULL_END
