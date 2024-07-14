//
//  DashboardBackgroundView.swift
//  Kimberlite
//
//  Created by Rania Rejdal on 2024-07-14.
//

import SwiftUI
import AVKit
import Combine

struct Component<Content: View>: View {
    
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack() {
            Text("")
                .font(.headline)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            content()
        }
        .frame(height: 1000)
    }
    
}

struct DashboardBackgroundView: View {
    
    private let queuePlayer: AVQueuePlayer!
        private let playerLooper: AVPlayerLooper!
        
        @StateObject private var playerStatusObserver: PlayerStatusObserver
        
        init(url: URL) {
            let playerItem = AVPlayerItem(url: url)
            self.queuePlayer = AVQueuePlayer(items: [playerItem])
            self.queuePlayer.isMuted = true
            self.playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)

            let observer = PlayerStatusObserver(player: queuePlayer)
            self._playerStatusObserver = StateObject(wrappedValue: observer)
        }
        var body: some View {
            VStack {
                switch playerStatusObserver.status {
                case .readyToPlay:
                    Component {
                        VideoPlayer(player: queuePlayer)
                            .disabled(true)
                            .aspectRatio(contentMode: .fill)
                            .overlay {
                                Color.black.opacity(0.2)
                            }
                    }
                case .failed:
                    Component {
                        Image("MorningSunny")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .overlay {
                                Color.black.opacity(0.2)
                            }
                    }
                default:
                    EmptyView()
                }
            }
            .task {
                self.queuePlayer.play()
            }
        }
}

#Preview {
    //If video is added to your project
    DashboardBackgroundView(url: Bundle.main.url(forResource: "MorningSunny", withExtension: "mp4")!)
    //If the video is in the cloud
    //DashboardBackgroundView(url: URL(string: "https://video-source.com/ocean.mp4")!)
}


// State handling
private final class PlayerStatusObserver: ObservableObject {
    @Published var status: AVPlayerItem.Status = .unknown
    
    private var player: AVQueuePlayer
    private var statusObservation: AnyCancellable?
    
    init(player: AVQueuePlayer) {
        self.player = player
        statusObservation = player.publisher(for: \.currentItem?.status)
            .receive(on: RunLoop.main)
            .sink { [weak self] status in
                withAnimation {
                    self?.status = status ?? .failed
                }
            }
    }
}
