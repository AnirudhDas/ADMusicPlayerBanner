//
//  ADMusicPlayerBanner.swift
//  ADMusicPlayerBanner
//
//  Created by Aniruddha Das on 1/24/17.
//  Copyright © 2017 Aniruddha Das. All rights reserved.
//

import UIKit
import MarqueeLabel
import AVFoundation
import SDWebImage

public class ADMusicPlayerBanner: UIViewController {
    
    var isFirstTime: Bool = false
    var shouldDisplay: Bool = false
    var miniPlayerViewFrameOriginal: CGRect?
    var index: Int? = 0
    weak var timer: Timer?
    var isStateEnlarged: Bool = false
    var currentlyPlayingSongIndex: Int = 0
    var deviceHeight: CGFloat?
    var deviceWidth: CGFloat?
    
    var songTitleArray: Array = [String]()
    var mp3SongUrlArray: Array = [String]()
    var songsThumbnailArray: Array = [String]()
    
    var currentTime: UILabel = UILabel()
    var albumArtImgView: UIImageView = UIImageView()
    var totalTime: UILabel = UILabel()
    var musicTitle: MarqueeLabel = MarqueeLabel()
    var downButton: UIButton = UIButton()
    var cancelButton: UIButton = UIButton()
    var playPauseButton: UIButton = UIButton()
    var prevButton: UIButton = UIButton()
    var nextButton: UIButton = UIButton()
    var loader: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var tblSongView = UITableView()
    
    var pauseImageName: UIImage? = UIImage()
    var playImageName: UIImage? = UIImage()
    var prevImageName: UIImage? = UIImage()
    var stopImageName: UIImage? = UIImage()
    var nextImageName: UIImage? = UIImage()
    var cancelImageName: UIImage? = UIImage()
    var downImageName: UIImage? = UIImage()
    var placeholderImgString: UIImage? = UIImage()
    
    var playerBackgroundColor: UIColor?
    var playerAlpha: CGFloat? = 1
    var musicTitleColor: UIColor?
    var tableViewBackgroundColor: UIColor?
    var tableViewCellBackgroundColor: UIColor?
    var tableViewCellLabelColor: UIColor?
    var tableViewCellLabelSelectedColor: UIColor?
    var timerLabelColor: UIColor?

    let originX: CGFloat = 0
    let originY: CGFloat = 0
    let originXMiniPlayer:CGFloat = 10
    let originYMiniPlayer:CGFloat = 10
    let labelHeightMiniPlayer:CGFloat = 30
    let imageWidthMiniPlayer: CGFloat = 80
    let imageHeightMiniPlayer: CGFloat = 80
    let miniPlayerHeight: CGFloat = 100
    let originXEnlargePlayer:CGFloat = 50
    let originYEnlargePlayer:CGFloat = 20
    let verticalSpacingEnlargePlayer:CGFloat = 20
    let labelHeightEnlargePlayer:CGFloat = 20
    let labelWidthEnlargePlayer:CGFloat = 60
    let buttonWidthEnlargePlayer:CGFloat = 40
    let buttonHeightEnlargePlayer:CGFloat = 40
    let downButtonWidthEnlargePlayer:CGFloat = 50
    let downButtonHeightEnlargePlayer:CGFloat = 30

    public func playSongAtIndex(index: Int) {
        self.cancelAction()
        self.shouldDisplay = true
        self.setIndex(index: index)
        self.playMusic()
    }
    
    public func setUpProperties(playerBackgroundColor: String, playerAlpha: CGFloat, musicTitleColor: String, tableViewBackgroundColor:String, tableViewCellBackgroundColor: String, tableViewCellLabelColor: String, tableViewCellLabelSelectedColor: String, timerLabelColor: String) {
        self.playerBackgroundColor = UIColor(hexString: playerBackgroundColor)
        self.playerAlpha = playerAlpha
        self.musicTitleColor = UIColor(hexString: musicTitleColor)
        self.tableViewBackgroundColor = UIColor(hexString: tableViewBackgroundColor)
        self.tableViewCellBackgroundColor = UIColor(hexString: tableViewCellBackgroundColor)
        self.tableViewCellLabelColor = UIColor(hexString: tableViewCellLabelColor)
        self.tableViewCellLabelSelectedColor = UIColor(hexString: tableViewCellLabelSelectedColor)
        self.timerLabelColor = UIColor(hexString: timerLabelColor)
        
        self.view.backgroundColor = self.playerBackgroundColor
        self.view.alpha = self.playerAlpha!
        self.musicTitle.textColor = self.musicTitleColor
        self.currentTime.textColor = self.timerLabelColor
        self.totalTime.textColor = self.timerLabelColor
    }

