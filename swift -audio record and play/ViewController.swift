//
//  ViewController.swift
//  swift -audio record and play
//
//  Created by vignesh kumar c on 20/12/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate,AVAudioPlayerDelegate {

   
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    var sound: AVAudioRecorder!
    var player: AVAudioPlayer!
    
    var fileName: String = "audioFile.m4a"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        setupRecorder()
        playBtn.isEnabled = false
        
   }

    func getDocumentDirector() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func setupRecorder(){
        let audioFileName = getDocumentDirector().appendingPathComponent(fileName)
        let recordSetting = [AVFormatIDKey: kAudioFormatAppleLossless,
                  AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                       AVEncoderBitRateKey: 32000,
                     AVNumberOfChannelsKey: 2,
                           AVSampleRateKey: 44100.2] as [String : Any]
        do {
            sound = try AVAudioRecorder(url: audioFileName, settings: recordSetting)
            sound.delegate = self
            sound.prepareToRecord()
        }catch {
            print(error)
        }
    }
    
    
    func setupPlayer(){
        let audioFileName = getDocumentDirector().appendingPathComponent(fileName)
        do {
            player = try AVAudioPlayer(contentsOf: audioFileName)
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
        }catch{
            print(error)
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playBtn.isEnabled = true
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordBtn.isEnabled = true
        playBtn.setTitle("Play", for: .normal)
    }
    
    @IBAction func recordActn(_ sender: Any) {
        if recordBtn.titleLabel?.text == "Record" {
            sound.record()
            recordBtn.setTitle("Stop", for: .normal)
            playBtn.isEnabled = false
        }else {
            sound.stop()
            recordBtn.setTitle("Record", for: .normal)
            playBtn.isEnabled = false
        }
        
    }
    
    @IBAction func playActn(_ sender: Any) {
        if playBtn.titleLabel?.text == "Play"{
            playBtn.setTitle("Stop", for: .normal)
            recordBtn.isEnabled = false
            setupPlayer()
            player.play()
        }else {
            player.stop()
            playBtn.setTitle("Play", for: .normal)
            recordBtn.isEnabled = false
            }
    }
    
}

