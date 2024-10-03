//
//  AudioPlayerNoLoginUserTVCell.swift
//  O2ChatWidget
//
//  Created by Sanjay Kumar on 27/06/2024.
//

import UIKit
import AVFoundation

class AudioPlayerNoLoginUserTVCell: UITableViewCell {
    
    
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var playerObserver: Any?
    var timer: Timer?
    private var isTogglingPlayPause = false

    
    var index : Int = 0
    var conversationArrayList: [ConversationsByUUID] = [ConversationsByUUID]()
    
    var isAudioDownloaded: Bool = false
    var localFileURL: URL? // Stores the URL of the downloaded file
    
    @IBOutlet weak var labelNamee: UILabel!
    @IBOutlet weak var ivFileStatus: UIImageView!
    @IBOutlet weak var lblTIme: UILabel!
    @IBOutlet weak var seekBarSlideer: UISlider!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var viewPlayer: UIView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let thumbSize = CGSize(width: 20, height: 20) // Set the desired thumb size
        let thumbImage = createThumbImage(size: thumbSize, color: .systemRed) // Customize color as needed
        seekBarSlideer.setThumbImage(thumbImage, for: .normal)
        // Initialization code
        seekBarSlideer.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(audioDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.viewPlayer.layer.backgroundColor = UIColor.bgMessage.cgColor
        self.viewPlayer.clipsToBounds = true
        self.viewPlayer.layer.cornerRadius = 5
    }
    
    func setTableData(conversationArrayList: [ConversationsByUUID], index: Int) {
        
        self.conversationArrayList = conversationArrayList
        self.index = index
        if let urlString = self.conversationArrayList[index].files?.first?.url, let url = URL(string: urlString) {
            self.localFileURL = getLocalFileURL(for: url)
            self.isAudioDownloaded = FileManager.default.fileExists(atPath: self.localFileURL?.path ?? "")
            if self.isAudioDownloaded {
                //ivFileStatus.image = UIImage(named: "completed") // Mark as downloaded
            } else {
                //ivFileStatus.image = UIImage(named: "not_downloaded") // Mark as not downloaded
            }
        }
    }
    
    
    
    @IBAction func actionPlayPause(_ sender: UIButton) {
        guard let tableView = self.superview as? UITableView else { return }
        guard let indexPath = tableView.indexPath(for: self) else { return }
        
        // Notify the parent view controller to handle stopping the previous audio
        NotificationCenter.default.post(name: .playNoLoginAudioTapped, object: self)
        // Notify the parent view controller to handle stopping the previous audio
        NotificationCenter.default.post(name: .playAudioTapped, object: self)
        if isAudioDownloaded, let localFileURL = localFileURL {
            if player == nil {  // Only configure the player once
                configurePlayer(with: localFileURL)
            }
            togglePlayPause()  // Toggle between play and pause
        } else {
            if let urlString = conversationArrayList[index].files?.first?.url, let url = URL(string: urlString) {
                downloadAudio(from: url) // Download the audio if not already downloaded
            }
        }
    }
    
    // Toggle play/pause and update button icon
    @objc func togglePlayPause() {
        guard let player = player else { return }
        // If player is playing, pause it
        if player.rate > 0 {
            player.pause()
            
            buttonPlay.setImage(loadImageFromPodBundle(named: "play2"), for: .normal)
            stopTimer()  // Stop UI updates like seek bar, etc.
        } else {
            // If player is paused or stopped, start playing
            player.play()
            buttonPlay.setImage(loadImageFromPodBundle(named: "pause2"), for: .normal)
            updateSlider()  // Start updating the UI (slider)
            startTimer()  // Start the timer for the seek bar
        }
        
      
    }
    
    func stopAudio() {
        // Pause the player if it's playing
        player?.pause()

        // Reset the UI
        buttonPlay.setImage(loadImageFromPodBundle(named: "play2"), for: .normal)
        stopTimer()
        seekBarSlideer.value = 0
        currentTimeLabel.text = "00:00"
        resetUI()
    }
    
