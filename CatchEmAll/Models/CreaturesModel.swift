//
//  CreaturesModel.swift
//  CatchEmAll
//
//  Created by Tushar Munge on 7/7/25.
//

import Foundation

// The `Observable` macro will watch objects for changes, so that SwiftUI will redraw th interface when needed
@Observable
class CreaturesModel {
    var urlString = "https://pokeapi.co/api/v2/pokemon"
    var count = 0
    var creaturesList: [CreatureModel] = []
    
    private struct Returned: Codable {
        var count: Int
        var next: String? // The last page of Pokemon data will have NULL for "next"
        var results: [CreatureModel]
    }
    
    func getData() async {
        print("🕸️ We are accessing the URL \(urlString)")
        
        // Create a URL
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create URL from \(urlString)")
            
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Try to decode JSON data into our own data structures, `Returned` in our case
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON ERROR: Could not decode returned JSON data")
                
                return
            }
            
            // If you've got an `async` function that might take some time (in this case pulling data from WWW),
            // but it's updating "value" that impac User Interface, push them to the "main thread" using
            // `@MainActor`. There are many ways to do this, but `Task { @MainActor in ... } works well
            Task { @MainActor in
                self.count = returned.count
                self.urlString = returned.next ?? "" // Nill Coalecing to account for NULL in "next"
                self.creaturesList += returned.results
            }
        } catch {
            print("😡 ERROR: Could not get data from \(urlString)")
        }
    }
}
