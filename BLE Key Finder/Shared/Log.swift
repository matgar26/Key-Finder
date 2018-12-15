//
//  Log.swift
//  BLE Key Finder
//
//  Created by Matt Gardner on 12/12/18.
//  Copyright © 2018 Matt Gardner. All rights reserved.
//

import Foundation

enum Log: Int {
    case network
    case services
    case views
    case authentication
    case appBadge
    case `deinit`
    case settings
    case bluetooth
    
    var prefix: String {
        switch self {
        case .network: return "🌐 (Network)"
        case .services: return "📡 (Service)"
        case .views: return "📱 (Views)"
        case .authentication: return "👤 (Authentication)"
        case .appBadge: return "🔢 (App Badge)"
        case .deinit: return "🗑 (Deinit)"
        case .settings: return "⚙️ (Settings)"
        case .bluetooth: return "📟 (Bluetooth)"
        }
    }
    
    class Event {
        let description: String
        
        init(description: String) {
            self.description = description
        }
    }
    
    class ErrorEvent: Event {
        override init(description: String) {
            super.init(description: "❗️ " + description)
        }
    }
}

extension Log {
    private static var enabledLogs = [Log]()
    private static var includeMetaData = false
    
    static func enable(logs: [Log] = [], includeMetaData: Bool = false) {
        var logs = logs
        if logs.isEmpty {
            var i = 0
            while let log = Log(rawValue: i) {
                logs.append(log)
                i += 1
            }
        }
        Log.enabledLogs = logs
        Log.includeMetaData = includeMetaData
        print("Enabled logs: \(logs.map { $0.prefix }.joined(separator: ", ")) \n\n")
    }
    
    static func enable(logs: Log..., includeMetaData: Bool = false) {
        enable(logs: logs, includeMetaData: includeMetaData)
    }
}

extension Log {
    static func message(_ message: String, logs: [Log], file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        var logs = logs
        if !enabledLogs.isEmpty {
            logs = logs.filter { enabledLogs.contains($0) }
        }
        
        if logs.isEmpty {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: Date())
        let prefix = logs.map { $0.prefix }.joined(separator: ", ")
        
        var string = ""
        if Log.includeMetaData {
            string = """
            
            [\(dateString) - \((file as NSString).lastPathComponent), \(function), (line: \(line), column: \(column))]
            \(prefix) - \(message)
            
            """
        } else {
            string = "[\(dateString)] \(prefix) - \(message)"
        }
        
        print(string)
    }
    
    static func event(_ event: Event, logs: [Log], file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        Log.message(event.description, logs: logs, file: file, line: line, column: column, function: function)
    }
    
    static func error(_ error: Error, message: String? = nil, logs: [Log], file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        // TODO: In some cases, error.prettyDescription is what we want, in others, just the raw error is enough.
        Log.message("❗️\(message ?? "") \(error)", logs: logs, file: file, line: line, column: column, function: function)
    }
}

extension Log {
    func message(_ message: String, file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        Log.message(message, logs: [self], file: file, line: line, column: column, function: function)
    }
    
    func event(_ event: Log.Event, file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        Log.event(event, logs: [self], file: file, line: line, column: column, function: function)
    }
    
    func error(_ error: Error, message: String? = nil, file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        Log.error(error, message: message, logs: [self], file: file, line: line, column: column, function: function)
    }
}

extension Log.Event {
    static func deinitialized(_ object: Any) -> Log.Event {
        return Log.Event(description: "Deinitialized \(object)")
    }
}
