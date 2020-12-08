//
//  PDF.swift
//  GAI
//
//  Created by Александр on 01.12.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation
import UIKit

func exportAsPdfFromTable(tb: UITableView, name: String) -> String {
    let originalBounds = tb.bounds
    tb.bounds = CGRect(x:originalBounds.origin.x, y: originalBounds.origin.y, width: tb.contentSize.width, height: tb.contentSize.height)
    let pdfPageFrame = CGRect(x: 0, y: 0, width: tb.bounds.size.width, height: tb.contentSize.height)
    
    let pdfData = NSMutableData()
    UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
    UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
    guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
    tb.layer.render(in: pdfContext)
    UIGraphicsEndPDFContext()
    tb.bounds = originalBounds
    // Save pdf data
    return saveTablePdf(data: pdfData, name: name)
}

func saveTablePdf(data: NSMutableData, name: String) -> String {
    
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let docDirectoryPath = paths[0]
    let pdfPath = docDirectoryPath.appendingPathComponent(name)
    if data.write(to: pdfPath, atomically: true) {
        return pdfPath.path
    } else {
        return ""
    }
}

