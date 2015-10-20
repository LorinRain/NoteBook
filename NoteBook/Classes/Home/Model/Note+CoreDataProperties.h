//
//  Note+CoreDataProperties.h
//  NoteBook
//
//  Created by Lorin on 15/10/19.
//  Copyright © 2015年 Lighting-Vista. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *notedetail;

@end

NS_ASSUME_NONNULL_END
