//
//  TestDocument.m
//  TreeTest
//
//  Created by Andreas Monitzer on 2011-07-03.
//  Copyright 2011 Andreas Monitzer. All rights reserved.
//

#import "TestDocument.h"

@implementation TestDocument {
	NSManagedObject *rootObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"TestDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSManagedObject*)rootObject {
	if(!rootObject) {
		NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Folder"];
		[req setPredicate:[NSPredicate predicateWithFormat:@"parent = nil"]];
		NSError *error;
		NSArray *result = [self.managedObjectContext executeFetchRequest:req error:&error];
		if(!result) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[NSApp presentError:error];
				// ### close document?
			});
		}
		if([result count] == 0) {
			rootObject = [NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:self.managedObjectContext]; // create new root item
		} else
			rootObject = [result lastObject];
	}
	return rootObject;
}

- (IBAction)muh:(id)sender {
    NSMutableOrderedSet *children = [[self rootObject] mutableOrderedSetValueForKey:@"children"];
    NSManagedObject *first = [NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:self.managedObjectContext];
    [first setValue:@"my first folder" forKey:@"name"];
    [children addObject:first];
    NSManagedObject *page = [NSEntityDescription insertNewObjectForEntityForName:@"Page" inManagedObjectContext:self.managedObjectContext];
    [page setValue:@"my second page" forKey:@"name"];
    [children addObject:page];
}

- (IBAction)meh:(id)sender {
    NSLog(@"%@", [[self rootObject] valueForKeyPath:@"children.name"]);
}

@end
