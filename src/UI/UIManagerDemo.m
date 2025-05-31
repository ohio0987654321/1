//
//  UIManagerDemo.m
//  StealthKit
//
//  UIManager demonstration and usage examples
//

#import "UIManager.h"

/**
 * Demonstration of UIManager capabilities and usage patterns.
 * This file shows how to use the UIManager for consistent UI creation.
 */

void demonstrateUIManagerUsage() {
    UIManager *uiManager = [UIManager sharedManager];
    
    // Example 1: Creating consistent buttons
    NSButton *primaryButton = [uiManager createButtonWithTitle:@"Download" 
                                                         style:UIButtonStyleAction 
                                                        target:nil 
                                                        action:nil];
    
    NSButton *cancelButton = [uiManager createButtonWithTitle:@"Cancel" 
                                                        style:UIButtonStyleSecondary 
                                                       target:nil 
                                                       action:nil];
    
    // Example 2: Creating text fields with consistent styling
    NSTextField *searchField = [uiManager createTextFieldWithPlaceholder:@"Search..." 
                                                                   style:UITextFieldStyleSearch];
    
    NSTextField *formField = [uiManager createTextFieldWithPlaceholder:@"Enter value" 
                                                                  style:UITextFieldStyleForm];
    
    // Example 3: Creating layout with consistent spacing
    NSView *container = [uiManager createContainerView];
    NSView *separator = [uiManager createSeparatorView];
    
    // Example 4: Using dimension constants for consistent layout
    CGFloat toolbarHeight = uiManager.toolbarHeight;      // 44.0
    CGFloat spacing = uiManager.standardSpacing;          // 8.0
    CGFloat smallSpacing = uiManager.smallSpacing;        // 4.0
    
    // Example 5: Applying styles to existing views
    NSButton *existingButton = [[NSButton alloc] init];
    [uiManager styleButton:existingButton withStyle:UIButtonStyleNavigation];
    
    // Example 6: Theme management
    [uiManager setTheme:UIThemeDark];     // Force dark theme
    [uiManager setTheme:UIThemeLight];    // Force light theme
    [uiManager setTheme:UIThemeAuto];     // Follow system theme
    
    // Example 7: Accessing theme-aware colors
    NSColor *primaryBg = uiManager.primaryBackgroundColor;
    NSColor *accentColor = uiManager.accentColor;
    NSColor *borderColor = uiManager.borderColor;
    
    // Example 8: Typography system
    NSFont *systemFont = [uiManager systemFontOfSize:14.0];
    NSFont *boldFont = [uiManager boldSystemFontOfSize:16.0];
    NSFont *mediumFont = [uiManager mediumSystemFontOfSize:15.0];
    
    NSLog(@"UIManager demo: Created components with consistent styling");
    NSLog(@"  - Toolbar height: %.1f", toolbarHeight);
    NSLog(@"  - Standard spacing: %.1f", spacing);
    NSLog(@"  - Current theme supports dark mode: %@", 
          [uiManager isDarkMode] ? @"YES" : @"NO");
}

/**
 * Example of creating a custom dialog using UIManager for consistency
 */
NSView* createCustomDialogWithUIManager() {
    UIManager *uiManager = [UIManager sharedManager];
    
    // Create container
    NSView *dialog = [uiManager createContainerView];
    
    // Create title label
    NSTextField *titleLabel = [[NSTextField alloc] init];
    titleLabel.stringValue = @"Confirm Action";
    titleLabel.font = [uiManager boldSystemFontOfSize:16.0];
    titleLabel.textColor = uiManager.primaryTextColor;
    titleLabel.backgroundColor = [NSColor clearColor];
    titleLabel.bordered = NO;
    titleLabel.editable = NO;
    
    // Create message label
    NSTextField *messageLabel = [[NSTextField alloc] init];
    messageLabel.stringValue = @"Are you sure you want to continue?";
    messageLabel.font = [uiManager systemFontOfSize:13.0];
    messageLabel.textColor = uiManager.secondaryTextColor;
    messageLabel.backgroundColor = [NSColor clearColor];
    messageLabel.bordered = NO;
    messageLabel.editable = NO;
    
    // Create buttons using UIManager
    NSButton *confirmButton = [uiManager createButtonWithTitle:@"Continue" 
                                                         style:UIButtonStyleAction 
                                                        target:nil 
                                                        action:nil];
    
    NSButton *cancelButton = [uiManager createButtonWithTitle:@"Cancel" 
                                                        style:UIButtonStyleSecondary 
                                                       target:nil 
                                                       action:nil];
    
    // Create separator
    NSView *separator = [uiManager createSeparatorView];
    
    // Add all subviews
    [dialog addSubview:titleLabel];
    [dialog addSubview:messageLabel];
    [dialog addSubview:separator];
    [dialog addSubview:confirmButton];
    [dialog addSubview:cancelButton];
    
    // Set up constraints using UIManager constants
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        // Dialog size
        [dialog.widthAnchor constraintEqualToConstant:300],
        [dialog.heightAnchor constraintEqualToConstant:150],
        
        // Title label
        [titleLabel.topAnchor constraintEqualToAnchor:dialog.topAnchor constant:uiManager.largeSpacing],
        [titleLabel.leadingAnchor constraintEqualToAnchor:dialog.leadingAnchor constant:uiManager.largeSpacing],
        [titleLabel.trailingAnchor constraintEqualToAnchor:dialog.trailingAnchor constant:-uiManager.largeSpacing],
        
        // Message label
        [messageLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:uiManager.standardSpacing],
        [messageLabel.leadingAnchor constraintEqualToAnchor:dialog.leadingAnchor constant:uiManager.largeSpacing],
        [messageLabel.trailingAnchor constraintEqualToAnchor:dialog.trailingAnchor constant:-uiManager.largeSpacing],
        
        // Separator
        [separator.topAnchor constraintEqualToAnchor:messageLabel.bottomAnchor constant:uiManager.largeSpacing],
        [separator.leadingAnchor constraintEqualToAnchor:dialog.leadingAnchor],
        [separator.trailingAnchor constraintEqualToAnchor:dialog.trailingAnchor],
        
        // Buttons
        [cancelButton.bottomAnchor constraintEqualToAnchor:dialog.bottomAnchor constant:-uiManager.largeSpacing],
        [cancelButton.trailingAnchor constraintEqualToAnchor:dialog.trailingAnchor constant:-uiManager.largeSpacing],
        
        [confirmButton.bottomAnchor constraintEqualToAnchor:dialog.bottomAnchor constant:-uiManager.largeSpacing],
        [confirmButton.trailingAnchor constraintEqualToAnchor:cancelButton.leadingAnchor constant:-uiManager.standardSpacing]
    ]];
    
    return dialog;
}
