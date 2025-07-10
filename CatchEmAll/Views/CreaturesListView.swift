//
//  CreaturesListView.swift
//  CatchEmAll
//
//  Created by Tushar Munge on 7/7/25.
//

import SwiftUI

struct CreaturesListView: View {
    @State var creatures = CreaturesModel()

    var body: some View {
        NavigationStack {
            List(0..<creatures.creaturesList.count, id: \.self) { index in
                // LazyVStack loads a one "row" at a time
                LazyVStack {
                    NavigationLink {
                        DetailView(creature: creatures.creaturesList[index])
                    } label: {
                        Text(
                            "\(index + 1). \(creatures.creaturesList[index].name.capitalized)"
                        )
                        .font(.title2)
                    }
                }
                .task {
                    guard let lastCreature = creatures.creaturesList.last else {
                        return
                    }

                    // If the last element has the same "name" as the creature
                    // that was just loaded by the `LazyVStack`, and the "next"
                    // JSON element (`creature.urlString`) is not NULL (will start
                    // with "http")
                    if creatures.creaturesList[index].name == lastCreature.name
                        && creatures.urlString.hasPrefix("http")
                    {
                        await creatures.getData()
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Pokemon")
            .toolbar {
                ToolbarItem(placement: .status) {
                    Text(
                        "\(creatures.creaturesList.count) of \(creatures.count) Creatures"
                    )
                }
            }
        }
        .task {
            await creatures.getData()
        }
    }
}

#Preview {
    CreaturesListView()
}
