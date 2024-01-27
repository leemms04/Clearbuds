//
//  ContentView.swift
//  Clearbuds
//
//  Created by Emma Lee on 1/19/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var audioRecorder: AudioRecorder?

    var body: some View {
        VStack {
            RecordButton(action: startRecording, label: "Start Recording")
            StopButton(action: stopRecording, label: "Stop Recording")
            PlayButton(action: playRecording, label: "Play Recording")
        }
        .onAppear {
            self.setupAudioSession()
        }
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error.localizedDescription)")
        }
    }

    private func startRecording() {
        audioRecorder = AudioRecorder()
        audioRecorder?.startRecording()
    }

    private func stopRecording() {
        audioRecorder?.stopRecording()
    }

    private func playRecording() {
        audioRecorder?.playRecording()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RecordButton: View {
    let action: () -> Void
    let label: String

    var body: some View {
        Button(action: action) {
            Text(label)
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StopButton: View {
    let action: () -> Void
    let label: String

    var body: some View {
        Button(action: action) {
            Text(label)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PlayButton: View {
    let action: () -> Void
    let label: String

    var body: some View {
        Button(action: action) {
            Text(label)
                .padding()
                .foregroundColor(.white)
                .background(Color.green)
                .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
