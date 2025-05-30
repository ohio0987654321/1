//
//  ToolbarView.m
//  StealthKit
//
//  Created on Phase 2: Core Browser Implementation
//

#import "ToolbarView.h"
#import "AddressBarView.h"

@interface ToolbarView ()
@property (nonatomic, strong) NSButton *backButton;
@property (nonatomic, strong) NSButton *forwardButton;
@property (nonatomic, strong) NSButton *reloadButton;
@property (nonatomic, strong) AddressBarView *addressBar;
@end

@implementation ToolbarView

+ (instancetype)createToolbarView {
    ToolbarView *toolbar = [[ToolbarView alloc] init];
    [toolbar setupViews];
    [toolbar setupLayout];
    [toolbar setupStyling];
    return toolbar;
}

- (void)setupViews {
    // Create navigation buttons
    self.backButton = [self createNavigationButton:@"←" action:@selector(backButtonPressed:)];
    self.forwardButton = [self createNavigationButton:@"→" action:@selector(forwardButtonPressed:)];
    self.reloadButton = [self createNavigationButton:@"↻" action:@selector(reloadButtonPressed:)];
    
    // Create address bar
    self.addressBar = [AddressBarView createAddressBar];
    
    // Add to view hierarchy
    [self addSubview:self.backButton];
    [self addSubview:self.forwardButton];
    [self addSubview:self.reloadButton];
    [self addSubview:self.addressBar];
}

- (NSButton *)createNavigationButton:(NSString *)title action:(SEL)action {
    NSButton *button = [[NSButton alloc] init];
    button.title = title;
    button.bezelStyle = NSBezelStyleRounded;
    button.font = [NSFont systemFontOfSize:16.0 weight:NSFontWeightMedium];
    button.target = self;
    button.action = action;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    return button;
}

- (void)setupLayout {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Configure subviews for Auto Layout
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.forwardButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.reloadButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.addressBar.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Layout constraints - Safari-like spacing
    [NSLayoutConstraint activateConstraints:@[
        // Toolbar height
        [self.heightAnchor constraintEqualToConstant:44.0],
        
        // Button sizes
        [self.backButton.widthAnchor constraintEqualToConstant:32.0],
        [self.backButton.heightAnchor constraintEqualToConstant:28.0],
        [self.forwardButton.widthAnchor constraintEqualToConstant:32.0],
        [self.forwardButton.heightAnchor constraintEqualToConstant:28.0],
        [self.reloadButton.widthAnchor constraintEqualToConstant:32.0],
        [self.reloadButton.heightAnchor constraintEqualToConstant:28.0],
        [self.addressBar.heightAnchor constraintEqualToConstant:28.0],
        
        // Back button
        [self.backButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:8.0],
        [self.backButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        
        // Forward button
        [self.forwardButton.leadingAnchor constraintEqualToAnchor:self.backButton.trailingAnchor constant:4.0],
        [self.forwardButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        
        // Reload button
        [self.reloadButton.leadingAnchor constraintEqualToAnchor:self.forwardButton.trailingAnchor constant:8.0],
        [self.reloadButton.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        
        // Address bar - takes remaining space
        [self.addressBar.leadingAnchor constraintEqualToAnchor:self.reloadButton.trailingAnchor constant:8.0],
        [self.addressBar.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8.0],
        [self.addressBar.centerYAnchor constraintEqualToAnchor:self.centerYAnchor]
    ]];
}

- (void)setupStyling {
    // Toolbar background similar to Safari
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor controlBackgroundColor].CGColor;
    
    // Add subtle border at bottom
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.backgroundColor = [NSColor separatorColor].CGColor;
    bottomBorder.frame = CGRectMake(0, 0, self.bounds.size.width, 1);
    bottomBorder.autoresizingMask = kCALayerWidthSizable;
    [self.layer addSublayer:bottomBorder];
}

- (void)updateNavigationButtons:(BOOL)canGoBack canGoForward:(BOOL)canGoForward {
    self.backButton.enabled = canGoBack;
    self.forwardButton.enabled = canGoForward;
}

#pragma mark - Button Actions

- (void)backButtonPressed:(id)sender {
    // Will be handled by parent window
    [NSApp sendAction:@selector(goBack) to:nil from:self];
}

- (void)forwardButtonPressed:(id)sender {
    // Will be handled by parent window
    [NSApp sendAction:@selector(goForward) to:nil from:self];
}

- (void)reloadButtonPressed:(id)sender {
    // Will be handled by parent window
    [NSApp sendAction:@selector(reload) to:nil from:self];
}

@end
