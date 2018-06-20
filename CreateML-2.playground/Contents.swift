import Cocoa
import CreateML
import CoreML

let dataURL = URL(fileURLWithPath:"/Users/corpsrvmcoedevopsbld/Desktop/breast-cancer.csv")
let data = try MLDataTable(contentsOf: dataURL)
let (trainingData, testData) = data.randomSplit(by: 0.8, seed: 0)

let regressor = try MLRegressor(trainingData: data, targetColumn: "recurrence")

let metaData = MLModelMetadata(author: "Jason Bandy",
                               shortDescription: "A model to determine if a patient has a chance of breast cancer re-occurence.",
                               version: "1.0")

try regressor.write(to: URL(fileURLWithPath: "/Users/corpsrvmcoedevopsbld/Desktop/breast-cancer.mlmodel"),
                    metadata: metaData)

