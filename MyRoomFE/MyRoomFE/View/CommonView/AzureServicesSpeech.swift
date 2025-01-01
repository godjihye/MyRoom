//
//  AzureServicesSpeech.swift
//  MyRoomFE
//
//  Created by 이수정 on 1/1/25.
//

import SwiftUI

struct AzureServicesSpeech: View {
    @State var STTResult:String = "";
    
    var body: some View {
        
        Button {
            if let audioFilePath = Bundle.main.path(forResource: "STT_test", ofType: "wav") {
                speechToText(audioFilePath: audioFilePath) { recognizedText in
                    if let text = recognizedText {
                        STTResult = text
                        print("STTResult :  \(STTResult)")
                    } else {
                        print("Failed to recognize speech.")
                    }
                }
            } else {
                print("Audio file not found in bundle.")
            }
        } label: {
            Image(systemName: "waveform.circle.fill")
                .resizable()
                .frame(width: 50,height: 50)
        }

        
    }
}


func speechToText(audioFilePath: String, completion: @escaping (String?) -> Void) {
    let subscriptionKey = "C5dhNbamma1bsipQKUsFl3Yum1JutdQdf5cUvP6du9MZ03Y1kfqyJQQJ99BAACNns7RXJ3w3AAAAACOGMjAC"
    let region = "koreacentral"
    let url = URL(string: "https://koreacentral.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=ko-KR")!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue(subscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
    request.addValue("application/octet-stream", forHTTPHeaderField: "Content-Type")

    let audioData = try! Data(contentsOf: URL(fileURLWithPath: audioFilePath))
    request.httpBody = audioData

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print("Error:", error?.localizedDescription ?? "Unknown error")
            return
        }

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            if let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let displayText = result["DisplayText"] as? String {
                completion(displayText)
            }
            
        } else {
            print("Failed with response: \(response.debugDescription)")
            completion(nil)
        }
    }
    
    task.resume()
    
}



#Preview {
//    AzureServicesSpeech()
}
