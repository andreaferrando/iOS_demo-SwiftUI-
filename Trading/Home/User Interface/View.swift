//
//  HomeView.swift
//  Trading
//
//  Created by Ferrando, Andrea on 11/02/2020.
//  Copyright © 2020 AF. All rights reserved.
//

import SwiftUI
import Combine
import ASCollectionView

struct HomeView: View {

    @ObservedObject var presenter: HomePresenter

    init(presenter: HomePresenter) {
        self.presenter = presenter
    }

    var body: some View {

        NavigationView {
            ASCollectionView(data: self.presenter.posts, dataID: \.id) { item, _ in
            Color.blue
                .overlay(
                    Text("\(item.title)")
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                )
        }
        .layout {
            .grid(layoutMode: .adaptive(withMinItemSize: 100),
                  itemSpacing: 5,
                  lineSpacing: 5,
                  itemSize: .absolute(50))
        }
        }.onAppear {
            self.presenter.didReceiveEvent(.viewAppears)
        }.onDisappear {
            self.presenter.didReceiveEvent(.viewDisappears)
        }
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(presenter: HomeRouter.makePresenter())
    }
}
