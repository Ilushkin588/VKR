//
//  SpeechRecordingViewController.swift
//  MyMoneyVKR
//
//  Created by IlyaDenisov on 28.04.17.
//  Copyright © 2017 Denisov's. All rights reserved.
//

import UIKit
import Speech




class SpeechRecordingViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var speechRecordingButton: UIButton!
    @IBOutlet weak var recognizedSpeech: UITextView!
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ru-RU"))
    private var recognitionRequest:SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        
        speechRecordingButton.isEnabled = false
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
        var isButtonEnabled = false
            switch authStatus{
            case .authorized:
                isButtonEnabled = true
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
            }
            OperationQueue.main.addOperation() {
                self.speechRecordingButton.isEnabled = isButtonEnabled
            }
        
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func speechRecordingFunction(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            speechRecordingButton.isEnabled = false
         //   speechRecordingButton.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
            //speechRecordingButton.setTitle("Stop Recording", for: .normal)
        }

        
    }
    
    func chooseTheNeededMoneyController (firstSpokenWordString: String){
        sleep(4)
        switch firstSpokenWordString{
        case "+":
            let plusViewController = storyBoard.instantiateViewController(withIdentifier: "plusMoneyController") as! PlusMoneyViewController
        
            self.present(plusViewController, animated: true, completion: nil)
            
        //case "минус":
        default:
            let minusViewController = storyBoard.instantiateViewController(withIdentifier: "minusMoneyController") as! MinusMoneyViewController
            self.present(minusViewController, animated: true, completion: nil)
        }
    }


    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            var firstWordString: String = ""
            var bestString: String?
            if result != nil {
                bestString = result?.bestTranscription.formattedString
                self.recognizedSpeech.text = bestString
                isFinal = (result?.isFinal)!
//                if let indexOfFirstSpace = bestString?.range(of: " ")?.lowerBound {
//                    print("kek")
//                    firstWordString = (bestString?.substring(to: indexOfFirstSpace))!
//                   // self.chooseTheNeededMoneyController(firstSpokenWordString: firstWordString)
//                } else{
//                    print ("nihua")
//                    //firstWordString = (bestString?.substring(to: indexOfFirstSpace!))!
//                }
//            self.chooseTheNeededMoneyController(firstSpokenWordString: firstWordString)
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.speechRecordingButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        recognizedSpeech.text = "Можете начинать говорить!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            speechRecordingButton.isEnabled = true
        } else {
            speechRecordingButton.isEnabled = false
        }
    }
  
   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
