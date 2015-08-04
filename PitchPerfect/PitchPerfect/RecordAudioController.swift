//
//  RecordAudioController.swift
//  PitchPerfect
//
//  Created by Prajwal Kedilaya on 6/11/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioController: UIViewController, AVAudioRecorderDelegate {
    
    //control to stop recording
    @IBOutlet weak var stopButton: UIButton!
    //label to guide user
    @IBOutlet weak var statusLabel: UILabel!
    
    //recorder object
    var audioRecorder:AVAudioRecorder!
    //audio file object
    var recordedAudio:RecordedAudio!
    
    @IBAction func recordAudio(sender: AnyObject) {
        //show stop button
        stopButton.hidden = false
        //indicate action in progress
        statusLabel.text = "Recording in Progress"
        
        //create a file path for audio file
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //set up recording session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //set save path for recording
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        //allow delegate method access
        audioRecorder.delegate = self
        //perform recording
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag{
            //save filename and path to audio file object
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
            
            //pass audio file object along with activated segue
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    @IBAction func stopRecording(sender: AnyObject) {
        //stop recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording"{
            //refer to destintation controller from segue
            let vc:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            //set audio file in controller
            vc.recordedAudio = sender as! RecordedAudio
        }
    }
    override func viewWillAppear(animated: Bool) {
        //hide the stop button
        stopButton.hidden = true
        //prompt user for action
        statusLabel.text = "Tap to Record"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}