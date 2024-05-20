//
//  ContentView.swift
//  STOD
//
//  Created by SOOKYUNG CHO on 5/19/24.
//


//
//  ContentView.swift
//  STOD
//
//  Created by 김이예은 on 5/19/24.
//

import SwiftUI
import SwiftData

struct JaneView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var clothes: [Cloth]
    @State private var isUpdatingNewCloth = false
    @State var newCloth = Cloth(name: "", size: "", numericalPhotoPath: nil, mainPhotoPath: nil, selectedSubCategory: "")
    @State private var selectedCloth: Cloth? = nil
    
    public func deleteCloth(offsets: IndexSet) {
        withAnimation {
            offsets.map { clothes[$0] }.forEach(modelContext.delete)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(clothes, id: \.self) { cloth in
                    VStack {
                        HStack {
                            Text(cloth.name)
                                .bold()
                            Text(cloth.size)
                                .foregroundStyle(.blue)
                            Text(cloth.selectedSubCategory)
                                .foregroundStyle(.yellow)
                        }
                    }
                    .contextMenu {
                        Button(action: {
                            // 고정 기능 구현
                        }) {
                            Text("고정")
                        }
                        Button(action: {
                            selectedCloth = Cloth(name: cloth.name, size: cloth.size, numericalPhotoPath: cloth.numericalPhotoPath, mainPhotoPath: cloth.mainPhotoPath, selectedSubCategory: cloth.selectedSubCategory)
                            isUpdatingNewCloth = true
                            // 수정 기능 구현
                        }) {
                            Text("수정")
                        }
                        Button(action: {
                            if let index = clothes.firstIndex(where: { $0.id == cloth.id }) {
                                deleteCloth(offsets: IndexSet(integer: index))
                            }
                        }) {
                            Text("삭제")
                        }
                    }
                }
                .onDelete(perform: deleteCloth)
                
            }
            .navigationTitle("어떤 옷을 찾고 계신가요?")
            NavigationLink(destination: FirstSubmit(cloth: $newCloth)) {
                Label("Add Cloth", systemImage: "plus")
            }
        }.sheet(isPresented: $isUpdatingNewCloth, content: {
            UpdateView(cloth: selectedCloth ?? Cloth(name: "", size: "", numericalPhotoPath: nil, mainPhotoPath: nil, selectedSubCategory: ""))
        })
    }
}
