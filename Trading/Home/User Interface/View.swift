//
//  HomeView.swift
//  Trading
//
//  Created by Ferrando, Andrea on 11/02/2020.
//  Copyright © 2020 AF. All rights reserved.
//

import SwiftUI
import Combine

struct HomeView: View {

    @ObservedObject var presenter: HomePresenter

    init(presenter: HomePresenter) {
        self.presenter = presenter
    }

    var body: some View {
        NavigationView {
            List(self.presenter.posts, id: \.id) { post in
                NavigationLink(destination: PostDetailsView(presenter: PostDetailsRouter.makePresenter(postId: post.id))) {
                   Text(post.title)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                }
            }.navigationBarTitle(Constants.NavigationBarTitle.posts)
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
