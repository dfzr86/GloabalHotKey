//
//  AppDelegate.m
//  RegisterGlobalHotKey
//
//  Created by hanxu on 2021/6/9.
//

#import "AppDelegate.h"
#import <Carbon/Carbon.h>

static AppDelegate *appDelegate = nil;

@interface AppDelegate ()

@property (nonatomic, strong) NSRunningApplication *chrome;
@property (nonatomic, strong) NSRunningApplication *xcode;
@property (nonatomic, strong) NSRunningApplication *simulator;
@property (nonatomic, strong) NSRunningApplication *lingxi;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    appDelegate = self;
    [self addGlobalHotKey:kVK_ANSI_S];
    [self addGlobalHotKey:kVK_ANSI_X];
    [self addGlobalHotKey:kVK_ANSI_V];
    [self addGlobalHotKey:kVK_ANSI_Z];
    [self addGlobalHotKey:kVK_ANSI_D onlyCmd:YES];
}

- (void)addGlobalHotKey:(UInt32)keyCode {
    [self addGlobalHotKey:keyCode onlyCmd:NO];
}

- (void)addGlobalHotKey:(UInt32)keyCode onlyCmd:(BOOL)onlyCmd {
    EventHotKeyRef       gMyHotKeyRef;
    EventHotKeyID        gMyHotKeyID;
    EventTypeSpec        eventType;
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind = kEventHotKeyPressed;
    InstallApplicationEventHandler(&GlobalHotKeyHandler, 1, &eventType, NULL, NULL);
    gMyHotKeyID.signature = 'asdj';
    gMyHotKeyID.id = keyCode;
    
    RegisterEventHotKey(keyCode,
                        onlyCmd ? cmdKey : cmdKey + shiftKey,
                        gMyHotKeyID,
                        GetApplicationEventTarget(),
                        0,
                        &gMyHotKeyRef);
}

OSStatus GlobalHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent,void *userData) {
    EventHotKeyID hkCom;
    GetEventParameter(theEvent,kEventParamDirectObject,typeEventHotKeyID,NULL,
                      sizeof(hkCom),NULL,&hkCom);
    int l = hkCom.id;
    switch (l) {
        case kVK_ANSI_S: {
            NSLog(@"kVK_ANSI_S按下");
            [appDelegate openChrome];
        }
            break;
        case kVK_ANSI_X: {
            NSLog(@"kVK_ANSI_X按下");
            [appDelegate openXcodeBeta];
        }
            break;
        case kVK_ANSI_V: {
            NSLog(@"kVK_ANSI_V按下");
            [appDelegate openSimulatorBeta];
        }
            break;
        case kVK_ANSI_D: {
            NSLog(@"kVK_ANSI_D按下");
            [appDelegate hideAll];
        }
            break;
        case kVK_ANSI_Z: {
            NSLog(@"kVK_ANSI_Z按下");
            [appDelegate openLingXi];
        }
            break;
    }
    return noErr;
}

- (void)openLingXi {
    if (self.lingxi.isActive) {
        [self.lingxi hide];
        return;
    }
    
    [self.lingxi activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    [NSWorkspace.sharedWorkspace openApplicationAtURL:[NSURL fileURLWithPath:@"/Applications/网易灵犀办公.app"]
                                        configuration:[NSWorkspaceOpenConfiguration configuration]
                                    completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
        self.lingxi = app;
    }];
    
}

- (void)openChrome {
    if (self.chrome.isActive) {
        [self.chrome hide];
        return;
    }
    
    [self.chrome activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    [NSWorkspace.sharedWorkspace openApplicationAtURL:[NSURL fileURLWithPath:@"/Applications/Google Chrome.app"]
                                        configuration:[NSWorkspaceOpenConfiguration configuration]
                                    completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
        self.chrome = app;
    }];
}

- (void)openSafari {
    if (self.chrome.isActive) {
        [self.chrome hide];
        return;
    }
    
    [self.chrome activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    [NSWorkspace.sharedWorkspace openApplicationAtURL:[NSURL fileURLWithPath:@"/Applications/Safari.app"]
                                        configuration:[NSWorkspaceOpenConfiguration configuration]
                                    completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
        self.chrome = app;
    }];
}

- (void)openXcodeBeta {
    if (self.xcode.isActive) {
        [self.xcode hide];
        return;
    }
    
    [self.xcode activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    [NSWorkspace.sharedWorkspace openApplicationAtURL:[NSURL fileURLWithPath:@"/Applications/Xcode-beta.app"]
                                        configuration:[NSWorkspaceOpenConfiguration configuration]
                                    completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
        self.xcode = app;
    }];
}

- (void)openXcode {
    if (self.xcode.isActive) {
        [self.xcode hide];
        return;
    }
    
    [self.xcode activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    [NSWorkspace.sharedWorkspace openApplicationAtURL:[NSURL fileURLWithPath:@"/Applications/Xcode.app"]
                                        configuration:[NSWorkspaceOpenConfiguration configuration]
                                    completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
        self.xcode = app;
    }];
}

- (void)openSimulatorBeta {
    if (self.simulator.isActive) {
        [self.simulator hide];
        return;
    }
    
    [self.simulator activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    [NSWorkspace.sharedWorkspace openApplicationAtURL:[NSURL fileURLWithPath:@"/Applications/Xcode-beta.app/Contents/Developer/Applications/Simulator.app"]
                                        configuration:[NSWorkspaceOpenConfiguration configuration]
                                    completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
        self.simulator = app;
    }];
}

- (void)openSimulator {
    if (self.simulator.isActive) {
        [self.simulator hide];
        return;
    }
    
    [self.simulator activateWithOptions:NSApplicationActivateIgnoringOtherApps];
    [NSWorkspace.sharedWorkspace openApplicationAtURL:[NSURL fileURLWithPath:@"/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"]
                                        configuration:[NSWorkspaceOpenConfiguration configuration]
                                    completionHandler:^(NSRunningApplication * _Nullable app, NSError * _Nullable error) {
        self.simulator = app;
    }];
}

- (void)hideAll {
    [NSWorkspace.sharedWorkspace hideOtherApplications];
}

@end
