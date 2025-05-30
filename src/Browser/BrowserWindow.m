//
//  BrowserWindow.m
//  StealthKit
//
//  Created on Phase 2: Core Browser Implementation
//

#import "BrowserWindow.h"
#import "ToolbarView.h"
#import "AddressBarView.h"
#import "URLHelper.h"
#import "SearchEngineManager.h"

@interface BrowserWindow () <AddressBarViewDelegate, WKNavigationDelegate>
@property (nonatomic, strong) ToolbarView *toolbarView;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation BrowserWindow

+ (instancetype)createBrowserWindow {
    NSRect windowFrame = NSMakeRect(100, 100, 1200, 800);
    
    BrowserWindow *window = [[BrowserWindow alloc] initWithContentRect:windowFrame
                                                             styleMask:NSWindowStyleMaskTitled |
                                                                       NSWindowStyleMaskClosable |
                                                                       NSWindowStyleMaskMiniaturizable |
                                                                       NSWindowStyleMaskResizable
                                                               backing:NSBackingStoreBuffered
                                                                 defer:NO];
    
    [window setupWindow];
    [window setupViews];
    [window setupLayout];
    
    return window;
}

- (void)setupWindow {
    self.title = @"StealthKit";
    self.minSize = NSMakeSize(400, 300);
    self.releasedWhenClosed = NO;
    
    // Center the window on screen
    [self center];
}

- (void)setupViews {
    // Create main content view
    NSView *mainContentView = [[NSView alloc] init];
    mainContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self setContentView:mainContentView];
    
    // Create toolbar
    self.toolbarView = [ToolbarView createToolbarView];
    self.toolbarView.addressBar.addressBarDelegate = self;
    
    // Create web view with configuration
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.websiteDataStore = [WKWebsiteDataStore defaultDataStore]; // For now, use default store
    
    self.webView = [[WKWebView alloc] initWithFrame:NSZeroRect configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Add views to hierarchy
    [mainContentView addSubview:self.toolbarView];
    [mainContentView addSubview:self.webView];
}

- (void)setupLayout {
    [NSLayoutConstraint activateConstraints:@[
        // Toolbar at top
        [self.toolbarView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.toolbarView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.toolbarView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        
        // Web view fills remaining space
        [self.webView.topAnchor constraintEqualToAnchor:self.toolbarView.bottomAnchor],
        [self.webView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.webView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.webView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]
    ]];
}

#pragma mark - Public Methods

- (void)loadURL:(NSURL *)url {
    if (url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

- (void)loadHTMLString:(NSString *)htmlString baseURL:(NSURL *)baseURL {
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
}

- (void)goBack {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
}

- (void)goForward {
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }
}

- (void)reload {
    [self.webView reload];
}

#pragma mark - AddressBarViewDelegate

- (void)addressBar:(AddressBarView *)addressBar didSubmitInput:(NSString *)input {
    // Phase 3: Use smart URL detection and search engine management
    NSURL *url = [self smartURLFromUserInput:input];
    if (url) {
        [self loadURL:url];
    }
}

- (NSURL *)smartURLFromUserInput:(NSString *)input {
    // Phase 3: Use URLHelper for intelligent URL detection
    if (!input || input.length == 0) {
        return nil;
    }
    
    // Use URLHelper for intelligent URL detection
    NSURL *url = [URLHelper URLFromUserInput:input];
    if (url) {
        NSLog(@"StealthKit: Detected URL: %@", url.absoluteString);
        return url;
    }
    
    // Use SearchEngineManager for search queries
    SearchEngineManager *searchManager = [SearchEngineManager shared];
    NSURL *searchURL = [searchManager searchURLForQuery:input];
    
    if (searchURL) {
        NSLog(@"StealthKit: Searching with %@: %@", searchManager.currentSearchEngine.displayName, input);
        return searchURL;
    }
    
    // Fallback to Google if something goes wrong
    NSString *encodedQuery = [input stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *fallbackURL = [NSString stringWithFormat:@"https://www.google.com/search?q=%@", encodedQuery];
    return [NSURL URLWithString:fallbackURL];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    // Update toolbar button states
    [self.toolbarView updateNavigationButtons:webView.canGoBack canGoForward:webView.canGoForward];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // Update address bar with current URL
    if (webView.URL) {
        [self.toolbarView.addressBar updateWithURL:webView.URL];
    }
    
    // Update toolbar button states
    [self.toolbarView updateNavigationButtons:webView.canGoBack canGoForward:webView.canGoForward];
    
    // Update window title
    if (webView.title.length > 0) {
        self.title = [NSString stringWithFormat:@"%@ - StealthKit", webView.title];
    } else {
        self.title = @"StealthKit";
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"Navigation failed: %@", error.localizedDescription);
    
    // Update toolbar button states even on error
    [self.toolbarView updateNavigationButtons:webView.canGoBack canGoForward:webView.canGoForward];
}

@end
