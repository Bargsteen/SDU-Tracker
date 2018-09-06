//
//  WindowTracking.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 03/09/2018.
//

import Foundation
import Cocoa


func getVisibleWindows() -> [WindowInfo]{
    
    // Get weakly typed info about Windows
    let options = CGWindowListOption(arrayLiteral: CGWindowListOption.excludeDesktopElements, CGWindowListOption.optionOnScreenOnly)
    let windowListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
    let infoList = windowListInfo as NSArray? as? [[String: AnyObject]]
    
    // Parse windowInfo to strong types
    var windowInfoList : [WindowInfo] = []
    if let infoList = infoList {
        infoList.forEach { windowInfoData in
            let windowInfo : WindowInfo? = parseWindowInfo(windowInfoData)
            windowInfoList.maybeAppend(windowInfo)
        }
    }

    // Filter windows 
    return windowInfoList.filter(windowIsVisible)
}

func parseWindowInfo(_ infoDict: [String: AnyObject]) -> WindowInfo? {
    guard let appName = infoDict["kCGWindowOwnerName"] as? String else { return nil }
    guard let windowName = infoDict["kCGWindowName"] as? String else { return nil }
    guard let windowLayer = infoDict["kCGWindowLayer"] as? Int else { return nil }
    guard let windowIsOnScreenInt = infoDict["kCGWindowIsOnscreen"] as? Int else { return nil }
    let windowIsOnScreen = windowIsOnScreenInt == 1 ? true : false
    guard let windowBounds = infoDict["kCGWindowBounds"] as? [String: Any] else { return nil }
    guard let height = windowBounds["Height"] as! Int? else { return nil }
    guard let width = windowBounds["Width"] as! Int? else { return nil }
    guard let x = windowBounds["X"] as! Int? else { return nil }
    guard let y = windowBounds["Y"] as! Int? else { return nil }
    
    return WindowInfo(ApplicationName: appName, WindowName: windowName, WindowLayer: windowLayer,
                      WindowIsOnScreen: windowIsOnScreen, Height: height, Width: width, X: x, Y: y)
}

func windowIsVisible(_ windowInfo: WindowInfo) -> Bool {
    let area = abs(windowInfo.Width) * abs(windowInfo.Height)
    return area >= 1000 && windowInfo.WindowLayer == 0 && windowInfo.WindowIsOnScreen == true
}

struct WindowInfo {
    let ApplicationName : String
    let WindowName : String
    let WindowLayer : Int
    let WindowIsOnScreen : Bool
    let Height : Int
    let Width : Int
    let X : Int
    let Y : Int
}
