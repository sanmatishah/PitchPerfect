//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Sanmati Shah on 19/07/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import AVFoundation
import UIKit

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    struct CurrentStateLabels {
        static let TapToRecord = "Tap to record"
        static let RecordingInProgress = "Recording in progress..."
    }
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var currentStateLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // MARK: ViewController Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(isRecording: false)
    }
    
    // MARK: Button Click Actions
    
    @IBAction func recordClicked(_ sender: Any) {
        configureUI(isRecording: true)
        recordAudio()
    }
    
    @IBAction func stopRecordingClicked(_ sender: Any) {
        configureUI(isRecording: false)
        stopRecording()
    }
    
    // MARK: ViewController Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playAudio" {
            let playSoundsViewController = segue.destination as! PlaySoundsViewController
            let recordedAudioUrl = sender as! URL
            playSoundsViewController.recordedAudioURL = recordedAudioUrl;
        }
    }
    
    // MARK: UI Functions
    
    func configureUI(isRecording: Bool) {
        recordButton.isEnabled = !isRecording
        stopRecordingButton.isEnabled = isRecording
        currentStateLabel.text = isRecording ? CurrentStateLabels.RecordingInProgress : CurrentStateLabels.TapToRecord
    }
    
    // MARK: Audio Functions
    
    func recordAudio() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecording() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "playAudio", sender: audioRecorder.url)
        } else {
            print("Recording failed")
        }
    }
}

