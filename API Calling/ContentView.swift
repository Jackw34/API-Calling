//
//  ContentView.swift
//  API Calling
//
//  Created by Student on 2/9/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    @State private var cryptos = [Crypto]()
    var body: some View {
        NavigationView {
            List(cryptos) { Crypto in
                NavigationLink(
                    destination: VStack {
                    Text(Crypto.name)
                        .padding()
                    Text(Crypto.price)
                        .padding()
                    }, label: {
                        Text(Crypto.name)
                    })
            }
            .navigationTitle("Crypto Prices")
        }
        .onAppear(perform: {
            getCrypto()
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the data"),
                  dismissButton: .default(Text("OK")))
        })
        
    }
    func getCrypto() {
        let apiKey = "?rapidapi-key=7afe78fc4amshc64428dc923526ap1bc439jsn61aa39faaaa6"
        let query = "https://currency23.p.rapidapi.com/cripto\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                if json["success"] == true {
                    let contents = json["result"].arrayValue
                    for item in contents {
                        let price = item["price"].stringValue
                        let name = item["name"].stringValue
                        let crypto = Crypto(price: price, name: name)
                        cryptos.append(crypto)
                    }
                    return
                }
            }
        }
        showingAlert = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Crypto: Identifiable {
    let id = UUID()
    var price: String
    var name: String
}
