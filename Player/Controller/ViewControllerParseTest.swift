//
//  ViewControllerParseTest.swift
//  Player
//
//  Created by SHAYANUL HAQ SADI on 12/14/23.
//

import UIKit

class ViewControllerParseTest: UIViewController {

    let manifestString = """
    #EXTM3U
    #EXT-X-TARGETDURATION: 887
    #EXT-X-VERSION: 3
    #EXT-X-MEDIA-SEQUENCE:1
    #EXT-X-PLAYLIST-TYPE: VOD
    #EXTINF:887.0,
    subtitles_de.vtt
    #EXT-X-ENDLIST
    """
    
    //https://bitmovin-a.akamaihd.net/content/sintel/hls/playlist.m3u8
    
    //    let manifest = """
    //    #EXTM3U
    //
    //    #EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="stereo",LANGUAGE="en",NAME="English",DEFAULT=YES,AUTOSELECT=YES,URI="audio/stereo/en/128kbit.m3u8"
    //    #EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="stereo",LANGUAGE="dubbing",NAME="Dubbing",DEFAULT=NO,AUTOSELECT=YES,URI="audio/stereo/none/128kbit.m3u8"
    //
    //    #EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="surround",LANGUAGE="en",NAME="English",DEFAULT=YES,AUTOSELECT=YES,URI="audio/surround/en/320kbit.m3u8"
    //    #EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="surround",LANGUAGE="dubbing",NAME="Dubbing",DEFAULT=NO,AUTOSELECT=YES,URI="audio/stereo/none/128kbit.m3u8"
    //
    //    #EXT-X-MEDIA:TYPE=SUBTITLES,GROUP-ID="subs",NAME="Deutsch",DEFAULT=NO,AUTOSELECT=YES,FORCED=NO,LANGUAGE="de",URI="subtitles_de.m3u8"
    //    #EXT-X-MEDIA:TYPE=SUBTITLES,GROUP-ID="subs",NAME="English",DEFAULT=YES,AUTOSELECT=YES,FORCED=NO,LANGUAGE="en",URI="subtitles_en.m3u8"
    //    #EXT-X-MEDIA:TYPE=SUBTITLES,GROUP-ID="subs",NAME="Espanol",DEFAULT=NO,AUTOSELECT=YES,FORCED=NO,LANGUAGE="es",URI="subtitles_es.m3u8"
    //    #EXT-X-MEDIA:TYPE=SUBTITLES,GROUP-ID="subs",NAME="Français",DEFAULT=NO,AUTOSELECT=YES,FORCED=NO,LANGUAGE="fr",URI="subtitles_fr.m3u8"
    //
    //    #EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=258157,CODECS="avc1.4d400d,mp4a.40.2",AUDIO="stereo",RESOLUTION=422x180,SUBTITLES="subs"
    //    video/250kbit.m3u8
    //    #EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=520929,CODECS="avc1.4d4015,mp4a.40.2",AUDIO="stereo",RESOLUTION=638x272,SUBTITLES="subs"
    //    video/500kbit.m3u8
    //    #EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=831270,CODECS="avc1.4d4015,mp4a.40.2",AUDIO="stereo",RESOLUTION=638x272,SUBTITLES="subs"
    //    video/800kbit.m3u8
    //    #EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=1144430,CODECS="avc1.4d401f,mp4a.40.2",AUDIO="surround",RESOLUTION=958x408,SUBTITLES="subs"
    //    video/1100kbit.m3u8
    //    #EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=1558322,CODECS="avc1.4d401f,mp4a.40.2",AUDIO="surround",RESOLUTION=1277x554,SUBTITLES="subs"
    //    video/1500kbit.m3u8
    //    #EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=4149264,CODECS="avc1.4d4028,mp4a.40.2",AUDIO="surround",RESOLUTION=1921x818,SUBTITLES="subs"
    //    video/4000kbit.m3u8
    //    #EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=6214307,CODECS="avc1.4d4028,mp4a.40.2",AUDIO="surround",RESOLUTION=1921x818,SUBTITLES="subs"
    //    video/6000kbit.m3u8
    //    #EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=10285391,CODECS="avc1.4d4033,mp4a.40.2",AUDIO="surround",RESOLUTION=4096x1744,SUBTITLES="subs"
    //    video/10000kbit.m3u8
    //    """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        parseManifest(manifestString: manifestString)
        
        
        //        let subtitleLinks = parseSubtitles(manifest: manifest)
        //        print(subtitleLinks)
        
        
        //        let link = "https://www.example.com/folder1/folder2/filename.ext"
        //        print(substringToLastSlash(link: link)) // Output: filename.ext
        
        
        let link = "https://www.example.com/folder1/folder2/filename.ext"
        print(substringBeforeLastSlash(link: link)) // Output: https://www.example.com/folder1/folder2
        
        
        var parsed_link = substringBeforeLastSlash(link: link)
        var parsed_file = parseManifest(manifestString: manifestString)
        var total = parsed_link + parsed_file
        print("total   ", total)
        
        
        
        let url = URL(string: "https://example.com/file.m3u8")!
        print(checkURL(url)) // Output: .m3u8 file
        
    }
    
    func parseManifest(manifestString: String) -> String {
        let pattern = #"#EXTINF:\d+\.\d+,\n(.*)\n#"#
        let regex = try! NSRegularExpression(pattern: pattern)
        
        let matches = regex.matches(in: manifestString, range: NSRange(location: 0, length: manifestString.utf16.count))
        
        var subtitleFile = String()
        
        for match in matches {
            let range = match.range(at: 1)
            subtitleFile = (manifestString as NSString).substring(with: range)
            //            print("Subtitle file: \(subtitleFile)")
        }
        return subtitleFile
    }
    
    
    //    func parseSubtitles(manifest: String) -> [String: String] {
    //        var subtitleLinks: [String: String] = [:]
    //
    //        let lines = manifest.components(separatedBy: .newlines)
    //        for line in lines {
    //            if line.starts(with: "#EXT-X-MEDIA:TYPE=SUBTITLES") {
    //                let attributes = line.components(separatedBy: ",")
    //                var name: String?
    //                var uri: String?
    //
    //                for attribute in attributes {
    //                    if attribute.starts(with: "NAME=") {
    //                        name = attribute.replacingOccurrences(of: "NAME=", with: "")
    //                    } else if attribute.starts(with: "URI=") {
    //                        uri = attribute.replacingOccurrences(of: "URI=", with: "https://bitmovin-a.akamaihd.net/content/sintel/hls/")
    //                    }
    //                }
    //
    //                if let name = name, let uri = uri {
    //                    subtitleLinks[name] = uri
    //                }
    //            }
    //        }
    //
    //        return subtitleLinks
    //    }
    
    
    //    func substringToLastSlash(link: String) -> String {
    //        if let lastSlashIndex = link.range(of: "/", options: .backwards)?.upperBound {
    //            return String(link[lastSlashIndex...])
    //        } else {
    //            return ""
    //        }
    //    }
    
    func substringBeforeLastSlash(link: String) -> String {
        if let lastSlashIndex = link.range(of: "/", options: .backwards)?.upperBound {
            return String(link[..<lastSlashIndex])
        } else {
            return ""
        }
    }
    
    func checkURL(_ url: URL) -> String {
        let path = url.path
        if path.contains(".m3u8") {
            return ".m3u8 file"
        } else if path.contains(".vtt") {
            return ".vtt file"
        } else if path.contains(".srt") {
            return ".srt file"
        } else {
            return "None of the required file types found"
        }
    }

}
