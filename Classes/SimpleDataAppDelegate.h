//
//  SimpleDataAppDelegate.h
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright Brian Collins 2009. All rights reserved.
//

@interface SimpleDataAppDelegate : NSObject <UIApplicationDelegate> {
    


    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

- (NSString *)applicationDocumentsDirectory;

@end

