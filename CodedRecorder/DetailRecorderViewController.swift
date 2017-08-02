//
//  DetailRecorderViewController.swift
//  CodedRecorder
//
//  Created by Jordan Nelson on 8/1/17.
//  Copyright © 2017 VisionTech. All rights reserved.
//

import UIKit
// *Import AVFoundation Framework
import AVFoundation

class DetailRecorderViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recordButton.alpha = 0
        
        // Instantiate the main default recordingSession
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            
            // Must request permission for access to microphone
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        // Show record button
                        self.recordButton.alpha = 1
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }

    }
    
    // Method called to begin recording audio
    func startRecording() {
        // Retrieve the file location in memory we allocated
        let audioFilename = AudioController.sharedInstance.createNewAudioFileLocation(specificFileString: "New")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
//            audioRecorder.record()
            
            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }

    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            // recording failed :(
            recordButton.setTitle("Tap to Record", for: .normal)
        }
    }
    
    
    // DELEGATE METHOD
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    

}
