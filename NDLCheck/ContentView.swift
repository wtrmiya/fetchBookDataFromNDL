//
//  ContentView.swift
//  NDLCheck
//
//  Created by Wataru Miyakoshi on 2024/03/14.
//

import SwiftUI
import SWXMLHash

struct ContentView: View {
    var body: some View {
        VStack {
            Button(action: fetchTitleFromNDL, label: {
                Text("Button")
            })
        }
        .padding()
    }
    
    private func fetchTitleFromNDL() {
        Task {
            do {
                let isbn = "9784046067234"
                let url = URL(string: "https://ndlsearch.ndl.go.jp/api/sru?operation=searchRetrieve&query=isbn=\"\(isbn)\"")!
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let resultXmlString = String(data: data, encoding: .utf8)
                else { return }
                let title = parseXMLStringToFetchBookTitle(xml: resultXmlString)
                print(title)
            } catch {
                print(error)
            }

        }
    }
    
    private func parseXMLStringToFetchBookTitle(xml outerXmlString: String) -> String {
        let outerXml = XMLHash.parse(outerXmlString)
        guard let recordDataElementText = outerXml["searchRetrieveResponse"]["records"]["record"]["recordData"].element?.text
        else {
            print("cannot parse")
            return ""
        }
        
        let recordDataXml = XMLHash.parse(recordDataElementText)
        guard let title = recordDataXml["srw_dc:dc"]["dc:title"].element?.text
        else {
            print("cannot parse")
            return ""
        }
        
        return title
    }
}

#Preview {
    ContentView()
}