    public func setUpIcons(pauseImageName: UIImage, playImageName: UIImage, prevImageName: UIImage, nextImageName: UIImage, cancelImageName: UIImage, downImageName: UIImage, placeholderImgString: UIImage) {
        self.pauseImageName = pauseImageName
        self.playImageName = playImageName
        self.prevImageName = prevImageName
        self.nextImageName = nextImageName
        self.cancelImageName = cancelImageName
        self.downImageName = downImageName
        self.placeholderImgString = placeholderImgString
        
        self.prevButton.setBackgroundImage(self.prevImageName, for: UIControlState())
        self.nextButton.setBackgroundImage(self.nextImageName, for: UIControlState())
        self.cancelButton.setBackgroundImage(self.cancelImageName, for: UIControlState())
        self.downButton.setBackgroundImage(self.downImageName, for: UIControlState())
        self.albumArtImgView.image = self.placeholderImgString!
    }
    
    public func setUpArrays(songTitleArray: [String], mp3SongUrlArray: [String], songsThumbnailArray: [String]) {
        CustomAudioManager.shared.audios = mp3SongUrlArray
        self.songTitleArray = songTitleArray
        self.songsThumbnailArray = songsThumbnailArray
    }
    
    func setIndex(index: Int) {
        self.index = index
        self.currentlyPlayingSongIndex = index
    }
    
    func initialSetUp() {
        let screenSize: CGRect = UIScreen.main.bounds
        self.deviceWidth = screenSize.width
        self.deviceHeight = screenSize.height
        self.loader.hidesWhenStopped = true
        
        self.currentTime.textAlignment = .left
        self.totalTime.textAlignment = .right
        self.musicTitle.textAlignment = .center
        
        self.downButton.addTarget(self, action: #selector(self.downAction), for: UIControlEvents.touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(self.cancelAction), for: UIControlEvents.touchUpInside)
        self.playPauseButton.addTarget(self, action: #selector(self.playAction), for: UIControlEvents.touchUpInside)
        self.prevButton.addTarget(self, action: #selector(self.prevAction), for: UIControlEvents.touchUpInside)
        self.nextButton.addTarget(self, action: #selector(self.nextAction), for: UIControlEvents.touchUpInside)
        
        
        self.view.addSubview(currentTime)
        self.view.addSubview(albumArtImgView)
        self.view.addSubview(totalTime)
        self.view.addSubview(musicTitle)
        self.view.addSubview(downButton)
        self.view.addSubview(cancelButton)
        self.view.addSubview(playPauseButton)
        self.view.addSubview(prevButton)
        self.view.addSubview(nextButton)
        self.view.addSubview(loader)
        
        self.currentTime.isHidden = true
        self.totalTime.isHidden = true
        self.tblSongView.isHidden = true
    }
    
    func registerForGestures() {
        let upSwipeGuesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handlePan))
        upSwipeGuesture.direction = UISwipeGestureRecognizerDirection.up
        view.addGestureRecognizer(upSwipeGuesture)
        
        let downSwipeGuesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handlePan))
        downSwipeGuesture.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(downSwipeGuesture)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.isFirstTime = true
        self.initialSetUp()
        self.setMiniPlayerView()
        self.setupUI()
        self.registerForGestures()
    }
    
    
    func setMiniPlayerView() {
        
        self.downButton.isHidden = true
        
        self.setMiniView()
        
        self.musicTitle.frame = CGRect(x: self.prevButton.frame.origin.x, y: self.miniPlayerHeight - (self.originYMiniPlayer + labelHeightMiniPlayer), width: self.cancelButton.frame.origin.x + self.cancelButton.frame.size.width - self.prevButton.frame.origin.x, height: labelHeightMiniPlayer)
    }
    
