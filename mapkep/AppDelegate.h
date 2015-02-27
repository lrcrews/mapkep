//
//  AppDelegate.h
//  mapkep
//
//  This is a book.
//
//  THIS IS A BOOK!!!
//
//                                 __ __ __ __
//   _____ _____ _____ _____ _____|  |  |  |  |
//  |   __|  _  |     |     |   | |  |  |  |  |
//  |__   |   __|  |  |  |  | | | |__|__|__|__|
//  |_____|__|  |_____|_____|_|___|__|__|__|__|
//
//  Created by L Ryan Crews on 1/18/14.
//  Copyright (c) 2014 lrcrews. All rights reserved.
//
//
//  Well, this isn't a book, but it is code, and that's something!
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow * window;

@property (readonly, strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel * managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator * persistentStoreCoordinator;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
