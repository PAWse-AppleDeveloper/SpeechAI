import SwiftUI
import Speech

struct ContentView: View {
    @ObservedObject var speechRecognizer = SpeechRecognizer()
    @State private var jurnal: String = ""
    @State private var isRecord: Bool = false
    @State private var showResultSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack{
                        Text("How do you feel?")
                            .bold()
                            .multilineTextAlignment(.center)
                            .font(.title3)
                        Text("Let's write or talk about it.")
                            .bold()
                            .multilineTextAlignment(.center)
                            .font(.title3)
                    }
                    .padding(5)
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $jurnal)
                            .foregroundColor(.gray)
                            .frame(height: 470)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                        if jurnal.isEmpty {
                            Text("How is your day going?")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 18)
                        }

                    }
                    .padding()
                    if !isRecord {
                        Button(action: {
                            self.speechRecognizer.startTranscribing()
                            isRecord.toggle()
                        }) {
                            Image("microfon")
                                .overlay(
                                    RoundedRectangle(cornerRadius: 200)
                                        .stroke(Color.black, lineWidth: 4)
                                )
                        }
                    } else {
                        Button(action: {
                            self.speechRecognizer.stopTranscribing()
                            self.jurnal = self.speechRecognizer.transcript
                            isRecord.toggle()
                        }) {
                            Image("endRecord")
                                .overlay(
                                    RoundedRectangle(cornerRadius: 200)
                                        .stroke(Color.black, lineWidth: 4)
                                )
                        }
                    }
                    Spacer()
                    VStack {
                        NavigationLink(destination: EmoResultView(jurnal: jurnal)){
                            Text("Next")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.biruBTNBefore)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .frame(maxWidth: .infinity)
                        HStack{
                            Rectangle()
                                .fill(Color.biruTuaSlider)
                                .frame(width: 35,height: 5)
                                .cornerRadius(25)
                            Rectangle()
                                .fill(Color.abu)
                                .frame(width: 35,height: 5)
                                .cornerRadius(25)
                        }
                        .padding(5)
                    }
                    .padding()
                }
                .padding()
                .onAppear {
                    requestSpeechAuthorization()
//                    playSound(name: "breathing", extensionFile: "mp3")
                }
                .onReceive(speechRecognizer.$transcript) { newTranscript in
                    self.jurnal = newTranscript
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorized")
            case .denied:
                print("Speech recognition denied")
            case .restricted:
                print("Speech recognition restricted")
            case .notDetermined:
                print("Speech recognition not determined")
            @unknown default:
                print("Unknown status")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
