//
//  RecordedPlayView.swift
//  ArtistPodcast
//
//  Created by apple on 22.11.2019.
//  Copyright © 2019 com.livestreamtonight. All rights reserved.
//

import UIKit
import AVFoundation

class RecordedPlayView: UIView {

    var timer : Timer!

    //player
    public enum Repeat {
        case once
        case loop
    }
    
    public var `repeat`: Repeat = .once
    
    override open class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    private var playerLayer: AVPlayerLayer {
        return self.layer as! AVPlayerLayer
    }

    public var player: AVPlayer? {
        get {
            self.playerLayer.player
        }
        set {
            self.playerLayer.player = newValue
        }
    }
    
    open override var contentMode: UIView.ContentMode {
        didSet {
            switch self.contentMode {
            case .scaleAspectFit:
                self.playerLayer.videoGravity = .resizeAspect
            case .scaleAspectFill:
                self.playerLayer.videoGravity = .resizeAspectFill
            default:
                self.playerLayer.videoGravity = .resize
            }
        }
    }
    
    public var url: URL? {
        didSet {
            guard let url = self.url else {
                self.teardown()
                return
            }
            self.setup(url: url)
        }
    }
    
    //vars
    var playhead: String = "00:00 / 00:00" {
        didSet {
            playHeadLabel.text = playhead
        }
    }
    
    //lazy UI vars
    lazy var playHeadLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        label.textAlignment = .center
        label.textColor = Theme.colorTextBase
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var playPauseButton: UIButton = {
        let button: UIButton = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        let icon: UIImage = getSVGImage(name: "play-aired")
        let iconSelected: UIImage = getSVGImage(name: "pause-white-pressed")
        button.setImage(icon, for: .normal)
        button.setImage(iconSelected, for: .selected)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.playPausekTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var backgroundView: UIImageView = {
        let view: UIImageView = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
//        let image: UIImage = getSVGImage(name: "play-background")
        let image: UIImage = UIImage(named: "play-bg")!
        view.image = image
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    //init
    override init(frame: CGRect) {
      super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.teardown()
    }

    //public
    public func initialize() {
        
        addSubview(playHeadLabel)
        NSLayoutConstraint.activate([
            playHeadLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: defaultNavButtonPadding / 2),
            playHeadLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            playHeadLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            playHeadLabel.heightAnchor.constraint(equalToConstant: floatLabelHeight),
        ])

        addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.playHeadLabel.bottomAnchor, constant: defaultNavButtonPadding / 2),
            backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: sizePlayBackground.width),
            backgroundView.heightAnchor.constraint(equalToConstant: sizePlayBackground.height),
        ])

        addSubview(playPauseButton)
        NSLayoutConstraint.activate([
            playPauseButton.topAnchor.constraint(equalTo: self.playHeadLabel.bottomAnchor, constant: defaultNavButtonPadding / 2 + 10),
            playPauseButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: sizePlayButton.width),
            playPauseButton.heightAnchor.constraint(equalToConstant: sizePlayButton.height),
        ])

        backgroundColor = .clear
        playhead = "00:00 / 00:00"

    }
    
    //click handlers
    @objc public func playPausekTapped(_ sender: UIButton) {
        print("play/pause")
        if (self.player?.isPlaying)! {
            pause()
        } else {
            play()
        }
    }
    
    private func pause() {
        self.player?.pause()
        trackTime()
        switchTimer(flag: false)
        updateButton()
    }
    
    private func play() {
        self.player?.play()
        trackTime()
        switchTimer(flag: true)
        updateButton()
    }
    
    //player private functions
    private func teardown() {
        
        pause()

        self.player?.currentItem?.removeObserver(self, forKeyPath: "status")
        
        self.player?.removeObserver(self, forKeyPath: "rate")
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemDidPlayToEndTime,
                                                  object: self.player?.currentItem)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemFailedToPlayToEndTime,
                                                  object: self.player?.currentItem)
                                                  
        self.player = nil
    }
    
    private func setup(url: URL) {
        
        self.player = AVPlayer(playerItem: AVPlayerItem(url: url))
        
        self.player?.currentItem?.addObserver(self,
                                              forKeyPath: "status",
                                              options: [.old, .new],
                                              context: nil)
        
//        self.player?.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)

        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.itemDidPlayToEndTime(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player?.currentItem)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.itemFailedToPlayToEndTime(_:)),
                                               name: .AVPlayerItemFailedToPlayToEndTime,
                                               object: self.player?.currentItem)
        
        self.player?.pause()
        trackTime()

    }

    @objc func itemDidPlayToEndTime(_ notification: NSNotification) {
        guard self.repeat == .loop else {
            return
        }
        self.player?.seek(to: .zero)
        self.player?.play()
        switchTimer(flag: true)
        updateButton()
    }
    
    @objc func itemFailedToPlayToEndTime(_ notification: NSNotification) {
        self.teardown()
    }
    
    
    open override func observeValue(forKeyPath keyPath: String?,
                                          of object: Any?,
                                          change: [NSKeyValueChangeKey : Any]?,
                                          context: UnsafeMutableRawPointer?) {
        if keyPath == "status", let status = self.player?.currentItem?.status, status == .failed {
            self.teardown()
        }

        if
            keyPath == "rate",
            let player = self.player,
            player.rate == 0,
            let item = player.currentItem,
            !item.isPlaybackBufferEmpty,
            CMTimeGetSeconds(item.duration) != CMTimeGetSeconds(player.currentTime())
        {
            //self.player?.play()
            pause()
        }
    }
    
    //
    
    private func switchTimer(flag: Bool) {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        if flag {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateProgress(){
        trackTime()
    }

    private func trackTime() {
        if let currentItem = self.player?.currentItem {
            // Get the current time in seconds
            let playheadTime = currentItem.currentTime().seconds
            let duration : CMTime = currentItem.asset.duration
//            let seconds : Float64 = CMTimeGetSeconds(duration)

            let durationSeconds = CMTimeGetSeconds(duration)

            // Format seconds for human readable string
            let playheadString = Helper.formatTimeFor(seconds: playheadTime)
            let durationString = Helper.formatTimeFor(seconds: durationSeconds)
            
            playhead = playheadString + "/" + durationString
            
            if durationSeconds > 0 && playheadTime >= durationSeconds {
                switchTimer(flag: false)
                self.player?.seek(to: .zero)
                self.player?.play()
            }

        }
    }
    
    private func updateButton () {
        let icon: UIImage = getSVGImage(name: "play-aired")
        let iconSelected: UIImage = getSVGImage(name: "pause-white-pressed")

        if player!.isPlaying {
            playPauseButton.setImage(iconSelected, for: .normal)
        } else {
            playPauseButton.setImage(icon, for: .normal)
        }
    }


}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

