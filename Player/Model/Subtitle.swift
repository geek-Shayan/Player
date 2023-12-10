//
//  Subtitle.swift
//  Player
//
//  Created by SHAYANUL HAQ SADI on 12/5/23.
//

import Foundation

// Struct to represent a subtitle
struct Subtitle {
    var language: String
    var url: URL
}

//
//func parseM3U8Subtitles(from url: URL, completion: @escaping ([Subtitle]) -> Void) {
//    // Create a URLSession instance
//    let session = URLSession(configuration: .default)
//
//    // Create a data task to fetch the M3U8 file
//    let task = session.dataTask(with: url) { (data, response, error) in
//        // Check for errors
//        guard error == nil, let data = data else {
//            print("Error fetching M3U8 file:", error?.localizedDescription ?? "Unknown error")
//            return
//        }
//
//        // Convert data to a string
//        if let m3u8String = String(data: data, encoding: .utf8) {
//            // Parse the subtitles using regular expressions
//            let subtitles = parseSubtitles(from: m3u8String)
//
//            // Call the completion handler with the extracted subtitles
//            completion(subtitles)
//        }
//    }
//    // Start the data task
//    task.resume()
//}
//
//
//// Function to parse subtitles from an M3U8 string using regular expressions
//func parseSubtitles(from m3u8String: String) -> [Subtitle] {
//    var subtitles: [Subtitle] = []
//
//    // Define a regular expression pattern to match subtitle lines in the M3U8 file
//    let pattern = #"(#EXT-X-MEDIA:TYPE=SUBTITLES.*,LANGUAGE="([^"]*)",URI="([^"]*)")"#
//
//    // Create a regular expression object
//    guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
//        print("Error creating regular expression")
//        return subtitles
//    }
//
//    // Find matches in the M3U8 string
//    let matches = regex.matches(in: m3u8String, options: [], range: NSRange(location: 0, length: m3u8String.utf16.count))
//    
//
//    // Extract information from the matches
//    for match in matches {
//        // Extract language and URL from the match
//        if let languageRange = Range(match.range(at: 2), in: m3u8String), let urlRange = Range(match.range(at: 3), in: m3u8String) {
//            let language = String(m3u8String[languageRange])
//            let urlString = String(m3u8String[urlRange])
//            if let url = URL(string: urlString) {
//                let subtitle = Subtitle(language: language, url: url)
//                subtitles.append(subtitle)
//            }
//        }
//        else {
//            print(" error. no subtitles found! ")
//        }
//    }
//    return subtitles
//}
