//
//  EmoResultView.swift
//  SpeechAI
//
//  Created by Heical Chandra on 19/06/24.
//

import SwiftUI
import GoogleGenerativeAI
import DotLottie

struct CustomSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 6)
                    .foregroundColor(.biruMuda)
                
                Rectangle()
                    .frame(width: CGFloat((self.value - self.range.lowerBound) / (self.range.upperBound - self.range.lowerBound)) * geometry.size.width, height: 6)
                    .foregroundColor(.biruTuaSlider)
                
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .offset(x: CGFloat((self.value - self.range.lowerBound) / (self.range.upperBound - self.range.lowerBound)) * geometry.size.width - 10)
                    .gesture(DragGesture()
                        .onChanged { gesture in
                            let newValue = Double(gesture.location.x / geometry.size.width) * (self.range.upperBound - self.range.lowerBound) + self.range.lowerBound
                            self.value = min(max(self.range.lowerBound, newValue), self.range.upperBound)
                        }
                    )
            }
            .cornerRadius(3)
        }
        .frame(height: 20)
    }
}

struct EmoResultView: View {
    let jurnal: String
    @State private var sliderValue: Double = 7.0
    @State private var prompt = ""
    @State private var emotion = ""
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)

    var body: some View {
        NavigationStack{
        if !emotion.isEmpty{
            VStack{
                Text("You are feeling..")
                    .bold()
                    .multilineTextAlignment(.center)
                    .font(.title3)
                Text(emotion)
                    .bold()
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .padding()
                DotLottieAnimation(
                    fileName: emotion == "Sad" ? "nangis-2" : (emotion == "Angry" ? "Marah-2" : "cemas-2"),
                    config: AnimationConfig(autoplay: true, loop: true)
                )
                .view()
                .frame(width: 300, height: 300)
                .padding()

                Text("How accurate is this?")
                    .bold()
                    .multilineTextAlignment(.center)
                    .font(.title3)
                VStack{
                    CustomSlider(value: $sliderValue, range: 0...10, step: 1)
                    .padding(.horizontal)
                    HStack {
                        ForEach(0...10, id: \.self) { value in
                            VStack {
                                Rectangle()
                                    .frame(width: 1, height: 10)
                                    .foregroundColor(.gray)
                                Text("\(value)")
                                    .font(.caption)
                                    .opacity(![1, 3, 5, 7, 9].contains(value) ? 1 : 0)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
                Spacer()
                VStack {
                    NavigationLink(destination: ContentView()){
                        Text("Next")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.biruTuaSlider)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                .frame(maxWidth: .infinity)
                    HStack{
                        Rectangle()
                            .fill(Color.abu)
                            .frame(width: 35,height: 5)
                            .cornerRadius(25)
                        Rectangle()
                            .fill(Color.biruTuaSlider)
                            .frame(width: 35,height: 5)
                            .cornerRadius(25)
                    }
                    .padding(5)
                }
                .padding()
            }
        } else {
            LoadingView()
                .onAppear{
                    analyze()
                }
        }
    }
}
    
    private func analyze(){
        prompt = "in this journal shows what emotions *answers only 1 word with anxiety or sad or angry:\(jurnal)"
        Task {
          // Generate text from the prompt
          do {
            let response = try! await model.generateContent(prompt)
            self.emotion = response.text ?? ""
            print(prompt)
          } catch {
            print(error.localizedDescription)
          }
        }
    }
}

#Preview {
    EmoResultView(jurnal: "ayam")
}
