//
//  ZeitgeistWidgets.swift
//  ZeitgeistWidgets
//
//  Created by Daniel Eden on 31/05/2021.
//

import SwiftUI
import WidgetKit

@main
struct ZeitgeistWidgets: WidgetBundle {
	@WidgetBundleBuilder
	var body: some Widget {
		LatestDeploymentWidget()
		RecentDeploymentsWidget()
	}
}

struct WidgetLabel: View {
	var label: String
	var iconName: String
	
	var body: some View {
		Text("\(Image(systemName: iconName)) \(label)")
		.fontWeight(.medium)
		.padding(2)
		.padding(.horizontal, 2)
		.background(.thickMaterial)
		.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
	}
}
