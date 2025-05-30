//
//  AddressBarView.m
//  StealthKit
//
//  Created on Phase 2: Core Browser Implementation
//

#import "AddressBarView.h"

@interface AddressBarView ()
@end

@implementation AddressBarView

+ (instancetype)createAddressBar {
    AddressBarView *addressBar = [[AddressBarView alloc] init];
    [addressBar setupStyling];
    [addressBar setupBehavior];
    return addressBar;
}

- (void)setupStyling {
    // Safari-like appearance
    self.bezeled = YES;
    self.bezelStyle = NSTextFieldRoundedBezel;
    self.placeholderString = @"Search or enter website name";
    self.font = [NSFont systemFontOfSize:14.0];
    
    // Configure cell for better appearance
    NSTextFieldCell *cell = self.cell;
    cell.scrollable = YES;
    cell.wraps = NO;
    
    // Height will be set by parent ToolbarView constraints
}

- (void)setupBehavior {
    self.target = self;
    self.action = @selector(textFieldAction:);
}

- (void)textFieldAction:(id)sender {
    NSString *input = self.stringValue;
    if (input.length > 0 && self.addressBarDelegate) {
        [self.addressBarDelegate addressBar:self didSubmitInput:input];
    }
}

- (void)updateWithURL:(NSURL *)url {
    if (url) {
        self.stringValue = url.absoluteString;
    }
}

- (void)clear {
    self.stringValue = @"";
}

- (void)focusAddressField {
    // Make the text field first responder to focus it
    [[self window] makeFirstResponder:self];
    
    // Select all text for easy overwriting
    [self selectText:nil];
    
    NSLog(@"AddressBarView: Address field focused");
}

// Handle Enter key properly
- (void)keyDown:(NSEvent *)event {
    if (event.keyCode == 36) { // Enter key
        [self textFieldAction:self];
    } else {
        [super keyDown:event];
    }
}

// Select all text when focused (Safari behavior)
- (BOOL)becomeFirstResponder {
    BOOL result = [super becomeFirstResponder];
    if (result) {
        // Delay text selection to ensure it works properly
        dispatch_async(dispatch_get_main_queue(), ^{
            [self selectText:nil];
        });
    }
    return result;
}

@end
