import SwiftUI

struct ContentView: View {
    @StateObject var game = Game()
    @State private var isShowingActionSheet = false
    @State private var actionSheetMessage = ""
    
    var body: some View {
            VStack {
                HStack {
                    Text("Pocket: \(String(format: "%.0f", game.pocket))$")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                        .padding(.trailing, 70.0)
                        
                    
                    Button(action: {
                        game.resetMoney()
                    }) {
                        Image(systemName: "dollarsign.arrow.circlepath")
                            .font(Font.system(size:35))
                    }
                    
                    Button(action: {
                        game.addMoney()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(Font.system(size:35))
                    }
                    
                }.padding(.top)
                
                List(game.horses) { horse in
                    HStack {
                        Text(horse.name)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.primary)
                            .padding()
                            .background(horse.isSelected ? Color.blue : Color.clear)
                            .cornerRadius(6)
                            .onTapGesture {
                                game.selectHorse(horse)
                            }
                        Spacer()
                        
                        
                        Text("\(horse.odds, specifier: "%.2f")")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(Color.gray)
                    }
                    .foregroundColor(horse.isSelected ? Color.white : Color.primary)
                }
                .listStyle(PlainListStyle())
                
                    
                    
                
                
                Stepper("Bet: \(String(format: "%.0f", game.betValue))", value: $game.betValue, in: 0...game.pocket, step: 100)
                    .padding()
                    .font(.title2)
                
                Button("Confirm") {
                    isShowingActionSheet = true
                    actionSheetMessage = game.selectedOptionConfirmed()
                }
                .padding()
                .font(.title)
                .disabled(!game.isHorseSelected)
            }
            .actionSheet(isPresented: $isShowingActionSheet) {
                
                ActionSheet(
                    title: Text("Result"),
                    message: Text(actionSheetMessage),
                    buttons: [
                        .default(Text("Okay!"))
                    ]
                )
            }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
