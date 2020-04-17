//
//  PostDetailsView.swift
//  Trading
//
//  Created by Ferrando, Andrea on 11/02/2020.
//  Copyright © 2020 AF. All rights reserved.
//

import SwiftUI
import Combine
import ASCollectionView

struct PostDetailsView: View {

    @ObservedObject var presenter: PostDetailsPresenter
    var post: PostDetailViewModel { return self.presenter.post }

    private var commentRowHeight: CGFloat = 100

    init(presenter: PostDetailsPresenter) {
        self.presenter = presenter
    }

    var body: some View {
        List {
            Section(header: PostDetailsListHeader(post: self.post)
            .background(Color.white)
            .listRowInsets(EdgeInsets(
                top: 0,
                leading: 0,
                bottom: 0,
                trailing: 0))
            ) { ForEach(self.post.comments, id: \.id) { comment in
                    VStack(alignment: .leading) {
                        Text(comment.title)
                            .font(.body)
                        .padding(.bottom, 10)
                        Text(comment.body)
                            .font(.caption)
                        .padding(.bottom, 10)
                        Text("\(Constants.author): \(self.post.author)")
                            .font(.footnote)
                    }
                }.background(Color.clear)
            }
            .background(Color(.clear))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .onAppear {
                self.presenter.didReceiveEvent(.viewAppears)
            }
            .onDisappear {
                self.presenter.didReceiveEvent(.viewDisappears)
            }
        }
        //.navigationBarTitle(self.post.title, displayMode: .inline)
    }

    struct PostDetailsListHeader: View {
        var post: PostDetailViewModel
        init(post: PostDetailViewModel) {
            self.post = post
        }
        var body: some View {
            VStack(alignment: .leading) {
                Text(post.title)
                    .font(.headline)
                    .padding(.bottom, 20)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: Alignment.center)
                HStack(alignment: .top, spacing: 10) {
                    Text("\(Constants.user):")
                        .font(.headline)
                        .foregroundColor(.orange)
                    Text(post.author)
                        .font(.body)
                }.padding(.bottom, 20)
                Text(post.body)
                    .font(.body)
                Divider().padding(.bottom, 10)
                Text(Constants.comments)
                    .lineSpacing(20)
                    .foregroundColor(.orange)
                    .font(.headline)
                    .padding(.bottom, 10)
            }.padding(.horizontal, 15)
        }
    }

    struct PostDetailsView_Previews: PreviewProvider {
        static var previews: some View {
            PostDetailsView(presenter: PostDetailsRouter.makePresenter(postId: 1))
        }
    }
}
