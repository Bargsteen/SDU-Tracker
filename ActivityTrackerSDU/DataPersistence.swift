//
//  DataPersistence.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 09/09/2018.
//

import Foundation
import Cocoa

public class DataPersistence {
    
    init(directoryToUse: Storage.Directory) {
        let now = Date()
        
        self.buffer = []
        self.bufferFillingStarted = now
        self.appFileNamePrefix = "SDU_APP_"
        self.fileNamePostfix = ".json"
        self.deviceFileName = "SDU_DEVICE" + self.fileNamePostfix
        self.directory = directoryToUse
    }
    private let directory : Storage.Directory
    private let appFileNamePrefix : String
    private let deviceFileName : String
    private let fileNamePostfix : String
    private var buffer : [AppUsage]
    private var bufferFillingStarted : Date
    
    func saveAppUsage(_ data: AppUsage) {
        if(buffer.isEmpty) {
            
            buffer.append(data)
            bufferFillingStarted = Date()
            
        } else if (Date().timeIntervalSince(bufferFillingStarted).toMilliseconds() >= UInt.frequencyOfFileSavings){
            
            // Time to actually save buffer to disk
            let now = Date()
            let fileName = "\(appFileNamePrefix)\(now)\(fileNamePostfix)"
            Storage.store(buffer, to: self.directory, as: fileName)
            print("Saving to file \(fileName)")
            
            // Clear buffer, since it is now stored on disk
            buffer.removeAll()
            
        } else {
            
            buffer.append(data)
            
        }
    }
    
    func retrieveSavedAppUsages() -> [AppUsage] {
        let savedFileNames = Storage.getFileNamesInDirectory(directory: self.directory)
        if (!savedFileNames.isEmpty) {
            
            let sortedRelevantFileNames = savedFileNames.sorted().filter { fileName in fileName.starts(with: self.appFileNamePrefix) }
            
            if let oldestFileName = sortedRelevantFileNames.first {
                let oldestAppUsages = Storage.retrieve(oldestFileName, from: self.directory, as: [AppUsage].self)

                Storage.remove(oldestFileName, from: self.directory)
                
                if !oldestAppUsages.isEmpty {
                    return oldestAppUsages
                }
            }
        }
        return []
    }
    
    func saveDeviceUsage(_ newDeviceUsage: DeviceUsage) {
        var savedDeviceUsages = retrieveSavedDeviceUsages()
        savedDeviceUsages.append(newDeviceUsage)
        Storage.store(savedDeviceUsages, to: self.directory, as: self.deviceFileName)
    }
    
    func retrieveSavedDeviceUsages() -> [DeviceUsage] {
        if(Storage.fileExists(self.deviceFileName, in: self.directory)){
            return Storage.retrieve(self.deviceFileName, from: self.directory, as: [DeviceUsage].self)
        }
        return []
    }
}
