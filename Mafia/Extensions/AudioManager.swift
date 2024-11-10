//
//  AudioManager.swift
//  Mafia
//
//  Created by Beliy.Bear on 10.11.2024.
//


import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    var audioPlayer: AVAudioPlayer?
    
    private init() {
        setupAudioPlayer()
    }
    
    private func setupAudioPlayer() {
        if let audioFilePath = Bundle.main.path(forResource: "mafiaSong", ofType: "mp3") {
            let audioFileUrl = URL(fileURLWithPath: audioFilePath)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
                audioPlayer?.prepareToPlay()
                audioPlayer?.numberOfLoops = -1
            } catch {
                print("Ошибка при создании аудиоплеера: \(error.localizedDescription)")
            }
        } else {
            print("Не удалось найти файл аудио")
        }
    }
    
    func playAudio() {
        guard let player = audioPlayer, !player.isPlaying else { return }
        player.play()
        UserDefaults.standard.set(true, forKey: "musicState")
    }
    
    func stopAudio() {
        guard let player = audioPlayer, player.isPlaying else { return }
        player.stop()
        player.currentTime = 0
        UserDefaults.standard.set(false, forKey: "musicState")
    }
    
    func updateAudio() {
        let isPlaying = UserDefaults.standard.bool(forKey: "musicState")
        if isPlaying {
            playAudio()
        } else {
            stopAudio()
        }
    }
}
