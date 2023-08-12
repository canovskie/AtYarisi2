import Foundation

class Horse: Identifiable, Equatable {
    static func == (lhs: Horse, rhs: Horse) -> Bool {
            return lhs.id == rhs.id
        }
    
    let id = UUID().uuidString
    let name: String
    var odds: Double
    var isSelected = false
    
    init(name: String, odds: Double) {
        self.name = name
        self.odds = odds
    }
}

class Game: ObservableObject {
    @Published var horses: [Horse] = [
        Horse(name: "Horse 1", odds: 1.3),
        Horse(name: "Horse 2", odds: 1.6),
        Horse(name: "Horse 3", odds: 1.1),
        Horse(name: "Horse 4", odds: 1.4),
        Horse(name: "Horse 5", odds: 1.0)
    ]
    
    
    @Published var pocket: Double = 1000
    @Published var betValue: Double = 100
    @Published var selectedHorse: Horse?
    
    var isHorseSelected: Bool {
        selectedHorse != nil
    }
    
    func selectHorse(_ horse: Horse) {
        horses.forEach { $0.isSelected = false }
        horse.isSelected = true
        selectedHorse = horse
    }
    
    func randomWinnerSelection() -> Horse? {
        guard !horses.isEmpty else {
            return nil
        }
        
        // Komple dışarıdan aldım.
        var totalInverseOdds: Double = 0
        for horse in horses {
            totalInverseOdds += 1 / horse.odds
        }
        let randomValue = Double.random(in: 0..<totalInverseOdds)
        
        var accumulatedInverseOdds: Double = 0
        for horse in horses {
            accumulatedInverseOdds += 1 / horse.odds
            if randomValue < accumulatedInverseOdds {
                return horse
            }
        }
        
        return horses.last
    }
    
    
    func selectedOptionConfirmed() -> String {
        guard let selectedHorse = selectedHorse else {
            return "Please select a horse."
        }
        
        if pocket < betValue {
            return "You are poor!"
        }
        
        if let randomWinner = randomWinnerSelection() {
            if selectedHorse == randomWinner {
                pocket += betValue * selectedHorse.odds
                return "You won!"
            } else {
                pocket -= betValue
                return "Try again - The Winner is \(randomWinner.name)."
            }
        } else {
            return "Please Select a Horse."
        }
    }
    
    func addMoney(){
        pocket = pocket + 1000
        
    }
    
    func resetMoney(){
        pocket = 1000
        
    }
}
