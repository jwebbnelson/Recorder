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

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playAudioButton: UIButton!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    var currentRecordingTitle:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordButton.alpha = 0
        if let currentRecordingTitle = currentRecordingTitle {
            titleTextField.text = currentRecordingTitle
        }

        
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
        
        guard let title = titleTextField.text else { return }
        
        // Retrieve the file location in memory we allocated
        let audioFilename = AudioController.sharedInstance.getAudioFileLocationFromString(specificFileString: title)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    
    // MARK: - BUTTON ACTIONS
    
    // Record
    @IBAction func recordButtonTapped(_ sender: Any) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    // Listen
    @IBAction func playAudioButtonTapped(_ sender: Any) {
        
        guard let title = titleTextField.text else { return }
        
        let audioFileURL = AudioController.sharedInstance.getAudioFileLocationFromString(specificFileString: title)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: audioFileURL)
            audioPlayer = sound
            sound.play()
        } catch {
            // couldn't load file :(
            
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let title = titleTextField.text else { return }

       // If current title, we know we are updating
        if let currentRecordingTitle = currentRecordingTitle {
            AudioController.sharedInstance.updateRecordTitle(oldTitle: currentRecordingTitle, newTitle: title)
        } else {
            // If no title existing, we are creating a new recording
            AudioController.sharedInstance.createNewRecord(title: title)
        }
        
        navigationController?.popViewController(animated: true)
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
