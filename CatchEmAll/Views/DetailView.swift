//
//  DetailView.swift
//  CatchEmAll
//
//  Created by Tushar Munge on 7/9/25.
//

import SwiftUI

struct DetailView: View {
    let creature: CreatureModel
    
    @State private var creatureDetail = CreatureDetailModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(creature.name.capitalized)
                .font(Font.custom("Avenir Next Condensed", size: 60))
                .bold()
                .minimumScaleFactor(0.5)
                .lineLimit(1)

            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray)
                .padding(.bottom)

            HStack {
                AsyncImage(url: URL(string: creatureDetail.imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 8, x: 5, y: 5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.gray.opacity(0.5), lineWidth: 1)
                        }
                } placeholder: {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.clear)
                            
                }
                .frame(width: 96, height: 96)
                .padding(.trailing)

                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text("Height:")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.red)

                        Text(String(format: "%.1f", creatureDetail.height))
                            .font(.title2)
                            .bold()
                    }

                    HStack(alignment: .top) {
                        Text("Weight:")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.red)

                        Text(String(format: "%.1f", creatureDetail.weight))
                            .font(.title2)
                            .bold()
                    }
                }
            }

            Spacer()
        }
        .padding()
        .task {
            creatureDetail.urlString = creature.url
            
            await creatureDetail.getData()
        }
    }
}

#Preview {
    DetailView(
        creature: CreatureModel(
            name: "bulbasaur",
            url: "https://pokeapi.co/api/v2/pokemon/1/"
        )
    )
}
