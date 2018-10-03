//
//  ViewController.swift
//  SampleListener
//
//  Created by apple on 21/09/2018.
//  Copyright © 2018 katol. All rights reserved.
//

import UIKit
import R5Streaming
import MBProgressHUD
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, R5StreamDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var shows : [Show] = [Show]()
    
    var show : Show!
    
    @IBOutlet weak var searchTextField : UITextField!
    @IBOutlet weak var searchButton : UIButton!

    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var playButton : UIButton!
    
    @IBOutlet weak var showsTableView : UITableView!
    
    //live
    var config: R5Configuration!
    var stream : R5Stream? = nil
    var currentView : R5VideoViewController? = nil

    //AVPlayer
    var player = AVPlayer()
    var timeObserver : Any!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            if #available(iOS 11.0, *) {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .longForm, options: [])
            } else if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            } else {
                // Compiler error: 'setCategory' is unavailable in Swift
                //try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            }
            
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        updatePreview()
    }
    
    @IBAction func searchClick (_ sender : UIButton) {
        if searchTextField.text == "" {
            show = nil
            updatePreview()
        } else {
            getShows(idArtist: searchTextField.text!)
        }
    }
    
    func updatePreview() {
        if show == nil {
            titleLabel.text = ""
            playButton.isEnabled = false
        } else {
            titleLabel.text = show.Tittle + "(" + show.FirstName + " " + show.LastName + "): " + show.Status
            playButton.isEnabled = true
        }
        
        self.showsTableView.reloadData()
    }
    
    //Request
    
    func getShows(idArtist : String) {
        
        if idArtist == "" {
            return
        }
        
        searchTextField.resignFirstResponder()
        self.view.endEditing(true)

        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = ["idArtist" : idArtist]
        
        RestClient.get(serviceName: REQUEST_SHOWS, parameters: params) { (responce: JSON?, error: NSError?) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if error != nil {
                print(error?.localizedDescription ?? String())
                self.show = nil
                self.updatePreview()
                return
            }
            else {
                print(responce!)
                if (responce?["status"].stringValue == "1") {
                    
                    self.shows = [Show]()
                    
                    for show in (responce?["data"]["shows"].arrayValue)! {
                        let showObject : Show = Show.build(json: show)!
                        self.shows.append(showObject)
                    }
                    
                    if self.shows.count == 0 {
                        self.show = nil
                        self.updatePreview()
                    }
                    self.showsTableView.reloadData()

                }
                else if (responce?["status"].stringValue == "0") {
                    print((responce?["message"].stringValue)!)
                    self.show = nil
                    self.updatePreview()
                }
            }
        }
    }

    
    //TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        }
        
        let show : Show = shows[indexPath.row]
        
        cell?.textLabel?.text = show.Tittle + ". Status: " + show.Status
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.show = shows[indexPath.row]
        
        updatePreview()
    }
    
    //TextFieldDelegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }

    //alert
    func showPlainAlert(title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let printSomething = UIAlertAction(title: "OK", style: .default) { _ in
        }
        alert.addAction(printSomething)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func playButtonClick(_ sender: Any) {
        
        if show.Status == "end" {
            self.playPauseRecorded()
        } else if show.Status == "live" {
            self.playPauseLive()
        }
        
    }

    //RD5ProStreaming
    
    func getConfig()->R5Configuration{
        // Set up the configuration
        let config = R5Configuration()
        config.host = s_STREAMING_HOST
        config.port = s_STREAMING_PORT
        config.protocol = 1
        config.buffer_time = 0.5
        config.contextName = "live"
        config.licenseKey = s_STREAMING_LICENCE
        return config
    }

    func setupDefaultR5VideoViewController() -> R5VideoViewController{
        
        let frame = CGRect(x: 0, y: 0, width: 1, height: 1)
        let r5View : R5VideoViewController = getNewR5VideoViewController(frame);
        self.addChild(r5View);
        view.addSubview(r5View.view)
        r5View.setFrame(self.view.bounds)
        r5View.showPreview(true)
        r5View.showDebugInfo(true)
        return r5View
    }
    
    func getNewR5VideoViewController(_ rect : CGRect) -> R5VideoViewController{
        
        let view : UIView = UIView(frame: rect)
        
        let r5View : R5VideoViewController = R5VideoViewController();
        r5View.view = view;
        r5View.view.backgroundColor = UIColor.clear
        r5View.view.center = self.view.center

        return r5View;
    }
    
    func playPauseLive() {
        
        if self.playButton.titleLabel?.text == "Play" {
            let otherAlert = UIAlertController(title: "Live", message: "Are you sure You want to close the current streaming?", preferredStyle: .alert)
            let printSomething = UIAlertAction(title: "Yes", style: .default) { _ in
                self.stop()
            }
            
            let dismiss = UIAlertAction(title: "No", style: .cancel) { _ in
            }
            
            // relate actions to controllers
            otherAlert.addAction(printSomething)
            otherAlert.addAction(dismiss)
            present(otherAlert, animated: true, completion: nil)
        }
        else{
            
            currentView = setupDefaultR5VideoViewController()
            
            let config = getConfig()
            // Set up the connection and stream
            let connection = R5Connection(config: config)
            self.stream = R5Stream(connection: connection)
            self.stream!.delegate = self
            self.stream?.client = self
            
            currentView?.attach(stream)
            self.stream!.play(show.idShow)
            
        }
        
    }
    
    
    func statusManager(_ notification: NSNotification) {
        updateUserInterface()
    }
    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            showPlainAlert(title: "", message: "Broadcast interrupted. Please, wait. We are trying to reconnect...")
            print("Broadcast interrupted. Please, wait. We are trying to reconnect...")
        case .wifi:
            print ("wi-fi");
        case .wwan:
            print ("wwan");
        }
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
        
    }
    
    func stop() {
        stream?.stop()
        stream?.delegate = nil
    }
    
    func playRecorded() {
        stream?.play(show.idShow + ".flv")
    }
    
    func onR5StreamStatus(_ stream: R5Stream!, withStatus statusCode: Int32, withMessage msg: String!) {
        //print(r5_string_for_status(statusCode))
        print(msg)
        if msg == "NetStream.Play.UnpublishNotify"{
            
            playButton.setTitle("Play", for: .normal)
            
            let alert = UIAlertController(title: "Alert!", message: "The live show is now ended", preferredStyle: .alert)
            
            let printSomething = UIAlertAction(title: "OK", style: .default) { _ in
                self.stop()
                self.playRecorded()
            }
            // relate actions to controllers
            alert.addAction(printSomething)
            present(alert, animated: true, completion: nil)
        }
        else if msg == "Disconnected"{
            playButton.setTitle("Play", for: .normal)
            playButton.isEnabled = false
            showPlainAlert(title: "", message: "Stream disconnected")
        }
        else if msg == "Error"{
            playButton.setTitle("Play", for: .normal)
            playButton.isEnabled = false
            showPlainAlert(title: "", message: "Server error")
        }
        else if msg == "Closed"{

            playButton.setTitle("Play", for: .normal)
            playButton.isEnabled = true
            showPlainAlert(title: "", message: "Stream closed")
        }
        else if msg == "Connected"{
            playButton.setTitle("Pause", for: .normal)
            playButton.isEnabled = true
            print("Stream connected")
            
        } else{
            playButton.setTitle("Pause", for: .normal)
            playButton.isEnabled = true
        }
    }

    
    /*
     * PLAY RECORDED
     */
    func playPauseRecorded() {
        
        if self.playButton.titleLabel?.text == "Play" {
            playButton.setTitle("Pause", for: .normal)
            self.doPlay()
        }
        else{
            playButton.setTitle("Play", for: .normal)
            self.player.pause()
        }
        
    }
    
    func doPlay() {
        
        let formatter = ISO8601DateFormatter()
        let string = formatter.string(from: Date())
        let now = formatter.date(from: string)
        let end = formatter.date(from: show.EndDate)
        
        let elapsed = now!.timeIntervalSince(end!)
        //let timePassed = Int(elapsed)
        
        let asset = AVURLAsset(url: NSURL(string: self.show.AudioStream)! as URL, options: nil)
        let audioDuration = asset.duration
        let audioDurationSeconds = CMTimeGetSeconds(audioDuration)
        
        let start = elapsed.truncatingRemainder(dividingBy: audioDurationSeconds)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.playerDidFinishPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
        
        self.timeObserver = self.player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            
            //self.trackTime()
            
            let nowstring = formatter.string(from: Date())
            let nowdate = formatter.date(from: nowstring)
            let enddate = formatter.date(from: self.show.EndDate!)
            
            let elapsed = nowdate!.timeIntervalSince(enddate!)
            let interv = Double(self.show.AvailTime)!*3600*24
            
            if (interv - elapsed) < 0 {
                self.player.pause();
                self.player.removeTimeObserver(self.timeObserver)
                self.showPlainAlert(title: "", message: "Show Translation Ended!")
            }
            
            
        }
        
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        self.player.seek(to: CMTimeMakeWithSeconds(start,preferredTimescale: 1000))
        self.player.play()
        
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        print("Audio Finished")
        self.player.seek(to: CMTime.zero)
        self.player.play()
    }

}

