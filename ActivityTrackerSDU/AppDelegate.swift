//
//  AppDelegate.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 17/08/2018.
//

import Cocoa
import ServiceManagement

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}


@NSApplicationMain
class AppDelegate: NSObject {
    
    /*//open a new Pipe to consume the messages on STDOUT and STDERR
    let inputPipe = Pipe()
    //open another Pipe to output messages back to STDOUT
    let outputPipe = Pipe()
    
    func openConsolePipe() {
        
        let pipeReadHandle = inputPipe.fileHandleForReading
        
        //from documentation
        //dup2() makes newfd (new file descriptor) be the copy of oldfd (old file descriptor), closing newfd first if necessary.
        
        //here we are copying the STDOUT file descriptor into our output pipe's file descriptor
        //this is so we can write the strings back to STDOUT, so it can show up on the xcode console
        dup2(STDOUT_FILENO, outputPipe.fileHandleForWriting.fileDescriptor)
        
        //In this case, the newFileDescriptor is the pipe's file descriptor and the old file descriptor is STDOUT_FILENO and STDERR_FILENO
        
        dup2(inputPipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        dup2(inputPipe.fileHandleForWriting.fileDescriptor, STDERR_FILENO)
        
        //listen in to the readHandle notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.handlePipeNotification), name: FileHandle.readCompletionNotification, object: pipeReadHandle)
        
        //state that you want to be notified of any data coming across the pipe
        pipeReadHandle.readInBackgroundAndNotify()
    }
    
    @objc func handlePipeNotification(notification: Notification) {
        //note you have to continuously call this when you get a message
        //see this from documentation:
        //Note that this method does not cause a continuous stream of notifications to be sent. If you wish to keep getting notified, you’ll also need to call readInBackgroundAndNotify() in your observer method.
        inputPipe.fileHandleForReading.readInBackgroundAndNotify()
        
        if let data = notification.userInfo![NSFileHandleNotificationDataItem] as? Data,
            let str = String(data: data, encoding: String.Encoding.ascii) {
            
            if(!str.trimmingCharacters(in: .whitespaces).isEmpty){
                logw(str)
            }
            
            //write the data back into the output pipe. the output pipe's write file descriptor points to STDOUT. this allows the logs to show up on the xcode console
            outputPipe.fileHandleForWriting.write(data)
            
            // `str` here is the log/contents of the print statement
            //if you would like to route your print statements to the UI: make
            //sure to subscribe to this notification in your VC and update the UITextView.
            //Or if you wanted to send your print statements to the server, then
            //you could do this in your notification handler in the app delegate.
        }
    }*/
}


extension AppDelegate: NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        /*let launcherAppId = "dk.sdu.health.ActivityTrackerLauncher"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty
        
        SMLoginItemSetEnabled(launcherAppId as CFString, true)
        
        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher,
                                                         object: Bundle.main.bundleIdentifier!)
        }
        
        Log.logger.printToConsole = false
        
        openConsolePipe()
        
        /*// if not simulator, open console pipe
        #if !(targetEnvironment(simulator))
            openConsolePipe()
        #endif*/*/
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        if(!UserDefaultsHelper.getUseAppTracking()) {
            sendDeviceUsage(eventType: .ended)
            sleep(1) // Wait a second to ensure the device usage is sent. TODO: Make a cleaner handling.
        }
        
        return .terminateNow
        
    }
    
    
}


