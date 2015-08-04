//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Prajwal Kedilaya on 6/16/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

//import libraries for UI and audio manipulation
import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    //audio player
    var player = AVAudioPlayer()
    //audio file object
    var recordedAudio:RecordedAudio!
    //audio engine, used for pitch effects
    var audioEngine: AVAudioEngine!
    //raw audio file
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        //initialize audio engine
        audioEngine = AVAudioEngine()
        
        //set file path for raw audio file and audio player
        audioFile = AVAudioFile(forReading: recordedAudio.filePathURL, error: nil)
        player = AVAudioPlayer(contentsOfURL: recordedAudio.filePathURL, error: nil)
        
        //allow for player to change playback speed
        player.enableRate = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func slowPlay(sender: AnyObject) {
        //reset playback
        resetAudio()
        //change playback to half speed
        player.rate = 0.5
        //start playback
        player.play()
    }
    
    @IBAction func fastPlay(sender: AnyObject) {
        //reset playback
        resetAudio()
        //change playback to double speed
        player.rate = 2.0
        //start playback
        player.play()
    }
    
    func resetAudio(){
        //stops player and engine
        player.stop()
        audioEngine.stop()
        
        //reset playback to start of file
        player.currentTime = 0.0
        audioEngine.reset()
    }
    
    @IBAction func squirrelPlay(sender: AnyObject) {
        //higher pitch than normal
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func vaderPlayer(sender: AnyObject) {
        //lower pitch than normal
        playAudioWithVariablePitch(-1000)
    }
    func playAudioWithVariablePitch(pitch:Float){
        //reset playback
        resetAudio()
        
        //add player node to engine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //add pitch modifier node to engine
        var changePitchEffect = AVAudioUnitTimePitch()
        //set pitch for node
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        //connect player node to pitch node in engine
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        //connect pitch node to output node
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        //schedule playback of file in player node
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        //turn on the engine
        audioEngine.startAndReturnError(nil)
        
        //start playback
        audioPlayerNode.play()
    }
    

    @IBAction func stopAudio(sender: AnyObject) {
        //stops player and engine
        player.stop()
        audioEngine.stop()
    }
}