    func setMiniView() {
        
        self.downButton.isHidden = true
        
        self.albumArtImgView.frame = CGRect(x: originXMiniPlayer, y: originYMiniPlayer, width: imageWidthMiniPlayer, height: imageHeightMiniPlayer)
        
        let buttonWidth:CGFloat = (self.view.frame.width - (self.albumArtImgView.frame.origin.x + self.albumArtImgView.frame.size.width)) / 9
        
        self.prevButton.frame = CGRect(x: self.albumArtImgView.frame.origin.x + self.albumArtImgView.frame.size.width + buttonWidth, y: self.albumArtImgView.frame.origin.y, width: buttonWidth, height: buttonWidth)
        
        self.playPauseButton.frame = CGRect(x: self.prevButton.frame.origin.x + self.prevButton.frame.size.width + buttonWidth, y: self.albumArtImgView.frame.origin.y, width: buttonWidth, height: buttonWidth)
        
        self.loader.frame = self.playPauseButton.frame
        
        self.nextButton.frame = CGRect(x: self.playPauseButton.frame.origin.x + self.playPauseButton.frame.size.width + buttonWidth, y: self.albumArtImgView.frame.origin.y, width: buttonWidth, height: buttonWidth)
        
        self.cancelButton.frame = CGRect(x: self.nextButton.frame.origin.x + self.nextButton.frame.size.width + buttonWidth, y: self.albumArtImgView.frame.origin.y, width: buttonWidth, height: buttonWidth)
        
    }
    
    func minimizeMusicPlayer() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
            
            self.view.frame = self.miniPlayerViewFrameOriginal!
            
