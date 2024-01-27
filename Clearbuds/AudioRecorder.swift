//
//  AudioRecord.swift
//  Clearbuds
//
//  Created by Truong Le on 25/01/2024.
//

import AVFoundation

class AudioRecorder: ObservableObject {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?

    init() {
        setupAudioRecorder()
    }

    func startRecording() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)

            audioRecorder?.record()
        } catch {
            print("Error starting recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
    }

    func playRecording() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getDocumentsDirectory().appendingPathComponent("recording.wav"))
            audioPlayer?.play()
        } catch {
            print("Error playing recording: \(error.localizedDescription)")
        }
    }

    private func setupAudioRecorder() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.prepareToRecord()
        } catch {
            print("Error setting up audio recorder: \(error.localizedDescription)")
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

