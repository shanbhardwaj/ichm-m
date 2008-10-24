//
//  FileManagerController.m
//  iChm
//
//  Created by Robin Lu on 10/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FileManagerController.h"
#import "HTTPServer.h"

@interface FileManagerController (Private)
- (NSString*)setupDocroot;

@end


@implementation FileManagerController

- (id)init {
	[self initWithNibName:@"FileManager" bundle:nil];
	NSString * docroot = [self setupDocroot];

	httpServer = [[HTTPServer alloc] init];
	[httpServer setType:@"_http._tcp."];
	
#ifndef TARGET_IPHONE_SIMULATOR
	[httpServer setPort:80];
#endif
	[httpServer setName:@"iChm"];
	[httpServer setDocumentRoot:[NSURL fileURLWithPath:docroot]];
	
	NSError *error;
	BOOL success = [httpServer start:&error];
	
	if(!success)
	{
		NSLog(@"Error starting HTTP Server: %@", error);
	}
	return self;
}

- (NSString*)setupDocroot
{
	NSString* docroot =[NSString stringWithFormat:@"%@/docroot", [[NSBundle mainBundle] sharedSupportPath]];
	NSLog(docroot);
	NSFileManager *manager = [NSFileManager defaultManager];
	NSError *error;
	if(![manager removeItemAtPath:docroot error:&error])
	{
		NSLog([NSString stringWithFormat:@"Can not remove old docroot: %@", error ]);
	}
	
	NSArray * localizations = [[NSBundle mainBundle] preferredLocalizations];
	NSString *localizedName = [localizations objectAtIndex:0];
	NSString* localizedDocroot = [NSString stringWithFormat:@"%@/localized_docroot/%@.lproj", 
								  [[NSBundle mainBundle] sharedSupportPath],
								  localizedName];
	if (![manager createSymbolicLinkAtPath:docroot pathContent: localizedDocroot])
	{
		NSLog([NSString stringWithFormat:@"Can not create docroot: %@", error]);
		return nil;
	}
	
	//link scripts directory
	NSString *scriptsPath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"scripts"];
	NSString *destPath = [NSString stringWithFormat:@"%@/scripts", docroot];
	if (![manager createSymbolicLinkAtPath:destPath pathContent: scriptsPath])
	{
		NSLog([NSString stringWithFormat:@"Can not create scripts path: %@", error]);
		return nil;
	}	
	return docroot;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell
	cell.text =  NSLocalizedString(@"Server address:",@"Server address:");
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return NSLocalizedString(@"Server is running",@"Server is running");
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
*/

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
    }
    if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}
*/

/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
}
*/
/*
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