            self.setMiniView()
            
        }, completion: { (Void) in
            self.musicTitle.frame = CGRect(x: self.prevButton.frame.origin.x, y: self.miniPlayerHeight - (self.originYMiniPlayer + self.labelHeightMiniPlayer), width: self.cancelButton.frame.origin.x + self.cancelButton.frame.size.width - self.prevButton.frame.origin.x, height: self.labelHeightMiniPlayer)
            
            self.cancelButton.isHidden = false
            self.currentTime.isHidden = true
            self.totalTime.isHidden = true
            self.downButton.isHidden = true
            self.tblSongView.isHidden = true
            print("Minimize complete")

        })
    }
    
    func enlargeMusicPlayer() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
            
            self.miniPlayerViewFrameOriginal = self.view.frame
            
            self.view.frame = CGRect(x: self.originX, y: self.originX , width: self.deviceWidth!, height: self.deviceHeight!)
            
            self.downButton.frame = CGRect(x: (self.view.frame.size.width / 2) - (self.downButtonWidthEnlargePlayer / 2), y: self.originYEnlargePlayer , width: self.downButtonWidthEnlargePlayer, height: self.downButtonHeightEnlargePlayer)
            
            let AlbumArtWidth: CGFloat = (self.view.frame.size.width - ((self.originXEnlargePlayer) * 2)) / 1.5
            
            self.albumArtImgView.frame = CGRect(x: (self.view.frame.size.width / 2) - (AlbumArtWidth / 2), y: self.downButton.frame.origin.y + self.downButton.frame.size.height + self.verticalSpacingEnlargePlayer, width: AlbumArtWidth, height: AlbumArtWidth)
            
            self.musicTitle.frame = CGRect(x: self.originXEnlargePlayer, y: self.albumArtImgView.frame.origin.y + self.albumArtImgView.frame.size.height + self.verticalSpacingEnlargePlayer, width: self.view.frame.size.width - (self.originXEnlargePlayer * 2), height: self.labelHeightEnlargePlayer)
            
            self.currentTime.frame = CGRect(x: self.originXEnlargePlayer, y: self.musicTitle.frame.origin.y + self.musicTitle.frame.size.height + self.verticalSpacingEnlargePlayer, width: self.labelWidthEnlargePlayer, height: self.labelHeightEnlargePlayer)
            
            self.totalTime.frame = CGRect(x: self.view.frame.size.width - self.originXEnlargePlayer - self.labelWidthEnlargePlayer, y: self.musicTitle.frame.origin.y + self.musicTitle.frame.size.height + self.verticalSpacingEnlargePlayer, width: self.labelWidthEnlargePlayer, height: self.labelHeightEnlargePlayer)
            
            self.prevButton.frame = CGRect(x: self.originXEnlargePlayer, y: self.currentTime.frame.origin.y + self.currentTime.frame.size.height + self.verticalSpacingEnlargePlayer, width: self.buttonWidthEnlargePlayer, height: self.buttonHeightEnlargePlayer)
            
            self.playPauseButton.frame = CGRect(x: (self.view.frame.size.width / 2) - (self.buttonWidthEnlargePlayer / 2), y: self.currentTime.frame.origin.y + self.currentTime.frame.size.height + self.verticalSpacingEnlargePlayer, width: self.buttonWidthEnlargePlayer, height: self.buttonHeightEnlargePlayer)
            
            self.loader.frame = self.playPauseButton.frame
            
            self.nextButton.frame = CGRect(x: self.view.frame.size.width - self.originXEnlargePlayer - self.buttonWidthEnlargePlayer, y: self.currentTime.frame.origin.y + self.currentTime.frame.size.height + self.verticalSpacingEnlargePlayer, width: self.buttonWidthEnlargePlayer, height: self.buttonHeightEnlargePlayer)
            
            
            let heightOfTableView: CGFloat =  self.view.frame.size.height - (self.nextButton.frame.origin.y + self.nextButton.frame.size.height + self.verticalSpacingEnlargePlayer)
            self.tblSongView = UITableView(frame: CGRect(x: self.originX, y: self.nextButton.frame.origin.y + (self.nextButton.frame.size.height + self.verticalSpacingEnlargePlayer), width: self.view.frame.size.width, height: heightOfTableView))
            self.tblSongView.backgroundColor = self.tableViewBackgroundColor
            
            self.tblSongView.dataSource = self
            self.tblSongView.delegate = self
            self.tblSongView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            self.view.addSubview(self.tblSongView)
            
            
            if self.index != nil {
                let indexPath = IndexPath(item: self.index!, section: 0)
                    
                    if self.isStateEnlarged {
                        self.tblSongView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.top)
                        self.tblSongView.reloadData()
                    }
                
            }
            
            
        }, completion: { (Void) in
            self.cancelButton.isHidden = true
            self.currentTime.isHidden = false
            self.totalTime.isHidden = false
            self.downButton.isHidden = false
            self.tblSongView.isHidden = false
            print("Maximize complete")

        })
    }
    
    func handlePan(gestureRecognizer: UISwipeGestureRecognizer) {
        switch gestureRecognizer.direction {
        case UISwipeGestureRecognizerDirection.left: break
            
        case UISwipeGestureRecognizerDirection.right: break
            
        case UISwipeGestureRecognizerDirection.up:
            self.isStateEnlarged = true
            self.enlargeMusicPlayer()
            
        case UISwipeGestureRecognizerDirection.down:
            self.isStateEnlarged = false
            self.minimizeMusicPlayer()
            
        default: break

        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // register for did become active to update play pause icon
        NotificationCenter.default.addObserver(self, selector: #selector(self.didBecomeActive), name:
            NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        self.setMiniPlayerView()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // ungister for did become active to update play pause icon
        NotificationCenter.default.removeObserver(self)
    }
    /**
     Update the play pause icon based on the music player state
     */
    func didBecomeActive() {
        if CustomAudioManager.shared.playerStatus == .Playing {
            playPauseButton.setBackgroundImage(self.pauseImageName, for: UIControlState())
        } else if CustomAudioManager.shared.playerStatus == .Paused {
            playPauseButton.setBackgroundImage(self.playImageName!, for: UIControlState())
        }
    }
    
    
    func downAction() {
        
        self.minimizeMusicPlayer()
    }
    
    func playAction() {
        
        self.playingAction()
    }
    
    func playingAction() {
        if self.playPauseButton.backgroundImage(for: UIControlState()) == self.pauseImageName! {
            CustomAudioManager.shared.actionPauseAudio()
            setupUI()
        } else {
            self.playPauseButton.isHidden = true
            self.setLabelAndImage()
            self.loader.startAnimating()
            setupUI()
            CustomAudioManager.shared.actionPlayAudio(60, index: self.index!, handler: { (hasErrors: Bool) in
                self.loader.stopAnimating()
                self.playPauseButton.isHidden = false
                self.startTimer()
                self.setupUI()
                if hasErrors == true {
                    self.showErrorMessage(title: "Message", message: "Error playing audio.", viewController: self)
                }
            })
        }
    }
    
    func setLabelAndImage() {
        if self.index != nil {
            musicTitle.text = self.songTitleArray[self.index!]
            self.albumArtImgView.sd_setImage(with: URL(string: self.songsThumbnailArray[self.index!]), placeholderImage: self.placeholderImgString!, options: [.continueInBackground, .progressiveDownload])
        }
    }
    
    func tableViewPlayingAction() {
        self.setLabelAndImage()
        CustomAudioManager.shared.actionPauseAudio()
        resetUI()
        self.playPauseButton.isHidden = true
        self.loader.startAnimating()
        setupUI()
        CustomAudioManager.shared.actionPlayAudio(60, index: self.index!, handler: { (hasErrors: Bool) in
            self.loader.stopAnimating()
            self.playPauseButton.isHidden = false
            self.startTimer()
            self.setupUI()
            if hasErrors == true {
                self.showErrorMessage(title: "Message", message: "Error playing audio.", viewController: self)
            }
        })
    }
    
    func prevAction() {
        if let index = self.index {
            self.index = index - 1
            self.currentlyPlayingSongIndex = self.index!
            let indexPath = IndexPath(item: self.index!, section: 0)
            self.setLabelAndImage()
            self.loader.startAnimating()
            setupUI()
            stopTimer()
            resetUI()
            self.playPauseButton.isHidden = true
            CustomAudioManager.shared.actionPreviousAudio(60) { (hasErrors: Bool) in
                self.loader.stopAnimating()
                self.startTimer()
                self.playPauseButton.isHidden = false
                self.setupUI()
                
                if self.isStateEnlarged {
                    self.tblSongView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.top)
                    self.tblSongView.reloadData()
                }
                
                if hasErrors == true {
                    self.showErrorMessage(title: "Message", message: "Error playing audio.", viewController: self)
                }
            }
        }
    }
    
    func setupUI() {
        
        self.albumArtImgView.layer.cornerRadius = 10.0
        self.albumArtImgView.clipsToBounds = true
        
        if let index = self.index {
            
            if CustomAudioManager.shared.playerStatus == .Playing {
                playPauseButton.setBackgroundImage(self.pauseImageName!, for: UIControlState())
            } else if CustomAudioManager.shared.playerStatus == .Paused {
                playPauseButton.setBackgroundImage(self.playImageName!, for: UIControlState())
            } else if CustomAudioManager.shared.playerStatus == .Unknown {
                playPauseButton.setBackgroundImage(self.playImageName!, for: UIControlState())
            }
            
            if index == 0 {
                prevButton.isEnabled = false
                prevButton.alpha = 0.5
            } else {
                prevButton.isEnabled = true
                prevButton.alpha = 1.0
            }
            if index == CustomAudioManager.shared.audios.count-1 {
                nextButton.isEnabled = false
                nextButton.alpha = 0.5
            } else {
                nextButton.isEnabled = true
                nextButton.alpha = 1.0
            }
        }
    }
    
    func updateTimerLabel() {
        let currentTimeSec = Int(CustomAudioManager.shared.playerAudioCurrentTime)
        let totalTimeSec = Int(CustomAudioManager.shared.playerAudioDuration)
        let cTimeMin = Int(totalTimeSec / 60)
        let cTimeSec = totalTimeSec - (cTimeMin * 60)
        let kTimeMin = Int(currentTimeSec / 60)
        let kTimeSec = currentTimeSec - (kTimeMin * 60)
        currentTime.text = "\(String(format: "%02d", kTimeMin)):\(String(format: "%02d", kTimeSec))"
        totalTime.text = "\(String(format: "%02d", cTimeMin)):\(String(format: "%02d", cTimeSec))"
    }

    func startTimer() {
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ADMusicPlayerBanner.updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        resetUI()
    }
    
    func resetUI() {
        currentTime.text = "00:00"
        totalTime.text = "00:00"
    }
    
    func nextAction() {
        if let index = self.index {
            self.index = index + 1
            self.currentlyPlayingSongIndex = self.index!
            let indexPath = IndexPath(item: self.index!, section: 0)
            self.setLabelAndImage()
            self.loader.startAnimating()
            setupUI()
            stopTimer()
            resetUI()
            self.playPauseButton.isHidden = true
            
            CustomAudioManager.shared.actionNextAudio(60) { (hasErrors: Bool) in
                self.loader.stopAnimating()
                self.startTimer()
                self.playPauseButton.isHidden = false
                self.setupUI()
                
                
                if self.isStateEnlarged {
                    self.tblSongView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.top)
                    self.tblSongView.reloadData()
                }
                
                if hasErrors == true {
                    self.showErrorMessage(title: "Message", message: "Error playing audio.", viewController: self)
                }
            }
        }
    }
    
    func cancelAction() {
        CustomAudioManager.shared.cleanAudioPlayer()
        self.stopTimer()
        self.shouldDisplay = false
        self.isFirstTime = true
        playPauseButton.setBackgroundImage(self.playImageName!, for: UIControlState())
        self.view.removeFromSuperview()
        
    }
    
    public func playMusic() {
        if self.isFirstTime {
            
            self.isFirstTime = false
            self.playingAction()
        }
    }
    
}

