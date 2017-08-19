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
        static var starredEpisodesData: Data {
            return """
            {
                "episodes": []
            }
            """.data(using: .utf8)!
        }
        
        // New Episodes data
        static var newEpisodesData: Data {
            return """
            {
                "episodes": [{
                    "id": null,
                    "uuid": "127a8068-a5a1-4b02-87d8-fcc51a26a741",
                    "url": "http://www.gamespodcast.de/podlove/file/1389/s/feed/c/premium5/Runde_124_Gute_Belohnungen.mp3",
                    "published_at": "2017-08-19 22:00:25",
                    "duration": "5893",
                    "file_type": "audio/mp3",
                    "title": "Runde #124: Wir wollen anständig belohnt werden",
                    "podcast_id": 867908,
                    "size": 82630896,
                    "podcast_uuid": "c251cdb0-4a81-0135-902b-63f4b61a9224"
                }]
            }
            """.data(using: .utf8)!
        }
        // Episodes in Progress data
        static var episodesInProgressSuccess: Data {
            return """
            {
                "episodes": [
                    {
                        "id": null,
                        "uuid": "a90d2c1d-b00f-46be-bee8-bb0aa3efcac2",
                        "url": "http://feeds.soundcloud.com/stream/338397807-martinpittenauer-fan300.mp3",
                        "published_at": "2017-08-18 08:26:14",
                        "duration": "6324",
                        "file_type": "audio/mp3",
                        "title": "Episode #300 - Puttenbrust",
                        "size": 50652726,
                        "playing_status": 2,
                        "played_up_to": 3624,
                        "is_deleted": false,
                        "starred": false,
                        "podcast_uuid": "ab1bdc40-6fb4-012f-1af4-525400c11844"
                    }]
            }
            """.data(using: .utf8)!
        }
        
        // Subscription response data
        static var unauthorizedError: Data {
            return """
            {
                "status": "error",
                "message": "Authentication error.",
                "result": {
                    "redirect_url": "https://play.pocketcasts.com/users/sign_in"
                }
            }
            """.data(using: .utf8)!
        }
        
        static var subscriptionsSuccessData: Data {
            return """
            {
                "podcasts": [
                {
                    "id": 132469,
                    "uuid": "11ab9ae0-b49c-012f-4f9b-525400c11844",
                    "url": "http://www.wrint.de/kommt-reden-wir-zusammen/",
                    "title": "WRINT: Realitätsabgleich",
                    "description": "Worin Holger Klein und Tobias Baier ihre Realitäten abgleichen.",
                    "thumbnail_url": "http://www.wrint.de/wp-content/uploads/powerpress/wrint_realitaetsabgleich_1400.jpg",
                    "author": "Holger Klein",
                    "episodes_sort_order": 3
                }],
                "app": {
                    "userVersionCode": 3,
                    "versionCode": 3,
                    "versionName": 1.2,
                    "versionSummary": "Sharing is caring, be daring."
                }
            }
            """.data(using: .utf8)!

        }
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
