//
//  main.m
//  StealthKit
//
//  Created by StealthKit Migration on 2025.
//  Copyright © 2025 StealthKit. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Set process name for better identification
        [[NSProcessInfo processInfo] setProcessName:@"StealthKit"];
        
        // Initialize and run the application
        return NSApplicationMain(argc, argv);
    }
}
