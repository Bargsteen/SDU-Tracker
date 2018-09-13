//
//  DataPersistence.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 09/09/2018.
//

import Foundation
import Cocoa

public class DataPersistence {
    
    init() {
        let now = Date()
        
        self.buffer = []
        self.bufferFillingStarted = now
        self.fileNamePrefix = "SDU_"
        self.fileNamePostfix = ".json"
    }
    private let directory = Storage.Directory.documents
    private let fileNamePrefix : String
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
            let fileName = "\(fileNamePrefix)\(now)\(fileNamePostfix)"
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
            
            let sortedRelevantFileNames = savedFileNames.sorted().filter { fileName in fileName.starts(with: self.fileNamePrefix) }
            
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
}
