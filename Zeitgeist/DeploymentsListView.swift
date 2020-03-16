//
//  DeploymentsListView.swift
//  Zeitgeist
//
//  Created by Daniel Eden on 13/03/2020.
//  Copyright © 2020 Daniel Eden. All rights reserved.
//

import Foundation
import SwiftUI
import Cocoa

struct DeploymentsListView: View {
  @EnvironmentObject var viewModel: ZeitDeploymentsViewModel
  @EnvironmentObject var settings: UserDefaultsManager
  @State var isPreferencesShown = false

  let updateStatusOverview = Timer.publish(every: 1, on: .current, in: .common).autoconnect()

  var body: some View {
    VStack {
      viewModel.resource.hasError { error in
        if error is URLError {
          NetworkError()
            .padding(.bottom, 40)
        } else {
          VStack {
            Image("errorSplashIcon")
            Text("tokenErrorHeading")
              .font(.subheadline)
              .fontWeight(.bold)
            Text("accessHint")
              .multilineTextAlignment(.center)
              .lineLimit(10)
              .frame(minWidth: 0, minHeight: 0, maxHeight: 40)
              .layoutPriority(1)
            Button(action: self.resetSession) {
              Text("backButton")
            }
          }
          .padding()
          .padding(.bottom, 40)
        }
      }

      viewModel.resource.isLoading {
        ProgressIndicator()
      }

      viewModel.resource.hasResource { result in
        if result.deployments.isEmpty {
          Spacer()
          Text("emptyState")
            .foregroundColor(.secondary)
          Spacer()
        } else {
          VStack(alignment: .leading, spacing: 0) {
            List(result.deployments, id: \.self) { deployment in
              DeploymentsListRowView(deployment: deployment)
                .padding(.horizontal, -4)
            }

            Divider()
            VStack(alignment: .leading) {
              HStack {
                Button(action: self.resetSession) {
                  Text("logoutButton")
                }
                Spacer()
//                Button(action: {self.isPreferencesShown.toggle()}) {
//                  Text("Settings")
//                }
              }
            }
            .font(.caption)
            .padding(8)
          }.onReceive(self.updateStatusOverview, perform: { _ in
            let delegate: AppDelegate? = NSApplication.shared.delegate as? AppDelegate
            delegate?.setIconBasedOnState(state: result.deployments[0].state)
          })
        }
      }
    }
      .onAppear(perform: viewModel.onAppear)
      .sheet(isPresented: $isPreferencesShown) {
        PreferencesView()
      }
  }

  func resetSession() {
    self.settings.token = nil
    self.settings.objectWillChange.send()
  }
}

struct NetworkError: View {
  var body: some View {
    VStack {
      Image("networkOfflineIcon")
        .foregroundColor(.secondary)
      Text("offlineHeading")
        .font(.subheadline)
        .fontWeight(.bold)
      Text("offlineDescription")
        .multilineTextAlignment(.center)
        .lineLimit(10)
        .frame(minWidth: 0, minHeight: 0, maxHeight: 40)
        .layoutPriority(1)
        .foregroundColor(.secondary)
    }.padding()
  }
}

struct DeploymentsListView_Previews: PreviewProvider {
  static var previews: some View {
    DeploymentsListView()
  }
}
