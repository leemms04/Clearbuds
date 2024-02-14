//
//  AudioManager.swift
//  Clearbuds
//
//  Created by Truong Le on 09/02/2024.
//


import SwiftUI
import AVFoundation
import Accelerate
/**
 This file create contains the AudioManager record audio and play loopback the audio.
 */
class AudioManager: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var player: AVAudioPlayer?

    override init() {
        super.init()
        setupAudioSession()
    }
    // Set up AudioSession
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // play and record allows speaker and mic to be on at the same time
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }
    // Set up Audio Recorder to record audio to filename.wav
    func setupAudioRecorder(filename: String) {
        // get the dir to filename in the current device
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(filename).wav")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 48000.0,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMIsNonInterleaved: true,
            AVLinearPCMBitDepthKey: 16
        ] as [String : Any]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.prepareToRecord()
            print("Set up filename successfully \(audioFilename)")
        } catch {
            print("Failed to set up audio recorder: \(error.localizedDescription)")
        }
    }
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func startRecording(filename: String) {
        setupAudioRecorder(filename: filename)
        audioRecorder?.record() // true
        playSound(filename: filename)
    }
    private func playSound(filename: String) {
        
        let url = getDocumentsDirectory().appendingPathComponent("\(filename).wav")
        // debug
        print("Filepath: \(url)")

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            print("Play audio")
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder.stop()
        player?.stop()
        print("Stop recording")
    }
    
}