extension ADMusicPlayerBanner: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songTitleArray.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.songTitleArray[indexPath.row]
        cell.backgroundColor = self.tableViewCellBackgroundColor
        if self.currentlyPlayingSongIndex == indexPath.row {
            cell.textLabel?.textColor = self.tableViewCellLabelSelectedColor
        } else {
            cell.textLabel?.textColor = self.tableViewCellLabelColor
        }
        return cell
    }
    
    public func showMusicPlayerInView(forView: String, viewController: UIViewController) {
        
        switch forView {
        case "TabBar":
            let window = UIApplication.shared.keyWindow
            if let tabCtr = window?.rootViewController as? UITabBarController {
                if tabCtr.view.subviews.contains(self.view) == false {
                    //if tab bar does not have music player
                    if self.shouldDisplay == true {
                        self.view.removeFromSuperview()
                        let tabBarY = (viewController.tabBarController?.tabBar.frame.size.height)! + miniPlayerHeight
                        self.view.frame = CGRect(x: originX, y: tabCtr.view.frame.size.height - tabBarY, width: tabCtr.view.frame.size.width, height: miniPlayerHeight)
                        
                        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
                            tabCtr.view.addSubview(self.view)
                        }, completion: { (Void) in
                            print("showMusicPlayerInTabBarCtrcompletion")
                        })
                    }
                }
            }
        case "SearchBar":
            if viewController.view.subviews.contains(self.view) == false {
                if self.shouldDisplay == true {
                    self.view.removeFromSuperview()
                    self.view.frame = CGRect(x: originX, y: viewController.view.frame.size.height - miniPlayerHeight, width: viewController.view.frame.size.width, height: miniPlayerHeight)
                    UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
                        viewController.view.addSubview(self.view)
                    }, completion: { (Void) in
                        print("showMusicPlayerInSearchControllercompletion")
                    })
                }
            }
        default:
            break
        }
        
    }
    
    
}

extension ADMusicPlayerBanner: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Podcast selected at \(indexPath.row)")
        if indexPath.row == self.currentlyPlayingSongIndex {
            
        } else {
            self.currentlyPlayingSongIndex = indexPath.row
            self.index = self.currentlyPlayingSongIndex
            self.tableViewPlayingAction()
        }
        self.tblSongView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.top)
        self.tblSongView.reloadData()
    }
}

extension ADMusicPlayerBanner {
    func showErrorMessage(title: String,
                          message: String,
                          viewController: UIViewController) {
        let ac = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: UIAlertControllerStyle.alert)
        
        let handler = { (action: UIAlertAction) -> Void in
            ac.dismiss(animated: true, completion: nil)
        }
        let acAction = UIAlertAction(title: NSLocalizedString("Okay", comment: "Okay"),
                                     style: UIAlertActionStyle.default,
                                     handler: handler)
        ac.addAction(acAction)
        viewController.present(ac, animated: true, completion: nil)
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let scanner  = Scanner(string: hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}
