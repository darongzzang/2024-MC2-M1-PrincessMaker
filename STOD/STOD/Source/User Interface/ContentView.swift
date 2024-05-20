//
//  ContentView.swift
//  STOD
//
//  Created by 김이예은 on 5/19/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var clothes: [Cloth]
    @State private var isUpdatingNewCloth = false
    @State var newCloth = Cloth(name: "", size: "", numericalPhotoPath: nil, mainPhotoPath: nil, selectedSubCategory: "")
    @State private var selectedCloth: Cloth = Cloth(name: "", size: "", numericalPhotoPath: nil, mainPhotoPath: nil, selectedSubCategory: "")
    @State private var selectedIndex: Int? = nil
    
    public func deleteCloth(offsets: IndexSet) {
        withAnimation {
            offsets.map { clothes[$0] }.forEach(modelContext.delete)
        }
    }
    
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(clothes) { cloth in
                    VStack {
                        HStack {
                            Text(cloth.name)
                                .bold()
                            Text(selectedCloth.name)
                            Text(cloth.size)
                                .foregroundStyle(.blue)
                            Text(selectedCloth.size)
                            Text(cloth.selectedSubCategory)
                                .foregroundStyle(.yellow)
                            Text(selectedCloth.selectedSubCategory)
                        }
                    }
                    .contextMenu {
                        Button(action: {
                            // 고정 기능 구현
                        }) {
                            Text("고정")
                        }
                        Button(action: {
                            if let index = clothes.firstIndex(where: { $0.id == cloth.id }) {
                                selectedIndex = index
                            }
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
                    .sheet(isPresented: $isUpdatingNewCloth, content: {
                        UpdateView(selectedCloth: $selectedCloth, selectedIndex: $selectedIndex
            //                       ?? Cloth(name: "", size: "", numericalPhotoPath: nil, mainPhotoPath: nil, selectedSubCategory: "")
                        )
                    })
                }
                .onDelete(perform: deleteCloth)
                
            }
            .navigationTitle("어떤 옷을 찾고 계신가요? 궁금하네요...")
            NavigationLink(destination: FirstSubmit(cloth: $newCloth)) {
                Label("Add Cloth", systemImage: "plus")
            }
        }
    }
}
