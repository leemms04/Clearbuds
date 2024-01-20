//
//  ContentView.swift
//  Clearbuds
//
//  Created by Emma Lee on 1/19/24.
//

import SwiftUI
import AVKit

struct ContentView: View {
  @State var audioPlayer: AVAudioPlayer!
  var body: some View {
    ZStack {
      VStack {
        Text("Clearbuds").font(.system(size: 45)).font(.largeTitle)
        HStack {
          Spacer()
          Button(action: {
              self.audioPlayer.play()
          }) {
              Image(systemName: "play.circle.fill").resizable()
                  .frame(width: 70, height: 70)
                .aspectRatio(contentMode: .fit)
                  .foregroundColor(Color(red: 0.4627, green: 0.8392, blue: 1.0))
          }
          Spacer()
          Button(action: {
              self.audioPlayer.pause()
          }) {
              Image(systemName: "pause.circle.fill").resizable()
                  .frame(width: 70, height: 70)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(red: 0.4627, green: 0.8392, blue: 1.0))
          }
          Spacer()
        }
      }
    }
    .onAppear {
      let sound = Bundle.main.path(forResource: "song", ofType: "mp3")
      self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
    }
  }
}

#Preview {
  ContentView()
}
