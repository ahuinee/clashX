//
//  ProxyGroupSpeedTestMenuItem.swift
//  ClashX
//
//  Created by yicheng on 2019/10/15.
//  Copyright © 2019 west2online. All rights reserved.
//

import Cocoa

class ProxyGroupSpeedTestMenuItem: NSMenuItem {
    var proxyGroup: ClashProxy
    init(group:ClashProxy) {
        proxyGroup = group
        super.init(title: NSLocalizedString("Benchmark", comment: ""), action: nil, keyEquivalent: "")
        view = ProxyGroupSpeedTestMenuItemView(title: title)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class ProxyGroupSpeedTestMenuItemView: NSView {
    let label: NSTextField
    let font = NSFont.menuFont(ofSize: 14)
    init(title: String) {
        label = NSTextField(labelWithString: title)
        label.font = font
        label.sizeToFit()
        super.init(frame: NSRect(x: 0, y: 0, width: label.bounds.width + 40, height: 20))
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 20).isActive = true
        addSubview(label)
        label.frame = NSRect(x: 20, y: 0, width: label.bounds.width, height: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func startBenchmark() {
        guard let group = (enclosingMenuItem as? ProxyGroupSpeedTestMenuItem)?.proxyGroup else {return}
        for proxyName in group.speedtestAble {
            ApiRequest.getProxyDelay(proxyName: proxyName) { delay in
                let delayStr = delay == 0 ? "fail" : "\(delay) ms"
                NotificationCenter.default.post(name: kSpeedTestFinishForProxy,
                                                object: nil,
                                                userInfo: ["proxyName": proxyName,"delay": delayStr])
            }
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        startBenchmark()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard let menu = enclosingMenuItem else {return}
        if menu.isHighlighted {
            NSColor.selectedMenuItemColor.setFill()
            label.textColor = NSColor.white
        } else {
            NSColor.clear.setFill()
            label.textColor = NSColor.labelColor
        }
        dirtyRect.fill()
    }
}
