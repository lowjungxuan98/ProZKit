//
//  PrettyLogger.swift
//  ProZKit
//
//  Created by Low Jung Xuan on 14/2/25.
//

import Foundation

public enum PrettyLogger {
    public static func log(_ message: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeString = formatter.string(from: Date())
        print("ProZKit [\(timeString)]: \(message)")
    }

    public static func info(_ message: String) {
        log("INFO: \(message)")
    }

    public static func error(_ message: String) {
        log("ERROR: \(message)")
    }
}
