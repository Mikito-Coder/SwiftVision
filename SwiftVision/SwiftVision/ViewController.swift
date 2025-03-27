//
//  ViewController.swift
//  SwiftVision
//
//  Created by Ifeoluwakiitan Ayandosu on 9/17/24.
//

import UIKit
import AVKit
import Vision

class ViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var detectionLabel: UILabel!
    var player: AVAudioPlayer?
    let apiKey = "sk_1ac34b0644c803661e0f042b024c60586bba0ccd4e3b5d40"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo //Makes it cropped not necessary to be honest
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        //Makes the caea show by adding the frame to the view controllers layer
        let previewlayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewlayer)
        previewlayer.frame = view.frame
        
        //Captures a Frame
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        
        detectionLabel = UILabel()
        detectionLabel.frame = CGRect(x: 20, y: 50, width: 300, height: 50)
        detectionLabel.textColor = .white
        detectionLabel.backgroundColor = .black.withAlphaComponent(0.6) // Transparentbackground
        detectionLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        detectionLabel.textAlignment = .center
        view.addSubview(detectionLabel)
        
    }
    //Method called once we get a frame
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //        print("Camera was able to capture a frame", Date())
        
        guard let pixelbuffer:CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        
        
        guard let model =  try? VNCoreMLModel(for: YOLOv3Int8LUT(configuration: MLModelConfiguration()).model) else {return}
        
        let request =  VNCoreMLRequest(model: model) { (finishedReq, error)  in
            
            if let error = error {
                print("Error processing the request: \(error)")
            } else {
                print("Finished processing the request")
            }
            
            
            
            
            guard let results = finishedReq.results as? [VNRecognizedObjectObservation] else {return}
            
            guard let firstObservation = results.first else {return}
            
            
            let objectName = firstObservation.labels.first?.identifier ?? "Unkown"
            let confidence = firstObservation.confidence
            
            //            print(firstObservation.labels.first?.identifier ?? "Unkown",firstObservation.confidence)
            
            
            // Update the detection label
            DispatchQueue.main.async {
                self.detectionLabel.text = "\(objectName) \(confidence)"
            }
                        
            // Call ElevenLabs API to get audio for object name
            self.getAudio(text: objectName)
            
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelbuffer, options: [:]).perform([request])
    }
    func getAudio(text: String) {
        let url = URL(string: "https://api.elevenlabs.io/v1/text-to-speech")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Set up the request body
        let body: [String: Any] = [
            "text": text,
            "voice_id": "pNInz6obpgDQGcFmaJgB",  // Adam pre-made voice
            "output_format": "mp3_22050_32",
            "model_id": "eleven_multilingual_v2",
            "voice_settings": [
                "stability": 0.0,
                "similarity_boost": 1.0,
                "style": 0.0,
                "use_speaker_boost": true
            ]
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        // Send the request to ElevenLabs
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching audio: \(error)")
                return
            }

            guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response or no data")
                return
            }

            print("HTTP Status Code: \(httpResponse.statusCode)")
            print("MIME Type: \(httpResponse.mimeType ?? "Unknown")")
            
            if httpResponse.statusCode == 200 && httpResponse.mimeType == "audio/mpeg" {
                self?.playAudio(data: data)
            } else {
                print("Received non-audio data or invalid response.")
            }
        }

        task.resume()
    }

    
    func playAudio(data: Data){
        do{
            player = try AVAudioPlayer(data: data)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
}
