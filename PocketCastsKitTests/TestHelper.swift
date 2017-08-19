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
        // Episode test data
        static var episideDataOptionalPresent: Data {
            return """
                {
                    "id": 1,
                    "uuid": "8a788c1e-332b-4e9f-8d0a-3043276e6cb1",
                    "url": "https://www.gamespodcast.de/podlove/file/1371/s/feed/c/premium5/Anekdoten_Thomas_Lindemann_Enthuellungen.mp3",
                    "published_at": "2017-08-16 22:00:01",
                    "duration": 2546,
                    "file_type": "audio/mp3",
                    "title": "Anekdoten: Enthüllungsjournalismus in der Spielebranche",
                    "podcast_id": 867908,
                    "size": 37094736,
                    "podcast_uuid": "c251cdb0-4a81-0135-902b-63f4b61a9224",
                    "playing_status": 2,
                    "played_up_to": 195,
                    "is_deleted": false,
                    "starred": false
                }
            """.data(using: .utf8)!
        }
        
        static var episodeDataOptionalNotPresent: Data {
            return """
                {
                    "id": null,
                    "uuid": "8a788c1e-332b-4e9f-8d0a-3043276e6cb1",
                    "url": "https://www.gamespodcast.de/podlove/file/1371/s/feed/c/premium5/Anekdoten_Thomas_Lindemann_Enthuellungen.mp3",
                    "published_at": "2017-08-16 22:00:01",
                    "duration": null,
                    "file_type": "audio/mp3",
                    "title": "Anekdoten: Enthüllungsjournalismus in der Spielebranche",
                    "size": 37094736,
                    "podcast_uuid": "c251cdb0-4a81-0135-902b-63f4b61a9224",
                }
            """.data(using: .utf8)!
        }
        
        static var episodeDataDurationIsString: Data {
            return """
                {
                    "id": null,
                    "uuid": "8a788c1e-332b-4e9f-8d0a-3043276e6cb1",
                    "url": "https://www.gamespodcast.de/podlove/file/1371/s/feed/c/premium5/Anekdoten_Thomas_Lindemann_Enthuellungen.mp3",
                    "published_at": "2017-08-16 22:00:01",
                    "duration": "2546",
                    "file_type": "audio/mp3",
                    "title": "Anekdoten: Enthüllungsjournalismus in der Spielebranche",
                    "podcast_id": 867908,
                    "size": 37094736,
                    "podcast_uuid": "c251cdb0-4a81-0135-902b-63f4b61a9224",
                }
            """.data(using: .utf8)!
        }
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
