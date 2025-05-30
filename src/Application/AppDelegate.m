//
//  AppDelegate.m
//  StealthKit
//
//  Created by StealthKit Migration on 2025.
//  Copyright © 2025 StealthKit. All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>
#import "BrowserWindow.h"
#import "StealthManager.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"StealthKit: Application launching...");
    
    // Initialize stealth features
    [self initializeStealthFeatures];
    
    // Create main window
    self.mainWindow = [self createMainWindow];
    [self.mainWindow makeKeyAndOrderFront:nil];
    
    // Set up background operation
    [self setupBackgroundOperation];
    
    NSLog(@"StealthKit: Application launch completed");
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    NSLog(@"StealthKit: Application terminating...");
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    // Don't terminate when window closes in stealth mode
    return NO;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    // Show window when app icon is clicked
    if (!flag && self.mainWindow) {
        [self.mainWindow makeKeyAndOrderFront:nil];
    }
    return YES;
}

#pragma mark - Stealth Features Initialization

- (void)initializeStealthFeatures {
    NSLog(@"StealthKit: Initializing stealth features...");
    
    // Phase 4: Initialize StealthManager
    [[StealthManager shared] initializeStealthFeatures];
    
    NSLog(@"StealthKit: Stealth features initialized");
}

#pragma mark - Window Management

- (NSWindow *)createMainWindow {
    NSLog(@"StealthKit: Creating main browser window...");
    
    // Phase 4: Create stealth-configured browser window
    BrowserWindow *browserWindow = (BrowserWindow *)[[StealthManager shared] createStealthBrowserWindow];
    
    // Load a welcome page
    NSString *welcomeHTML = [self createWelcomePageHTML];
    [browserWindow loadHTMLString:welcomeHTML baseURL:nil];
    
    NSLog(@"StealthKit: Stealth browser window created");
    return browserWindow;
}

#pragma mark - Background Operation

- (void)setupBackgroundOperation {
    NSLog(@"StealthKit: Setting up background operation...");
    
    // TODO: Initialize StatusBarController in Phase 4
    // Set app activation policy to accessory (no dock icon)
    // [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
    // self.statusBarController = [[StatusBarController alloc] init];
    // [self.statusBarController setupStatusBar];
    
    NSLog(@"StealthKit: Background operation setup completed (placeholder)");
}

#pragma mark - Welcome Page

- (NSString *)createWelcomePageHTML {
    return @"<!DOCTYPE html>"
           @"<html><head>"
           @"<meta charset='utf-8'>"
           @"<title>Welcome to StealthKit</title>"
           @"<style>"
           @"body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; "
           @"       background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); "
           @"       color: white; margin: 0; padding: 40px; text-align: center; }"
           @"h1 { font-size: 3em; margin-bottom: 20px; }"
           @"p { font-size: 1.2em; line-height: 1.6; max-width: 600px; margin: 0 auto 30px; }"
           @"ul { text-align: left; max-width: 400px; margin: 0 auto; }"
           @"li { margin: 10px 0; }"
           @"</style>"
           @"</head><body>"
           @"<h1>🛡️ StealthKit</h1>"
           @"<p>Welcome to StealthKit - Phase 3: Smart Address Bar</p>"
           @"<p>A privacy-focused browser built with modern Cocoa and CMake.</p>"
           @"<ul>"
           @"<li>✅ CMake build system</li>"
           @"<li>✅ Programmatic UI with Auto Layout</li>"
           @"<li>✅ Safari-like toolbar and navigation</li>"
           @"<li>✅ Smart address bar</li>"
           @"<li>🔄 WebKit integration</li>"
           @"</ul>"
           @"<p>Try navigating to a website or searching for something!</p>"
           @"</body></html>";
}

#pragma mark - Menu Actions

- (IBAction)newDocument:(id)sender {
    NSLog(@"StealthKit: New document requested");
    if (self.mainWindow) {
        [self.mainWindow makeKeyAndOrderFront:nil];
    }
}

- (IBAction)showAbout:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"StealthKit";
    alert.informativeText = @"Version 1.0.0\nPrivacy-Focused Browser\nPhase 2: Core Browser Implementation\n\n© 2025 StealthKit. All rights reserved.";
    alert.alertStyle = NSAlertStyleInformational;
    [alert runModal];
}

@end
