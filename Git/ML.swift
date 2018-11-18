//
//  ML.swift
//  Git
//
//  Created by Lorenzo Tabares on 11/16/18.
//  Copyright © 2018 Josh Lubow. All rights reserved.
//

import Foundation
import Accelerate
import AIToolbox
import simd

//AIToolbox library for pca
//MLDataSet, MLClassificationDataSet

class MLmodel{
    let Audiodata : [[Double]]
    let clusters : Int
    var OGData : (Any)? = nil
    init(Audiodata: [[Double]], clusters: Int)
    {
        self.Audiodata = Audiodata
        self.clusters = clusters
    }
    func createmodel()
    {
        
        var MLData : MLClassificationDataSet  = convertData(Auddata: self.Audiodata)
        var transformData : MLClassificationDataSet = convertData(Auddata: self.Audiodata)
        do{
            try pca.getReducedBasisVectorSet(MLData)
        }
        catch {
            print("pca error")
        }
        do{
            try transformData = pca.transformDataSet(MLData)
            OGData = transformData
        }
        catch{
            print("pca transform error")
        }
        kmeans = KMeans(classes: clusters)
        do{
            try kmeans.train(transformData)
        }
        catch{
            print("kmeans error")
        }
        let center = kmeans.centroids[0]
        
    }
    func predict(Data: [[Double]]) -> Bool{
        var MLData : MLClassificationDataSet  = convertData(Auddata: self.Audiodata)
        var transformData : MLClassificationDataSet = convertData(Auddata: self.Audiodata)
        var datapoint : [Double]
        var olddatapoint : [Double]
        do{
            try transformData = pca.transformDataSet(MLData)
        }
        catch{
            print("pca transform error")
        }
        do{

            try datapoint = transformData.getInput(0)
            let centriod = simd_float2(x: Float(kmeans.centroids[0][0]), y: Float(kmeans.centroids[0][1]))
            let newdataP = simd_float2(x: Float(datapoint[0]), y: Float(datapoint[1]))
            for i in 0..<(OGData as! MLClassificationDataSet).size{
                try olddatapoint = (OGData as! MLClassificationDataSet).getInput(i)
                let olddataP = simd_float2(x: Float(olddatapoint[0]), y: Float(olddatapoint[1]))
                if simd_distance_squared(newdataP, centriod) < simd_distance_squared(olddataP, centriod) {
                    return true
                }
            }
            
            
        }
        catch{
            print("kmeans predict error")
        }
       return false
    }
    func convertData(Auddata : [[Double]])-> MLClassificationDataSet
    {
        let trainData = DataSet(dataType: .classification, inputDimension: 8, outputDimension: 1)
        do{
            let datas = Auddata
            for data in datas{
                try trainData.addUnlabeledDataPoint(input: data)
                try trainData.addUnlabeledDataPoint(input: [0,1,0.5,0,0.7,1.2,0.3,0.75])
            }
            
        }
        catch{
            print("convert data error")
        }
        return trainData
    }
    
    var newAudiodata : [Double] = []
    var kmeans : KMeans = KMeans(classes: 1)
    var pca : PCA = PCA(initialSize: 8, reduceSize: 2)
//    var MLAudioData : MLDataSet = MLDataSet
}





