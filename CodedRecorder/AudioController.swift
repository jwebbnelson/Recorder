//
//  AudioController.swift
//  CodedRecorder
//
//  Created by Jordan Nelson on 8/2/17.
//  Copyright © 2017 VisionTech. All rights reserved.
//

import Foundation
import AVFoundation

// Managers the where we will store the audio files on the device
class AudioController {
    
    private static let RecordsKey = "records"
    
    static let sharedInstance = AudioController()
    
    private(set) var recordingTitles:[String] = []
    
    init() {
        // Retrieve record string array when initalized
        loadFromPersistentStorage()
    }
    
    // MARK: - FILE URLS
    
    // To save on the device, we use a file URL
    // (similar format to what you would find on
    // your computer or the internet)
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // Using a string as a parameter,
    // we retrieve the specific location in memory
    // to either save/retrieve our recording
    func getAudioFileLocationFromString(specificFileString:String) -> URL {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(specificFileString).m4a")
        return audioFilename
    }
   
    // MARK: - ADD, UPDATE, REMOVE RECORDING TITLES
    
    // Adds string to recordTitles
    func createNewRecord(title:String) {
        recordingTitles.append(title)
        // NSUSERDEFAULTS
        saveToPersistentStorage()
    }
    
    func updateRecordTitle(oldTitle: String, newTitle:String) {
        
        // Find where the string is in the list
        if let index = recordingTitles.index(of: oldTitle) {
            // Use index to get that specific string
            var oldRecordingTitle = recordingTitles[index]
            // Update
            oldRecordingTitle = ""
            oldRecordingTitle = newTitle
            // NSUSERDEFAULTS
            saveToPersistentStorage()
        }
    }
    
    func removeTitle(title:String) {
        
        // Find where the player is in the list
        if let index = recordingTitles.index(of: title) {
            recordingTitles.remove(at: index)
            // NSUSERDEFAULTS
            saveToPersistentStorage()
        }
    }
    
    //MARK: -  NSUserDefaults
    private func loadFromPersistentStorage() {
        if let recordingStrings = UserDefaults.standard.object(forKey: AudioController.RecordsKey) as? [String] {
            recordingTitles = recordingStrings
        }
    }
    
    private func saveToPersistentStorage() {
        UserDefaults.standard.set(recordingTitles, forKey: AudioController.RecordsKey)
    }
}