    @objc private func sliderValueChanged() {
        if let duration = playerItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let seekValue = Float64(seekBarSlideer.value)
            let seekTime = CMTime(seconds: seekValue, preferredTimescale: 600)
            player?.seek(to: seekTime)
        }
    }
    
    // Start downloading the audio file
    func downloadAudio(from url: URL) {
        
        buttonPlay.setImage(loadImageFromPodBundle(named: "loading"), for: .normal)
        //ivFileStatus.image = UIImage(named: "loading") // Show a loading indicator

        let downloadTask = URLSession.shared.downloadTask(with: url) { [weak self] location, response, error in
            guard let self = self, error == nil, let location = location else {
                DispatchQueue.main.async {
                    //self?.ivFileStatus.image = UIImage(named: "error") // Show error
                }
                return
            }

            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            let destinationURL = documentsDirectory?.appendingPathComponent(url.lastPathComponent)

            do {
                if let destinationURL = destinationURL, fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                if let destinationURL = destinationURL {
                    try fileManager.moveItem(at: location, to: destinationURL)
                    DispatchQueue.main.async {
                        self.isAudioDownloaded = true
                        self.localFileURL = destinationURL
                        //self.ivFileStatus.image = UIImage(named: "completed") // Mark as completed
                        
                        // Configure player and play the audio
                        self.configurePlayer(with: destinationURL)
                        self.togglePlayPause() // Automatically play after download
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    //self.ivFileStatus.image = UIImage(named: "error") // Show error
                }
            }
        }

        downloadTask.resume()
    }
    
    func configurePlayer(with url: URL) {
        // Clean up any existing player
        if let observer = playerObserver {
            player?.removeTimeObserver(observer)
            playerObserver = nil
        }

        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        // Create a new AVPlayerItem with the downloaded file URL
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)

        // Add observer for when audio finishes playing
        NotificationCenter.default.addObserver(self, selector: #selector(audioDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)

        // Set up periodic observer for updating the seek bar
        playerObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { [weak self] time in
            self?.updateSlider()
        }
        
        // Initialize UI with the current duration if available
        if let duration = playerItem?.asset.duration.seconds, duration > 0 {
            seekBarSlideer.maximumValue = Float(duration)
            durationLabel.text = formatTime(seconds: duration)
        }
    }
    
    func configure(with url: URL, durationString: String?) {
        if let observer = playerObserver {
            player?.removeTimeObserver(observer)
            playerObserver = nil
        }
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        if let durationString = durationString, !durationString.isEmpty {
            let durationInSeconds = parseDuration(durationString: durationString)
            seekBarSlideer.maximumValue = Float(durationInSeconds)
            durationLabel.text = formatTime(seconds: durationInSeconds)
        } else {
            playerItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        }
        
        playerObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { [weak self] time in
            self?.updateSlider()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = playerItem?.duration.seconds, duration > 0.0 {
            seekBarSlideer.maximumValue = Float(duration)
            durationLabel.text = formatTime(seconds: duration)
        }
    }

    private func getLocalFileURL(for url: URL) -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return documentsDirectory?.appendingPathComponent(url.lastPathComponent)
    }
    
    func parseDuration(durationString: String) -> Double {
        let components = durationString.split(separator: ":")
        guard components.count == 2,
              let minutes = Double(components[0]),
              let seconds = Double(components[1]) else {
            return 0
        }
        return (minutes * 60) + seconds
    }
    
    @objc private func updateSlider() {
        guard let currentTime = player?.currentTime().seconds else { return }
        guard let duration = playerItem?.duration.seconds, duration > 0 else { return }
        
        let newValue = Float(currentTime)
        if seekBarSlideer.value != newValue {
            seekBarSlideer.value = newValue
            currentTimeLabel.text = formatTime(seconds: currentTime)
        }
    }
    
    
    @objc private func audioDidEnd() {
        resetUI()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func formatTime(seconds: Double) -> String {
        guard !seconds.isNaN && !seconds.isInfinite else {
            return "00:00"
        }
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    func resetUI() {
        player?.seek(to: .zero)
        player?.pause()
        buttonPlay.setImage(loadImageFromPodBundle(named: "play2"), for: .normal)
        seekBarSlideer.value = 0
        currentTimeLabel.text = "00:00"
        durationLabel.text = formatTime(seconds: playerItem?.duration.seconds ?? 0)
        stopTimer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetUI()
        if let observer = playerObserver {
            player?.removeTimeObserver(observer)
            playerObserver = nil
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    func createThumbImage(size: CGSize, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
    // Function to load an image from the pod's bundle
    func loadImageFromPodBundle(named imageName: String, ofType type: String) -> UIImage? {
        let bundle = Bundle(for: ChatViewController.self)
        if let imagePath = bundle.path(forResource: imageName, ofType: type) {
            return UIImage(contentsOfFile: imagePath)
        }
        return nil
    }

    // Alternative function using UIImage(named:in:compatibleWith:) initializer
    func loadImageFromPodBundle(named imageName: String) -> UIImage? {
        let bundle = Bundle(for: ChatViewController.self)
        return UIImage(named: imageName, in: bundle, compatibleWith: nil)
    }
    
    
}
