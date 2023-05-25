import SwiftUI
import SpriteKit
import AVFoundation
import CoreHaptics

//MARK - rodar em um iphone, não no simulador

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

 
        let notesvalues: [Float] = [0.0, 0.08, 0.16, 0.25, 0.30, 0.40, 0.75, 0.91, 1.0]
        let noteName: [String] = ["F2", "G2", "A3", "B3", "C3", "D3","E3", "F3", "G3"]
       
        HStack{
            ForEach(0..<notesvalues.count, id: \.self){ n in
                Button{
                    notes = notesvalues[n]
                    switch (notes) {
                    case 0.0:
                        SoundManeger.shared.playSound(name: "fa_grave")
                        
                    case 0.08:
                        SoundManeger.shared.playSound(name: "sol_grave")
                        
                    case 0.16:
                        SoundManeger.shared.playSound(name: "la_grave")
                        
                    case 0.25:
                        SoundManeger.shared.playSound(name: "si_grave 2")
                        
                    case 0.30:
                        SoundManeger.shared.playSound(name: "do")
                       
                    case 0.40:
                        SoundManeger.shared.playSound(name: "re")
                       
                    case 0.75:
                        SoundManeger.shared.playSound(name: "mi")
                       
                    case 0.91:
                        SoundManeger.shared.playSound(name: "fa 2")
                        
                    case 1.0:
                        SoundManeger.shared.playSound(name: "sol")
                        
                    default:
                        SoundManeger.shared.playSound(name: "la")
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
