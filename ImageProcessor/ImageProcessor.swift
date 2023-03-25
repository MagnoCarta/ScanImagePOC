//
//  ImageProcessor.swift
//  ImageProcessingPOC
//
//  Created by Pedro Sousa on 21/03/23.
//

import UIKit
import CoreImage

typealias PixelIndex = (row: Int, col: Int)

class ImageProcessor {
    lazy private var context = CIContext()

    func render(ciImage: CIImage) -> UIImage {
        let cgImage = self.context.createCGImage(ciImage, from: ciImage.extent)
        return UIImage(cgImage: cgImage!)
    }
    
    func apply(filter: ImageModifier, to image: CIImage) -> CIImage {
        filter.apply(to: image)
    }

    func apply(filter: ImageModifier,
               to image: UIImage,
               options: [CIImageOption: Any]? = [:]) -> UIImage {
        let ciImage = CIImage(image: image, options: options)!
        let filteredImage = filter.apply(to: ciImage)
        return self.render(ciImage: filteredImage)
    }

    func countConnectedComponents(of image: UIImage) -> Int {
        let gray = generateGrayScaleMatrix(from: image)
        let threshold = im2bw(image: gray)
        let labels = bwlabel(threshold)
        return labels.numLabels
    }

    func im2bw(image: [[Double]], level: Double = -1.0) -> [[Int]] {
        var threshold = level
        
        if level < 0 {
            threshold = graythresh(image: image)
        } else if level.isNaN {
            // switch statement not available in Swift with string literals
            print("Invalid thresholding level.")
            return []
        } else if level == Double(Int.max) {
            let imageDouble = im2double(image: image)
            let flatImage = imageDouble.flatMap { $0 }
            let sum = flatImage.reduce(0, +)
            let mean = sum / Double(image.count * image[0].count)
            threshold = mean * 0.9
        }
        
        var binaryImage = [[Int]](repeating: [Int](repeating: 0, count: image[0].count), count: image.count)
        
        for row in 0..<image.count {
            for col in 0..<image[0].count {
                if image[row][col] >= threshold {
                    binaryImage[row][col] = 1
                }
            }
        }
        
        return binaryImage
    }

    func graythresh(image: [[Double]]) -> Double {
        let histogram = imhist(image: image)
        let totalPixels = Double(image.count * image[0].count)
        
        var sum = 0.0
        for i in 0..<256 {
            sum += Double(i) * Double(histogram[i])
        }
        
        var sumB = 0.0
        var wB = 0.0
        var wF = 0.0
        var mB = 0.0
        var mF = 0.0
        var betweenVar = 0.0
        var maxVar = 0.0
        var threshold = 0
        
        for i in 0..<256 {
            wB += Double(histogram[i])
            if wB == 0 {
                continue
            }
            wF = totalPixels - wB
            if wF == 0 {
                break
            }
            sumB += Double(i) * Double(histogram[i])
            mB = sumB / wB
            mF = (sum - sumB) / wF
            betweenVar = Double(wB) * Double(wF) * (mB - mF) * (mB - mF)
            if betweenVar > maxVar {
                maxVar = betweenVar
                threshold = i
            }
        }
        
        return Double(threshold) / 255.0
    }

    func imhist(image: [[Double]]) -> [Int] {
        var histogram = [Int](repeating: 0, count: 256)
        for row in 0..<image.count {
            for col in 0..<image[0].count {
                let pixel = Int(round(image[row][col]))
                histogram[pixel] += 1
            }
        }
        return histogram
    }

    func im2double(image: [[Double]]) -> [[Double]] {
        var doubleImage = [[Double]](repeating: [Double](repeating: 0.0, count: image[0].count), count: image.count)
        for row in 0..<image.count {
            for col in 0..<image[0].count {
                doubleImage[row][col] = image[row][col] / 255.0
            }
        }
        return doubleImage
    }


    func bwlabel(_ binaryImage: [[Int]]) -> (labeledImage: [[Int]], numLabels: Int) {
        var nextLabel = 1
        var labelMap = [[Int]](repeating: [Int](repeating: 0, count: binaryImage[0].count), count: binaryImage.count)
        var labeledImage = [[Int]](repeating: [Int](repeating: 0, count: binaryImage[0].count), count: binaryImage.count)
        var labels = [Int]()
        
        for i in 0..<binaryImage.count {
            for j in 0..<binaryImage[i].count {
                if binaryImage[i][j] == 1 {
                    let neighbors = getNeighbors(row: i, col: j, numRows: binaryImage.count, numCols: binaryImage[0].count)
                    var neighborLabels = [Int]()
                    
                    for neighbor in neighbors {
                        if labelMap[neighbor.row][neighbor.col] > 0 {
                            neighborLabels.append(labelMap[neighbor.row][neighbor.col])
                        }
                    }
                    
                    if neighborLabels.isEmpty {
                        labelMap[i][j] = nextLabel
                        labeledImage[i][j] = nextLabel
                        labels.append(nextLabel)
                        nextLabel += 1
                    } else {
                        neighborLabels.sort()
                        let minNeighborLabel = neighborLabels[0]
                        labelMap[i][j] = minNeighborLabel
                        labeledImage[i][j] = minNeighborLabel
                        
                        for neighborLabel in neighborLabels {
                            if neighborLabel != minNeighborLabel {
                                updateLabels(labels: &labels, oldLabel: neighborLabel, newLabel: minNeighborLabel)
                            }
                        }
                    }
                }
            }
        }
        
        for i in 0..<labeledImage.count {
            for j in 0..<labeledImage[i].count {
                if labeledImage[i][j] > 0 {
                    labeledImage[i][j] = labels[labeledImage[i][j] - 1]
                }
            }
        }
        
        let numLabels = Set(labels).count
        
        return (labeledImage, numLabels)
    }

    func getNeighbors(row: Int, col: Int, numRows: Int, numCols: Int) -> [PixelIndex] {
        var neighbors = [PixelIndex]()
        
        for i in -1...1 {
            for j in -1...1 {
                if i == 0 && j == 0 {
                    continue
                }
                
                let neighborRow = row + i
                let neighborCol = col + j
                
                if neighborRow >= 0 && neighborRow < numRows && neighborCol >= 0 && neighborCol < numCols {
                    neighbors.append(PixelIndex(row: neighborRow, col: neighborCol))
                }
            }
        }
        
        return neighbors
    }

    func updateLabels(labels: inout [Int], oldLabel: Int, newLabel: Int) {
        for i in 0..<labels.count {
            if labels[i] == oldLabel {
                labels[i] = newLabel
            }
        }
    }

    private func generateGrayScaleMatrix(from image: UIImage) -> [[Double]] {
        guard let cgImage = image.cgImage else {
            fatalError("Failed to get CGImage from image")
        }

        let width = cgImage.width
        let height = cgImage.height

        let context = CIContext(options: nil)
        guard let grayImage = context.createCGImage(
                                    CIImage(cgImage: cgImage).applyingFilter("CIPhotoEffectMono"),
                                    from: CGRect(x: 0, y: 0, width: width, height: height))
        else {
            fatalError("Failed to create grayscale CGImage")
        }

        let imageData = grayImage.dataProvider!.data!
        let pixelData = CFDataGetBytePtr(imageData)

        var matrix: [[Double]] = []
        for rowIndex in 0..<height {
            var row: [Double] = []
            for columnIndex in 0..<width {
                let pixelIndex = (rowIndex * width + columnIndex) * 4
                let value = Double(pixelData![pixelIndex])
                row.append(value)
            }
            matrix.append(row)
        }

        return matrix
    }
}
