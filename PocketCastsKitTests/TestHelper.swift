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
        
        // Global response data
        static var globalErrorResponseData: Data {
            return """
            {
                "status": "error",
                "result": {
                    "podcasts": []
                }
            }
            """.data(using: .utf8)!
        }
        
        static var categoryAndCountrySuccessData: Data {
            return """
            {
                "status": "ok",
                "result": {
                    "categories": [{
                        "id": 1,
                        "itunes_id": 1301,
                        "name": "Arts"
                    }],
                    "countries": [{
                        "code": "au",
                        "name": "Australia"
                    }]
                }
            }
            """.data(using: .utf8)!
        }
        
        static var globalSuccessResponseData: Data {
            return """
            {
                "status": "ok",
                "result": {
                    "podcasts": [
                    {
                        "uuid": "3782b780-0bc5-012e-fb02-00163e1b201c",
                        "url": "https://www.thisamericanlife.org",
                        "title": "This American Life",
                        "description": "This American Life is a weekly public radio show, heard by 2.2 million people on more than 500 stations. Another 2.5 million people download the weekly podcast. It is hosted by Ira Glass, produced in collaboration with Chicago Public Media, delivered to stations by PRX The Public Radio Exchange, and has won all of the major broadcasting awards.",
                        "thumbnail_url": "http://www.thisamericanlife.org/sites/all/themes/thislife/images/logo-square-1400.jpg",
                        "category": "Society",
                        "media_type": "Audio",
                        "language": "en",
                        "author": "This American Life",
                        "thumbnail_url_130": "http://static.pocketcasts.com/discover/images/130/3782b780-0bc5-012e-fb02-00163e1b201c.jpg",
                        "thumbnail_url_280": "http://static.pocketcasts.com/discover/images/280/3782b780-0bc5-012e-fb02-00163e1b201c.jpg"
                    }]
                }
            }
            """.data(using: .utf8)!
        }
        
        // Get all episodes of podcast data
        static var getFetchEpisodesSuccessResponseData: Data {
            return """
            {
                "status": "ok",
                "result": {
                    "episodes": [
                    {
                        "id": null,
                        "uuid": "c5af9eb7-b350-44e7-8d30-5c444aaa43c6",
                        "url": "https://tracking.feedpress.it/link/13440/6400758/cre214-satellitentelefonie.m4a",
                        "published_at": "2017-08-03 16:51:04",
                        "duration": "9102",
                        "file_type": "audio/x-m4a",
                        "title": "CRE214 Satellitentelefonie",
                        "size": 57477027,
                        "playing_status": 2,
                        "played_up_to": 1676,
                        "is_deleted": false,
                        "starred": false,
                        "is_video": false
                    }],
                    "total": 257
                }
            }
            """.data(using: .utf8)!
        }
        // Get Single Podcast data
        static var getPodcastErrorResponseData: Data {
            return """
            {
                "episode": {
                    "id": null,
                    "uuid": "127a8068-a5a1-4b02-87d8-fcc51a26a741",
                    "url": "https://www.gamespodcast.de/podlove/file/1389/s/feed/c/premium5/Runde_124_Gute_Belohnungen.mp3",
                    "published_at": "2017-08-19 22:00:25",
                    "duration": "5893",
                    "file_type": "audio/mp3",
                    "title": "Runde #124: Wir wollen anständig belohnt werden",
                    "size": 82630896,
                    "played_up_to": 2880
                }
            }
            """.data(using: .utf8)!
        }
        // Get Episode data
        static var getFetchEpisodeErrorResponseData: Data {
            return """
            {
                "podcast": {
                    "id": 867908,
                    "uuid": "c251cdb0-4a81-0135-902b-63f4b61a9224",
                    "url": "https://www.gamespodcast.de",
                    "title": "Gamespodcast.de Premium",
                    "description": "Der coole Shit, nur für Backer",
                    "thumbnail_url": "https://www.gamespodcast.de/wp-content/cache/podlove/d4/2cedb4852b1a98f280739a25d50d69/gamespodcast-de-premium_original.jpg",
                    "author": "Andre Peschke und Jochen Gebauer",
                    "episodes_sort_order": 3

                },
                "episode": null
            }
            """.data(using: .utf8)!
        }
        
        static var getFetchEpisodeResponseData: Data {
            return """
            {
                "podcast": {
                    "id": 867908,
                    "uuid": "c251cdb0-4a81-0135-902b-63f4b61a9224",
                    "url": "https://www.gamespodcast.de",
                    "title": "Gamespodcast.de Premium",
                    "description": "Der coole Shit, nur für Backer",
                    "thumbnail_url": "https://www.gamespodcast.de/wp-content/cache/podlove/d4/2cedb4852b1a98f280739a25d50d69/gamespodcast-de-premium_original.jpg",
                    "author": "Andre Peschke und Jochen Gebauer",
                    "episodes_sort_order": 3

                },
                "episode": {
                    "id": null,
                    "uuid": "127a8068-a5a1-4b02-87d8-fcc51a26a741",
                    "url": "https://www.gamespodcast.de/podlove/file/1389/s/feed/c/premium5/Runde_124_Gute_Belohnungen.mp3",
                    "published_at": "2017-08-19 22:00:25",
                    "duration": "5893",
                    "file_type": "audio/mp3",
                    "title": "Runde #124: Wir wollen anständig belohnt werden",
                    "size": 82630896,
                    "played_up_to": 2880
                }
            }
            """.data(using: .utf8)!
        }
        // Show Notes data
        static var getShowNotesResponseData: Data {
            return """
            {
            "show_notes": "This is a test message"
            }
            """.data(using: .utf8)!
        }
        // Updated starred status data
        static var setStarredSuccessResponseData: Data {
            return """
            {
                "status": "ok",
                "token": null,
                "copyright": "Shifty Jelly - Pocket Casts",
                "result": {}
            }
            """.data(using: .utf8)!
        }
        
        static var setStarredErrorResponseData: Data {
            return """
            {
                "status": "error",
                "token": null,
                "copyright": "Shifty Jelly - Pocket Casts",
                "result": null
            }
            """.data(using: .utf8)!
        }
        // Starred Episodes data
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
        
        static var networkGroupsSuccessData: Data {
            return """
            {
                "status": "ok",
                "result": {
                    "groups": [{
                        "title": "\\"Movie Date\\" from The Takeaway",
                        "description": "Each week, Newsday film critic Rafer Guzman and Takeaway producer Kristen Meinzer get in a heated, but friendly debate about the movies.",
                        "image_url": "http://static.pocketcasts.com/discover/images/200/d48bf4e0-2ce1-012e-09dd-00163e1b201c.jpg",
                        "ppu": "d48bf4e0-2ce1-012e-09dd-00163e1b201c",
                        "podcasts": [{
                            "uuid": "d48bf4e0-2ce1-012e-09dd-00163e1b201c",
                            "file_type": null
                        }]
                    }]
                }
            }
            """.data(using: .utf8)!
        }
        // Network test data
        static var networkSuccessData: Data {
            return """
            {
                "status": "ok",
                "result": {
                    "networks": [
                    {
                        "id": 24,
                        "title": "Radiotopia",
                        "description": "Radiotopia from PRX is a collective of the best story-driven shows on the planet",
                        "image_url": "http://static.pocketcasts.com/discover/images/networks/thumbnails/24/original/radiotopia.png",
                        "color": "#131F30"
                    }]
                }
            }
            """.data(using: .utf8)!
        }
        
        static var networkData: Data {
            return """
            {
                "id": 12,
                "title": "CNET",
                "description": "Reviews & first looks",
                "image_url": "http://static.pocketcasts.com/discover/images/networks/thumbnails/12/original/cnet.png",
                "color": "#222224"
            }
            """.data(using: .utf8)!
        }
        // Group test data
        static var groupData: Data {
            return """
            {
                "title": "\\"Movie Date\\" from The Takeaway",
                "description": "Each week, Newsday film critic Rafer Guzman and Takeaway producer Kristen Meinzer get in a heated, but friendly debate about the movies.",
                "image_url": "http://static.pocketcasts.com/discover/images/200/d48bf4e0-2ce1-012e-09dd-00163e1b201c.jpg",
                "ppu": "d48bf4e0-2ce1-012e-09dd-00163e1b201c",
                "podcasts": [{
                    "uuid": "d48bf4e0-2ce1-012e-09dd-00163e1b201c",
                    "file_type": null
                }]
            }
            """.data(using: .utf8)!
        }
        
        // Category test data
        static var categoryData: Data {
            return """
            {
                "id": 15,
                "name": "Technology"
            }
            """.data(using: .utf8)!
        }
        // Country test data
        static var countryData: Data {
            return """
            {
                "code": "de",
                "name": "Germany"
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
        static var podcastDataOptionalPresent: Data {
            return """
                {
                    "id": 5810,
                    "uuid": "00414e50-2610-012e-05ba-00163e1b201c",
                    "url": "https://ninjalooter.de",
                    "title": "Ninjalooter.de",
                    "category": "Technology",
                    "description": "Der Podcast der Ninjalooter befasst sich mit Spielen jeglicher Art. Insbesondere MMOs, Beta-Eindrücke und PC-Rollen- und Strategiespiele stehen auf der Debattierliste.",
                    "media_type": "Audio",
                    "language": "de",
                    "thumbnail_url": "http://ninjalooter.de/blog/wp-content/uploads/NinjaCast_Logo.jpg",
                    "author": "Ninjalooter.de",
                    "episodes_sort_order": 3
                }
            """.data(using: .utf8)!
        }
        
        static var podcastDataOptionalMissing: Data {
            return """
                {
                    "uuid": "00414e50-2610-012e-05ba-00163e1b201c",
                    "url": "https://ninjalooter.de",
                    "title": "Ninjalooter.de",
                    "description": "Der Podcast der Ninjalooter befasst sich mit Spielen jeglicher Art. Insbesondere MMOs, Beta-Eindrücke und PC-Rollen- und Strategiespiele stehen auf der Debattierliste.",
                    "thumbnail_url": "http://ninjalooter.de/blog/wp-content/uploads/NinjaCast_Logo.jpg",
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
