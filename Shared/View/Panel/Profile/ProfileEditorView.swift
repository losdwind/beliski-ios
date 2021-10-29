//
//  ProfileEditorView.swift
//  Beliski
//
//  Created by Losd wind on 2021/10/29.
//

import SwiftUI
import MapKit





struct ProfileEditorView: View {
    
    @ObservedObject var profilevm:ProfileViewModel

    
    @State var birthday:Date = Date(timeIntervalSince1970: 0)
    @State var address:String = ""
    @State var jobCategory:String = ""
    @State var contactCategory:SocialMediaCategory = .linkedin

    var body: some View {
        Form{
            Section{
                HStack{
                    Text("Full Name")
                    TextField("Full Name", text: $profilevm.user.fullname ?? "", prompt: Text("e.g. Adam Smith"))
                }
                
                HStack{
                    Text("Gender")
                    Picker("Gender", selection: $profilevm.user.gender ?? "Male") {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                        Text("Misc.").tag("Misc.")
                    }
                    .pickerStyle(.segmented)
                }
                
                HStack{
                    Text("Birthday")
                    DatePicker("Birthday", selection: $birthday)
                }
                
                
                HStack{
                    Text("Address")
                    TextField("Address", text: $address, prompt: Text("No.181, Jiangjun Rd., Hechuan, Chongqing, CHINA "))
                }
                
                HStack{
                    Text("Contact")
                    
                    Picker("Contact Type", selection: $contactCategory){
                        ForEach(SocialMediaCategory.allCases, id:\.self){ category in
                            Image(category.rawValue).tag(category)
                        }
                    }
                    Button {
                        profilevm.connectSocialMedia(source: contactCategory, completion: {_ in})
                    } label: {
                        Text("Connect")
                            .buttonBorderShape(.capsule)
                    }

                }
                HStack{
                    Text("Job")
                    Picker("Category", selection: $jobCategory) {
                        ForEach(Array(JOBS.keys), id:\.self) { key in
                            Text(key).tag(key)
                        }
                    }
                    .pickerStyle(.menu)
                    

                    Picker("Job", selection:$profilevm.user.job){
                        ForEach(JOBS[jobCategory]!, id:\.self) { job in
                            Text(job).tag(job)
                        }
                                
                    }
                    .pickerStyle(.menu)

                }
                
                
                
            } header: {
                Text("Basic Infos")
            }
            
            
               
                
   
            }
        }
    }


struct ProfileEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditorView(profilevm: ProfileViewModel())
    }
}
