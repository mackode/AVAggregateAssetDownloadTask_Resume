import UIKit
import AVFoundation

class ViewController: UIViewController, AVAssetDownloadDelegate {

    let streamUrl = "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8"
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        let config = URLSessionConfiguration.background(withIdentifier: "UNIQUE_DEMO_SESSION")
        let session = AVAssetDownloadURLSession(configuration: config, assetDownloadDelegate: self, delegateQueue: OperationQueue.main)
        
        session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            // NOTE: empty for aggregateAssetDownloadTask
            print("Tasks: \(dataTasks.count) \(uploadTasks.count) \(downloadTasks.count)")
        }
        
        session.getAllTasks { tasks in
            // try to resume task that were stopped
            tasks.forEach { task in
                task.resume()
            }
            guard tasks.isEmpty else { return }
            
            let asset = AVURLAsset(url: URL(string: self.streamUrl)!)
            let task = session.aggregateAssetDownloadTask(with: asset, mediaSelections: [asset.preferredMediaSelection], assetTitle: "UNIQUE_ASSET_TITLE", assetArtworkData: nil)

            task?.resume()
        }
	}
    
    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        print("didFinishDownloadingTo \(location)")
    }
    
    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange) {
        print("didLoad [\(timeRange.start.seconds + timeRange.duration.seconds)/\(timeRangeExpectedToLoad.duration.seconds)]")
    }
    
    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didResolve resolvedMediaSelection: AVMediaSelection) {
        print("didResolve")
    }
    
    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, willDownloadTo location: URL) {
        print("willDownloadTo \(location)")
    }
    
    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, didCompleteFor mediaSelection: AVMediaSelection) {
        print("didCompleteFor")
    }
    
    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange, for mediaSelection: AVMediaSelection) {
        print("didLoad aggregateAssetDownloadTask [\(timeRange.start.seconds + timeRange.duration.seconds)/\(timeRangeExpectedToLoad.duration.seconds)]")
    }
}

