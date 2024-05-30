import SwiftUI
import AVFoundation
import CoreHaptics

struct ContentView: View {
    @State var notes: Float = 0.0
    //usando o core haptic
    @State private var engine: CHHapticEngine?
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    
    func notas() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: notes)
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0.01, duration: 0.8)
        events.append(event)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
        
        
    }
    
    @State var x: Bool = false
    var body: some View {
//escala de mi maior

        let notesvalues: [Float] = [0.0, 0.12, 0.25, 0.30, 0.40, 0.50, 0.60, 0.70]
        let noteName: [String] = ["E1", "F1#", "G1#", "A2", "B2", "C2#","D2#", "E2"]
       
        HStack{
            ForEach(0..<notesvalues.count, id: \.self){ n in
                Button{
                    //mudar para notename dps
                    notes = notesvalues[n]
                    switch (notes) {
                    case 0.0:
                        SoundManeger.shared.playSound(name: "mi1")
                        
                    case 0.12:
                        SoundManeger.shared.playSound(name: "fa1")
                        
                    case 0.25:
                        SoundManeger.shared.playSound(name: "sol1")
                        
                    case 0.30:
                        SoundManeger.shared.playSound(name: "la1")
                        
                    case 0.40:
                        SoundManeger.shared.playSound(name: "si1")
                       
                    case 0.50:
                        SoundManeger.shared.playSound(name: "do1")
                       
                    case 0.6:
                        SoundManeger.shared.playSound(name: "re1")
                       
                    case 0.70:
                        SoundManeger.shared.playSound(name: "mi2")
                        
                    default:
                        SoundManeger.shared.playSound(name: "mi1")
                    }
                    notas()
                    
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(.gray)
                            .frame(width: 80)
                        Text(noteName[n])
                            .bold()
                            .foregroundColor(.black)
                    }
                }
            }
           
        }
        .onAppear(perform: prepareHaptics)
        
    }
    
}



public class SoundManeger {
    static var shared : SoundManeger = SoundManeger()

    var Sound: AVAudioPlayer?

    func playSound(name : String) {
        let url = Bundle.main.url(forResource: name, withExtension: "mp3")
        do {
            Sound = try AVAudioPlayer(contentsOf: url ?? URL(string: "")!)
            Sound?.play()
        } catch {
            print("Nao encontrei o som")
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch let error {
            print("fkejsnfkjsnd")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
