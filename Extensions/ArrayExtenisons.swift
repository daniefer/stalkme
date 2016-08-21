//
//  ArrayExtenisons.swift
//  RouteBasedAlerts
//
//  Created by Daniel Ferguson on 8/6/16.
//  Copyright © 2016 Daniel Ferguson. All rights reserved.
//

import Foundation

extension Array {
    func last(n: Int) -> Array {
        var result: Array = [];
        var index: Index = Index(n);
        while index < self.count {
            result.append(self[index])
            index = index + 1;
        }
        return result;
    }
}