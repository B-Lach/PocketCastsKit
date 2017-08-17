//
//  TestHelper.swift
//  PocketCastsKitTests
//
//  Created by Benny Lach on 17.08.17.
//  Copyright © 2017 Benny Lach. All rights reserved.
//

import Foundation

struct TestHelper {
    private init() {}
}

// MARK: - Model test data
extension TestHelper {
    struct TestData {
        // Podcast test data
        static var podcastDataWithAuthor: Data {
            return """
                {
                    "id": 5810,
                    "uuid": "00414e50-2610-012e-05ba-00163e1b201c",
                    "url": "https://ninjalooter.de",
                    "title": "Ninjalooter.de",
                    "description": "Der Podcast der Ninjalooter befasst sich mit Spielen jeglicher Art. Insbesondere MMOs, Beta-Eindrücke und PC-Rollen- und Strategiespiele stehen auf der Debattierliste.",
                    "thumbnail_url": "http://ninjalooter.de/blog/wp-content/uploads/NinjaCast_Logo.jpg",
                    "author": "Ninjalooter.de",
                    "episodes_sort_order": 3
                }
                """.data(using: .utf8)!
        }
        
        static var podcastDataWithoutAuthor: Data {
            return """
                {
                    "id": 5810,
                    "uuid": "00414e50-2610-012e-05ba-00163e1b201c",
                    "url": "https://ninjalooter.de",
                    "title": "Ninjalooter.de",
                    "description": "Der Podcast der Ninjalooter befasst sich mit Spielen jeglicher Art. Insbesondere MMOs, Beta-Eindrücke und PC-Rollen- und Strategiespiele stehen auf der Debattierliste.",
                    "thumbnail_url": "http://ninjalooter.de/blog/wp-content/uploads/NinjaCast_Logo.jpg",
                    "author": null,
                    "episodes_sort_order": 3
                }
                """.data(using: .utf8)!
        }
    }
}

// MARK: - Decoding Stuff
extension TestHelper {
    struct Decoding {
        static var dateFormatter: DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
            
            return dateFormatter
        }
        
        static var jsonDecoder: JSONDecoder {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(TestHelper.Decoding.dateFormatter)
            
            return decoder
        }
    }
}
