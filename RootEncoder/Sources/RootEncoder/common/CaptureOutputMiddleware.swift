//
//  File.swift
//  
//
//  Created by Vitaliy Kuzmenko on 15.08.2024.
//

import Foundation
import AVFoundation

public protocol CaptureOutputMiddleware: AnyObject {
    
    var identifier: AnyHashable { get }
    
    var isActive: Bool { get set }
    
    @discardableResult
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection, in captureSession: AVCaptureSession) -> CMSampleBuffer
    
}
