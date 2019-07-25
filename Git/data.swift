//
//  data.swift
//  
//
//  Created by Lorenzo Tabares on 11/11/18.
//

import Foundation
import Alamofire
import SwiftyJSON
import FutureKit
    let baseArtistURL = "https://api.spotify.com/v1/artists/"
    let baseTrackURL = "https://api.spotify.com/v1/tracks/"
    let baseAudioFeaturesURL = "https://api.spotify.com/v1/audio-features/"
    let baseSearchSongURL = "https://api.spotify.com/v1/search?q=name:"
    let baseSearchArtistURL = "https://api.spotify.com/v1/search?q=name:"
    var listAudiofeatures : [[Double]] = [[]]

//from requests_futures.sessions import FuturesSession

//    #########
//    #Must replace token HERE. Go to Spotify Developer Console, and generate a token on any of the API demo pages
var data1 = data()
class data{

    func main()
    {
        let token = "BQA5hkrilE7f60Bhe2P9iUmDk8Jw_jyMXC_c1l1VjaUut7yuFcfgZcYqGLy9-HCTBHYFOeXUOB700e6ef1kK_4u08HTHjq3z45f5ZBJkjOtP_w6EDTor-qIr6lO13o6qJr4_6sXzzvtKDyu1nmU"
        //    #########
        let artistID = "3TVXtAsR1Inumwj472S9r4" //Drake
        
        let header: HTTPHeaders  = ["Authorization" : "Bearer " + token]
        
        //    lazy var art = getArtist(artistID: artistID)
        
        let art = getArtist(artistID: artistID, header: header)
        print("000")
        print(art.id)
        print(art.name)
        getRelatedArtists(artists: [art], header: header)

//        var artists: [Artist] = getRelatedArtists(artists: [art], header: header)
//        for artist in artists{
//            print(artist.name)
//        }
//        print("done")
        
    }
    
    //    lazy var artist1 = getArtist(artistID: artistID)
}


class Track{
    let id, name, artist: String
    init(id: String, name: String, artist: String){
        self.id = id
        self.name = name
        self.artist = artist
    }
    var Features : AudioFeatures = AudioFeatures(acousticness: 0, danceability: 0, energy: 0, instrumentalness: 0, liveness: 0, speechiness: 0, tempo: 0, valence: 0)
}
class Artist{
    let id, name: String
    init(id: String, name: String){
        self.id = id
        self.name = name
    }
    var listOfTrack: [Track] = []
}

class AudioFeatures{
    let acousticness, danceability, energy, instrumentalness, liveness, speechiness, tempo, valence: Double
    var nparray: [Double] = []
    init(acousticness: Double, danceability: Double, energy: Double, instrumentalness: Double, liveness: Double, speechiness: Double, tempo: Double, valence: Double){
        self.acousticness = acousticness
        self.danceability = danceability
        self.energy = energy
        self.instrumentalness = instrumentalness
        self.liveness = liveness
        self.speechiness = speechiness
        self.tempo = tempo
        self.valence = valence
        self.nparray = [acousticness, danceability, energy, instrumentalness, liveness, speechiness, tempo, valence];
    }
}

func getArtist(artistID: String, header: HTTPHeaders) -> Artist{
    
        let url = baseArtistURL + artistID
        var id : String = ""
        var name: String = ""
        var artist: Artist = Artist(id:artistID, name:name)
        var param: Parameters  = [:]

//        Alamofire.request(url, headers: header).responseJSON{ response in
//            if (response.result.error == nil){
//                print("success")
//                print(response.result.value)
//                jsonArtist = JSON(response.result.value)
//                name = (jsonArtist["name"] as AnyObject? as? String) ?? ""
//                id = (jsonArtist["name"] as AnyObject? as? String) ?? ""
//                print(jsonArtist["name"])
//                print(jsonArtist["id"])
//
//            }else{
//                print("fail")
////                print(response.result.error)
//
//            }
//
////            print("JSON: \(jsonArtist)")
//        }
//            var jsonArtist: JSON = makeAlamofireRequest(url: url, header: header, )
        makeAlamofireRequest(url: url, header: header, param: param, completionhandler:{ response in ((Any)-> Artist).self;
                var jsonArtist: JSON = response as! JSON
                name = jsonArtist["name"].string!
                id = jsonArtist["id"].string!
                print(id)
                print(name)
                artist = Artist(id:artistID, name:name)
//                getArtistsTopTracks(artists: [artist], header: header)
            
            })
//            let artistFuture: Future<Any> = makeAlamofireRequest(url: url, header: header)
//            artistFuture.onComplete{(result) -> Any in
//                var jsonArtist: JSON = result as! JSON
//                name = jsonArtist["name"].string!
//                id = jsonArtist["name"].string!
//                print(id)
//                print("dsjhf")
//                print(name)
//                artist = Artist(id:artistID, name:name)
//                }
//        return artist
            print(id)
            print(name)
            print("111")
        //        let artist = Artist(id=jsonArtist["id"], name=jsonArtist["name"])
        return artist
//        return "sjhdjf"
    
    }


