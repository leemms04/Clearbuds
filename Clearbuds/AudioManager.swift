//
//  AudioManager.swift
//  Clearbuds
//
//  Created by Truong Le on 09/02/2024.
//


import SwiftUI
import AVFoundation
import Accelerate

class AudioManager: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var player: AVAudioPlayer?

    override init() {
        super.init()
        setupAudioRecorder(filename: "song")
    }
    func setupAudioRecorder(filename: String) {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try
                // play and record allows speaker and mic to be on at the same time
                audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: audioSession.mode, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            
            // creates file path to save audio file
            let url = NSURL(fileURLWithPath: getDocumentsDirectory().absoluteString).appendingPathComponent(filename)
            
            // settings, including the sampling rate of 48khz
            // # channels
            // bit depth (# bits used to encode each sample)
            let recordSettings:[String:Any] = [AVFormatIDKey:kAudioFormatLinearPCM,
                                               AVSampleRateKey:48000.0,
                                               AVNumberOfChannelsKey:1,
                                               AVLinearPCMIsNonInterleaved: true,
                                               AVLinearPCMBitDepthKey: 16]
            
            // initialize audio recorder and session
            try audioRecorder = AVAudioRecorder(url:url!, settings: recordSettings)
            audioRecorder?.prepareToRecord()


            
        }catch let error {
            print("ERROR")
            print(error.localizedDescription)
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func startRecording(filename: String) {
        do {
            audioRecorder.prepareToRecord()
            
            try audioSession.setActive(true)
            
            audioRecorder.record()
            
            // read audio file to be played
            guard let chirpurl = Bundle.main.url(forResource: "test", withExtension: "wav") else { return }
            
            player = try AVAudioPlayer(contentsOf: chirpurl, fileTypeHint: AVFileType.mp3.rawValue)
            
//            // sets the volume, make sure phone is not on silent mode and external volume switch has volume up
//            guard let player = player else { return }
//            player.volume=0.01
            
            player?.play()
            
//            // important, need to sleep main thread while speaker is playing, otherwise
//            // it will directly execute the next step without waiting for file to finish playing
//            sleep(1)
//            
//            audioRecorder.stop()
//            player.stop()
//            try audioSession.setActive(false)
        }catch let error {
            print("ERROR")
            print(error.localizedDescription)
        }
    }


    func stopRecording() {
        audioRecorder.stop()
        do {
            try audioSession.setActive(false)
        } catch let error {
            print("ERROR")
            print(error.localizedDescription)
        }
    }
    
}
