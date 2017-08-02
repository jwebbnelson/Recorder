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
    
    static let sharedInstance = AudioController()
    
    // To save on the device, we use a file URL
    // (similar format to what you would find on
    // your computer or the internet)
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // New Recording
    func getAudioFileLocationFromString(specificFileString:String) -> URL {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(specificFileString).m4a")
        return audioFilename
    }
   
    
}


