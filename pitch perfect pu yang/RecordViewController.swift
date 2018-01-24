//
//  RecordViewController.swift
//  pitch perfect pu yang
//
//  Created by pu yang on 1/21/18.
//  Copyright © 2018 pu yang. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var record: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var stop: UIButton!

    var audioRecorder: AVAudioRecorder!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notrecording)
    }
    
    @IBAction func recordButtonPressed(_ sender: Any) {
        
        configureUI(.recording)
        
        let dirPath=NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as String
        
        let recordingName="recordedVoice.wav"
        let pathArray=[dirPath,recordingName]
        let filepath=NSURL.fileURL(withPathComponents: pathArray)
        print(filepath!)
        let session=AVAudioSession.sharedInstance()
        
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder=AVAudioRecorder(url: filepath!,settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled=true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        configureUI(.notrecording)
        audioRecorder.stop()
        
        let audiosession = AVAudioSession.sharedInstance()
        try! audiosession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "goToSecondScreen", sender: audioRecorder.url)
        }
        else {
            print("Voice not recorded")
            let alert = UIAlertController(title: "Sorry", message: "Voice not recorded", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK, I will try again", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSecondScreen" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            print("Recorded Audio Url: \(recordedAudioURL)")
        }
    }
    
    enum RecordingState { case recording, notrecording }
    
    func configureUI(_ recordingState: RecordingState) {
        switch(recordingState) {
        case .recording:
            label.text="Recording in progress"
            stop.isEnabled=true
            record.isEnabled=false
            
        case .notrecording:
            record.isEnabled = true
            stop.isEnabled = false
            label.text = "Tap to Record"
        }
    }

}

