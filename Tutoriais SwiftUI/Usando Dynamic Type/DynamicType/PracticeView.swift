//
//  PracticeView.swift
//  DynamicType
//
//  Created by Joel Davies on 1/2/24.
//
//  os26 version July 2025


import SwiftUI

struct PracticeView: View {    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    var body: some View {
        let dynamicHStack = dynamicTypeSize >= .xxLarge ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
        
        let dynamicHStackAX2 = dynamicTypeSize > .accessibility2 ? AnyLayout(VStackLayout(alignment: .leading, spacing: 20)) : AnyLayout(HStackLayout())
        
        let dynamicVStack = dynamicTypeSize < .xxLarge ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
        
        ScrollView{
            VStack(alignment: .leading) {
                
                Text("Time to Practice")
                    .font(.title)
                    .bold()
                
                Text("Redesign all the elements on this screen to support beautiful dynamic type. Please look at the various views to check, copy, and improve the code and design on this screen.")
                    .font(.body)
                
                //MARK: There's no one perfect answer to what can be used below to make an amazing and accessible screen. Show me what you've got. Feel free to really play with these elements to give amazing hierarchy and dynamic type support. I'm doing a minimal amount of formatting, so have fun with color, font weight, font width, etc...
                Spacer().padding(10)
                Group {
                    //MARK: button array
                    dynamicHStack {
                        dynamicVStack {
                            Image(systemName: "scissors")
                                .padding(.leading, dynamicTypeSize >= .xxLarge ? 10 : 0)
                            Text("Cut")
                                .padding(.vertical, dynamicTypeSize >= .xxLarge ? 10 : 0)
                            Spacer().frame(height: 0)
                        }.dynaButtonBG()
                        dynamicVStack {
                            Image(systemName: "doc.on.doc.fill")
                                .padding(.leading, dynamicTypeSize >= .xxLarge ? 10 : 0)
                            Text("Copy")
                                .padding(.vertical, dynamicTypeSize >= .xxLarge ? 10 : 0)
                            Spacer().frame(height: 0)
                        }.dynaButtonBG()
                        dynamicVStack {
                            Image(systemName: "doc.on.clipboard")
                                .padding(.vertical, dynamicTypeSize >= .xxLarge ? 10 : 0)
                            Text("Paste")
                                .padding(.leading, dynamicTypeSize >= .xxLarge ? 10 : 0)
                            Spacer().frame(height: 0)
                        }.dynaButtonBG()
                        dynamicVStack {
                            Image(systemName: "arrow.uturn.backward.circle.fill")
                                .padding(.vertical, dynamicTypeSize >= .xxLarge ? 10 : 0)
                            Text("Undo")
                                .padding(.leading, dynamicTypeSize >= .xxLarge ? 10 : 0)
                            Spacer().frame(height: 0)
                        }.dynaButtonBG()
                    }
                }
                Spacer().padding(10)
                Group{
                    //MARK: Cardview
                    VStack {
                        dynamicHStack{
                            Image("joelHulkCropped")
                                .resizable()
                                .scaledToFit()
                                .padding(.vertical, dynamicTypeSize >= .xxLarge ? 10 : 0)
                            //MARK: The above image might get tricky to work with when supporting dynamic type, so be ready to make adjustments...
                            VStack(alignment: .leading){
                                Text("Joel Davies")
                                    .bold()
                                Text("Accessibility Hulk")
                                Text("WorldWide Apple Developer Academies").foregroundStyle(.secondary)
                            }
                        }
                        
                        dynamicHStackAX2 {
                            ViewThatFits {
                                Label("Add Contact", systemImage: "person.crop.circle.badge.plus")
                                Label("Add", systemImage: "person.crop.circle.badge.plus")
                            }
                            ViewThatFits {
                                Label("Send Message", systemImage:"plus.message")
                                Label("Message", systemImage:"plus.message")
                                Label ("Msg", systemImage:"plus.message")
                            }

                            Label("Call", systemImage: "phone")
                            
                        }
                        .font(.callout)
                        .padding(.vertical, 4)
                    }
                    .padding(8)
                    .background(in:RoundedRectangle(cornerRadius: 16))
                    .foregroundStyle(.primary)
                    .backgroundStyle(.quinary)
                }
            }
        }
        .padding()
        
    }
}

#Preview {
    PracticeView()
}
