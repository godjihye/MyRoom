//
//  UsedSearchView.swift
//  MyRoomFE
//
//  Created by 이수정 on 12/15/24.
//

import SwiftUI

struct UsedSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var usedVM: UsedViewModel
    @AppStorage("searchHistory") private var searchHistories: [String] = []
    @FocusState private var showKeyboard: Bool
    @State private var query: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                customToolBar
                if usedVM.searchResultUsed.isEmpty {
                    UsedSearchHistoryView(
                        searchHistories: $searchHistories,
                        onSearch: { query in
                            Task { await usedVM.searchUsed(query: query) }
                        },
                        onDelete: { index in
                            searchHistories.remove(at: index)
                        }
                    )
                } else {
                    UsedSearchResultsView(useds: $usedVM.searchResultUsed, onClear: usedVM.clearSearchResult)
                }
                Spacer()
            }
            .padding(.top)
            .padding(.horizontal)
            .onAppear{
                DispatchQueue.main.async {
                    showKeyboard = true
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    private var customToolBar: some View {
        GeometryReader { reader in
            HStack(spacing: 0) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left") // 화살표 Image
                        .font(.system(size: 25))
                }
                .padding(0)
                
                Spacer()
                TextField("검색어를 입력하세요", text: $query)
                    .font(.system(size: 15))
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: reader.size.width - 70)
                    .focused($showKeyboard)
                    .onSubmit {
                        Task { await usedVM.searchUsed(query: query) }
                        if !searchHistories.contains(query) {
                            searchHistories.append(query)
                        }
                    }
                    .onAppear {
                        UIApplication.shared.hideKeyboard()
                    }
                Button {
                    dismiss()
                } label: {
                    Text("취소")
                        .font(.system(size: 15))
                        .foregroundStyle(.black)
                }
                .padding(0)
                .frame(width: 50)
            }
            .padding(.horizontal, 5)
        }
        .frame(height: 50)
    }
}

struct UsedSearchHistoryView: View {
    @Binding var searchHistories: [String]
    let onSearch: (String) -> Void
    let onDelete: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("최근 검색어")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.gray)
            
            if searchHistories.isEmpty {
                HStack {
                    Spacer()
                    Text("최근 검색어 내역이 없습니다.")
                        .fontWeight(.bold)
                        .padding(.top, 130)
                    Spacer()
                }
            } else {
                ForEach(searchHistories.reversed().indices, id: \.self) { index in
                    PostSearchHistoryRow(
                        searchText: searchHistories[searchHistories.count - 1 - index],
                        onSearch: { onSearch(searchHistories[searchHistories.count - 1 - index]) },
                        onDelete: { onDelete(searchHistories.count - 1 - index) }
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct UsedSearchHistoryRow: View {
    let searchText: String
    let onSearch: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: onSearch) {
                HStack {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundStyle(Color.secondary)
                    Text(searchText)
                        .foregroundStyle(.primary)
                    Spacer()
                }
            }
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .foregroundStyle(Color.secondary)
            }
            .contentShape(Rectangle())
        }.padding(.vertical, 8)
    }
}

struct UsedSearchResultsView: View {
    @Binding var useds: [Used]
    let onClear: () -> Void
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("검색 결과")
                    .fontWeight(.bold)
                Button(action: onClear) {
                    Text("검색 결과 초기화")
                        .foregroundStyle(.blue)
                }
            }
            .padding()
            
            Divider()
            
            ForEach($useds) { $used in
                NavigationLink {
                    UsedDetailView(used: $used, photos: used.images)
                } label: {
                    UsedRowView(used: used)
                }
            }
        }
    }
}

#Preview {
    UsedSearchView()
}
