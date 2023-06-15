//
//  numberPad.swift
//  SmartMoney
//
//  Created by Dylan Lo on 15/6/23.
//

import SwiftUI

struct numberPad: View {
    @State var enteredNumber: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Amount:")
                    .font(.system(size: 23))
                    .padding()
                
                Spacer()
                
                Text("$\(enteredNumber)")
                    .font(.system(size: 23))
                    .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 242/255, green: 242/255, blue: 242/255)))
            .padding(12)
            
            VStack(spacing: 10) {
                HStack(spacing: 15) {
                    createNumberButton("1")
                    createNumberButton("2")
                    createNumberButton("3")
                }
                
                HStack(spacing: 15) {
                    createNumberButton("4")
                    createNumberButton("5")
                    createNumberButton("6")
                }
                
                HStack(spacing: 15) {
                    createNumberButton("7")
                    createNumberButton("8")
                    createNumberButton("9")
                }
                
                HStack(spacing: 15) {
                    createNumberButton(".")
                    createNumberButton("0")
                    createDeleteButton()
                }
            }
            .padding()
        }
    }
    
    private func createNumberButton(_ number: String) -> some View {
        Button(action: {
            enteredNumber += number
        }) {
            Text(number)
                .font(.title)
                .frame(width: 100, height: 60)
                .background(Color.teal)
                .foregroundColor(.white)
                .cornerRadius(5)
        }
    }
    
    private func createDeleteButton() -> some View {
        Button(action: {
            enteredNumber = String(enteredNumber.dropLast())
        }) {
            Image(systemName: "delete.left")
                .font(.title)
                .frame(width: 100, height: 60)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(5)
        }
    }
}


struct numberPad_Previews: PreviewProvider {
    static var previews: some View {
        numberPad()
    }
}
