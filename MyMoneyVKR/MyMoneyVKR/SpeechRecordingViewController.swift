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
    
    @IBOutlet weak var colorView: UIView!
    
    @IBAction func speechRecordingFunction(_ sender: Any) {
        if (colorView.backgroundColor == UIColor.red){
        colorView.backgroundColor = UIColor.green
        } else{
            colorView.backgroundColor = UIColor.red
        }
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
    var firstSpokenWordString = ""
    func chooseTheNeededMoneyController (spokenString: String){
        var correctSentence = spokenString
        
        //Finding the type(Plus or Minus)
        if let indexOfFirstSpace = spokenString.range(of: " ")?.lowerBound {
            if (indexOfFirstSpace != spokenString.index(after: spokenString.startIndex)){
                correctSentence = spokenString.substring(to: spokenString.index(after: spokenString.startIndex)) + " " + spokenString.substring(from: spokenString.index(after: spokenString.startIndex))
                print (correctSentence)
                if let indexOfCorrectFirstSpace = correctSentence.range(of: " ")?.lowerBound{
                    firstSpokenWordString = correctSentence.substring(to: (indexOfCorrectFirstSpace))
                }
            } else {
                firstSpokenWordString = spokenString.substring(to: (indexOfFirstSpace))
            }
            
        //Finding the amount of the money
            if let indexOfTheBeginningOfTheLastPart = correctSentence.range(of: " ")?.upperBound {
                let theLastPartOfThePhrase = correctSentence.substring(from: (indexOfTheBeginningOfTheLastPart))
                let indexOfSecondSpace = theLastPartOfThePhrase.range(of: " ")?.lowerBound
                let moneyAmount = theLastPartOfThePhrase.substring(to:(indexOfSecondSpace)!)
        //Finding the name of the money
                if let indexOfTheBeginningOfTheNamePart = theLastPartOfThePhrase.range(of: " ")?.upperBound {
                    let theNamePart = theLastPartOfThePhrase.substring(from: (indexOfTheBeginningOfTheNamePart))
                    if let theIndexOfNeededNamePart = theNamePart.range(of: " ")?.upperBound{
                        let theNeededNamePart = theNamePart.substring(from: (theIndexOfNeededNamePart))
            
                        switch firstSpokenWordString{
                        case "+":
                            let plusViewController = storyBoard.instantiateViewController(withIdentifier: "plusMoneyController") as! PlusMoneyViewController
                            self.present(plusViewController, animated: true, completion: nil)
                            plusViewController.amountOfPlusMoney.text = moneyAmount
                            plusViewController.nameOfPlusMoney.text = theNeededNamePart
                        default:
                            let minusViewController = storyBoard.instantiateViewController(withIdentifier: "minusMoneyController") as! MinusMoneyViewController
                            self.present(minusViewController, animated: true, completion: nil)
                            if (moneyAmount != "" && theNeededNamePart != ""){
                                minusViewController.amountOfMinusMoney.text = moneyAmount
                                minusViewController.nameOfMinusMoney.text = theNeededNamePart
                            }
                        }
                    }
                }
            }
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
            //var firstWordString: String = ""
            var bestString: String? = " "
            if result != nil {
                bestString = result?.bestTranscription.formattedString
                self.recognizedSpeech.text = bestString
                isFinal = (result?.isFinal)!
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.speechRecordingButton.isEnabled = true
                
                self.chooseTheNeededMoneyController(spokenString: self.recognizedSpeech.text)
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
