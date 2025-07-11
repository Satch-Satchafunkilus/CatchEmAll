//
//  CreaturesListView.swift
//  CatchEmAll
//
//  Created by Tushar Munge on 7/7/25.
//

import SwiftUI

struct CreaturesListView: View {
    @State var creatures = CreaturesModel()
    @State var searchText: String = ""

    var searchResults: [CreatureModel] {
        if searchText.isEmpty {
            return creatures.creaturesList
        } else {
            return creatures.creaturesList.filter {
                $0.name.capitalized.contains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                List(searchResults) { creature in
                    // LazyVStack loads a one "row" at a time
                    LazyVStack {
                        NavigationLink {
                            CreatureDetailView(creature: creature)
                        } label: {
                            Text("\(returnCreatureIndex(of: creature)). \(creature.name.capitalized)")
                                .font(.title2)
                        }
                    }
                    .task {
                        await creatures.loadNextPageIfNeeded(creature: creature)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Pokemon")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Load All") {
                            Task {
                                await creatures.loadAllData()
                            }
                        }
                    }

                    ToolbarItem(placement: .status) {
                        Text(
                            "\(creatures.creaturesList.count) of \(creatures.count) Creatures"
                        )
                    }
                }
                .searchable(text: $searchText)

                if creatures.isLoading {
                    ProgressView()
                        .tint(.red)
                        .scaleEffect(4.0)
                }
            }
        }
        .task {
            await creatures.getData()
        }
    }

    func returnCreatureIndex(of creature: CreatureModel) -> Int {
        guard
            let index = creatures.creaturesList.firstIndex(where: {
                $0.id == creature.id
            })
        else {
            return 0
        }

        return index + 1
    }
}

#Preview {
    CreaturesListView()
}