//func jsonToString(json: AnyObject){
//    do {
//        let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
//        let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
//        print(convertedString) // <-- here is ur string
//
//    } catch let e {
//        print(e)
//    }
//
//}
//    #This function requires a list (array) of artist objects. If you only want one artist just give a list of one artist as input
//    #Requires a list to take advantage of concurrent requests
func makeAlamofireRequest(url: String, header: HTTPHeaders, param: Parameters, completionhandler: @escaping (Any) -> Void)
{
    var json: JSON = ""
    var artist: Artist = Artist(id:"", name:"")
//     Alamofire.request(url, headers: header)
//        .FutureJSONObject(){
//
//    }
    Alamofire.request(url, parameters: param, headers: header).responseJSON{ response in
        if (response.result.error == nil){
            json = JSON(response.result.value)
            completionhandler(json as Any)
//            print(json)
        }else{
            print("fail")
            //                print(response.result.error)
            json = "NULL"
        }
    }

}
func getRelatedArtists(artists: [Artist], header: HTTPHeaders) -> Void{

        var futures: [JSON] = []
        var listOfSimilarArtists :[Artist] = []
        var listOfSimilarArtistsNames : [String] = []
//        let configuration = URLSessionConfiguration.default
//        let session = Alamofire.SessionManager(configuration: configuration)
        for artist in artists{
            let url = baseArtistURL + artist.id + "/related-artists/"
            var param: Parameters  = [:]
            makeAlamofireRequest(url: url, header: header, param: param){ response in
                var jsonArtists: JSON = response as! JSON
                let jsonA : JSON = jsonArtists["artists"]
                var i: Int = 0
                while(jsonA[i]["name"] != JSON.null)
                {

                    let name : String = jsonA[i]["name"].string!
                    let id : String = jsonA[i]["id"].string!
                    var notInList : Bool = true
                    for listOfSimilarArtistsName in listOfSimilarArtistsNames{
                        if(name == listOfSimilarArtistsName){
                            notInList = false
                        }
                    }
                    if(notInList)
                    {
                        listOfSimilarArtists.append(Artist(id: id, name: name))
                        listOfSimilarArtistsNames.append(name)
                        getArtistsTopTracks(artists: [Artist(id: id, name: name)], header: header)
                        
                    }
                    i = i + 1
                }

            }

        }

        print("Retrieving Similar Artists...")
}
////    #This function requires a list (array) of artist objects. If you only want one artist just give a list of one artist as input
////    #Requires a list to take advantage of concurrent requests
func getArtistsTopTracks(artists: [Artist], header: HTTPHeaders)->Void{

//        params = {"country" : 'US'}
        var param: Parameters  = ["country" : "US"]


        for artist in artists
        {
            let url = baseArtistURL + artist.id + "/top-tracks/"
            var param: Parameters  = ["country" : "US"]
            makeAlamofireRequest(url: url, header: header, param: param){ response in
                var jsonArtists: JSON = response as! JSON
//                print(jsonArtists)
                let json : JSON = jsonArtists["tracks"]
                var i: Int = 0
                while(json[i]["name"] != JSON.null)
                {
                    let name : String = json[i]["name"].string!
                    let id : String = json[i]["id"].string!
//                    print(name)
//                    print(id)
                    getAudioFeatures(artist: artist, track: Track(id: id, name: name, artist: artist.name), header: header)
                    i = i + 1
                }
                
                
            }




//        var listOfTopTracks = []
//
//        for index, future in enumerate(futures):
//
//            jsonListOfTopTracks = future.result().json()['tracks']
//
//            for jsonTopTrack in jsonListOfTopTracks:
//
//                listOfTopTracks.append(Track(id=jsonTopTrack['id'], name=jsonTopTrack['name'], artist=artists[index]))
    }

}

func getAudioFeatures(artist: Artist, track: Track, header: HTTPHeaders)->Void{
    
    let param: Parameters  = ["ids" : track.id]
    let url = baseAudioFeaturesURL
    usleep(100000)
    makeAlamofireRequest(url: url, header: header, param: param){ response in
        var jsonArtists: JSON = response as! JSON
        let features : JSON = jsonArtists["audio_features"][0]
//        print(jsonArtists)
        let acousticness : Double = features["acousticness"].double!
        let danceability : Double = features["danceability"].double!
        let energy : Double = features["energy"].double!
        let instrumentalness : Double = features["instrumentalness"].double!
        let liveness : Double = features["liveness"].double!
        let speechiness : Double = features["speechiness"].double!
        let tempo : Double = features["tempo"].double!
        let valence : Double = features["valence"].double!
//        print(acousticness)
//        print(danceability)
//        print(energy)
//        print(instrumentalness)
//        print(liveness)
//        print(speechiness)
//        print(acousticness)
//        print(tempo)
//        print(valence)
        print(artist.name, track.name, "acousticness ", acousticness, separator:" ")
        
        track.Features = AudioFeatures(acousticness: acousticness, danceability: danceability, energy: energy, instrumentalness: instrumentalness, liveness: liveness, speechiness: speechiness, tempo: tempo, valence: valence)
        track.Features.nparray = [acousticness, danceability, energy, instrumentalness, liveness, speechiness, tempo, valence]
        artist.listOfTrack.append(track)
        listAudiofeatures.append([acousticness, danceability, energy, instrumentalness, liveness, speechiness, tempo, valence])
        let ML : MLmodel = MLmodel(Audiodata: [track.Features.nparray], clusters: 1)//2d with playlist audio features
        ML.createmodel()
        ML.predict(Data: [track.Features.nparray]) //2d array of 1 element
        

    }
    
}

