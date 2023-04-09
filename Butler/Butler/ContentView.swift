//
//  ContentView.swift
//  Butler
//
//  Created by NMS15065-7-adisara on 3/21/23.
//

import SwiftUI

func copyStringToClipboard(_ string: String) {
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(string, forType: .string)
}

struct ContentView: View {
    @State var textField = ""
    @EnvironmentObject var connector: OpenAIConnector
    let dataManager = DataManager()
    var body: some View {
        VStack {
            ScrollView {
                ForEach(connector.messageLog) { message in
                    if message["role"] != "system" {
                        MessageView(message: message)
                    }
                }
            }
            
            Divider()
            
            
            HStack {
                TextField("Type here", text: $textField)
                Button("Send") {
                    connector.logMessage(textField, messageUserType: .user)
                    connector.sendToAssistant()
                    print("messageLog")
                }
            }
            Divider()
            HStack {
                Button("Set As API Key") {
                    dataManager.push(key: .Butler_UserOpenAIKey, content: textField.filter { !" \n\t\r".contains($0) })
                }
                
                Button("Quit") {
                    exit(0)
                }
            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(OpenAIConnector())
    }
}

struct MessageView: View {
    var message: [String: String]
    
    var messageColor: Color {
        if message["role"] == "user" {
            return .gray
        } else if message["role"] == "assistant" {
            return .blue
        } else {
            return .red
        }
    }
    
    var bubbleDirection: ChatBubbleShape.Direction {
        if message["role"] == "user" {
            return .right
        } else if message["role"] == "assistant" {
            return .left
        } else {
            return .right
        }
    }
    
    var body: some View {
        HStack {
            if message["role"] == "user" {
                Spacer()
            }
            
            ChatBubble(direction: bubbleDirection) {
                Text(message["content"] ?? "error")
                    .padding(.all, 15)
                    .foregroundColor(Color.white)
                    .background(messageColor.opacity(0.4))
            }
            
            if message["role"] == "assistant" {
                Button("Copy") {
                    copyStringToClipboard(message["content"] ?? "error")
                }
                Spacer()
            }
        }
    }
}

struct ChatBubble<Content>: View where Content: View {
    let direction: ChatBubbleShape.Direction
    let content: () -> Content
    init(direction: ChatBubbleShape.Direction, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.direction = direction
    }
    
    var body: some View {
        HStack {
            if direction == .right {
                Spacer()
            }
            content().clipShape(ChatBubbleShape(direction: direction))
            if direction == .left {
                Spacer()
            }
        }
    }
}

struct ChatBubbleShape: Shape {
    enum Direction {
        case left
        case right
    }
    
    let direction: Direction
    
    func path(in rect: CGRect) -> Path {
        return (direction == .left) ? getLeftBubblePath(in: rect) : getRightBubblePath(in: rect)
    }
    
    private func getLeftBubblePath(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: 25, y: height))
            p.addLine(to: CGPoint(x: width - 20, y: height))
            p.addCurve(to: CGPoint(x: width, y: height - 20),
                       control1: CGPoint(x: width - 8, y: height),
                       control2: CGPoint(x: width, y: height - 8))
            p.addLine(to: CGPoint(x: width, y: 20))
            p.addCurve(to: CGPoint(x: width - 20, y: 0),
                       control1: CGPoint(x: width, y: 8),
                       control2: CGPoint(x: width - 8, y: 0))
            p.addLine(to: CGPoint(x: 21, y: 0))
            p.addCurve(to: CGPoint(x: 4, y: 20),
                       control1: CGPoint(x: 12, y: 0),
                       control2: CGPoint(x: 4, y: 8))
            p.addLine(to: CGPoint(x: 4, y: height - 11))
            p.addCurve(to: CGPoint(x: 0, y: height),
                       control1: CGPoint(x: 4, y: height - 1),
                       control2: CGPoint(x: 0, y: height))
            p.addLine(to: CGPoint(x: -0.05, y: height - 0.01))
            p.addCurve(to: CGPoint(x: 11.0, y: height - 4.0),
                       control1: CGPoint(x: 4.0, y: height + 0.5),
                       control2: CGPoint(x: 8, y: height - 1))
            p.addCurve(to: CGPoint(x: 25, y: height),
                       control1: CGPoint(x: 16, y: height),
                       control2: CGPoint(x: 20, y: height))
            
        }
        return path
    }
    
    private func getRightBubblePath(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: 25, y: height))
            p.addLine(to: CGPoint(x:  20, y: height))
            p.addCurve(to: CGPoint(x: 0, y: height - 20),
                       control1: CGPoint(x: 8, y: height),
                       control2: CGPoint(x: 0, y: height - 8))
            p.addLine(to: CGPoint(x: 0, y: 20))
            p.addCurve(to: CGPoint(x: 20, y: 0),
                       control1: CGPoint(x: 0, y: 8),
                       control2: CGPoint(x: 8, y: 0))
            p.addLine(to: CGPoint(x: width - 21, y: 0))
            p.addCurve(to: CGPoint(x: width - 4, y: 20),
                       control1: CGPoint(x: width - 12, y: 0),
                       control2: CGPoint(x: width - 4, y: 8))
            p.addLine(to: CGPoint(x: width - 4, y: height - 11))
            p.addCurve(to: CGPoint(x: width, y: height),
                       control1: CGPoint(x: width - 4, y: height - 1),
                       control2: CGPoint(x: width, y: height))
            p.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
            p.addCurve(to: CGPoint(x: width - 11, y: height - 4),
                       control1: CGPoint(x: width - 4, y: height + 0.5),
                       control2: CGPoint(x: width - 8, y: height - 1))
            p.addCurve(to: CGPoint(x: width - 25, y: height),
                       control1: CGPoint(x: width - 16, y: height),
                       control2: CGPoint(x: width - 20, y: height))
            
        }
        return path
    }
}
