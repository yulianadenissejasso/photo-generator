//
//  ContentView.swift
//  photo-generator
//
//  Created by Yuliana Denisse Jasso on 11/26/22.
//

import SwiftUI

//Asynchronous Image Loading from URL in SwiftUI
//Asynchronous: processed simultaneously with the rest of the content
//ObservableObject: A type of object with a publisher that emits before the object has changed
//Published: A type that publishes a property marked with an attribute

//Image Loading
class ViewModel: ObservableObject{
    //@published allows us to trigger a view and redraw whenever changes occur
    @Published var image: Image?
   
    //function to fetch a new image
    func fetchNewImage(){
        //more security using guard let: checks if it fails
        guard let url = URL(string: "https://picsum.photos/200") else{
            return
        }
        
        
        //creating a task to fetch data from URL
        //URLSession.shared.dataTask returns data directly to the app (in memory)
        let task = URLSession.shared.dataTask(with: url)
        {
            
            
            //URLSession.shared.dataTask(with: <#T##URLRequest#>, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
            data,_,_ in guard let data = data //making sure it is valid
            
            else{
            return
                }
        //executing on the main thread
        DispatchQueue.main.async{
        //creating a user interface image if it is there and check if it fails
        guard let uiImage = UIImage(data: data)else{return}
        self.image = Image(uiImage: uiImage)}
        }
        //Resumes the task, if it is suspended.
        task.resume()
    }
}

//Creating what we see
struct ContentView: View {
    //if the state of the viewModel changes, it tells this section that something has
    //to change here also
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        
        //allow us to place a title at the top
        NavigationView{
            //canvas that we are working with
            VStack{
                Spacer()
                
                if let image = viewModel.image{
                    image
                    
                }else{
                    //If there is no image, add pink frame
                    Image(systemName: "photo")
                        .resizable()
                        .foregroundColor(Color.pink)
                        .frame(width: 200, height: 200)
                        .padding()
                }
                
                Spacer()
                
                //Button Properties
                Button(action:{
                    //Assigning the button what to do
                    viewModel.fetchNewImage()
                }, label: {
                    Text("New Image!")
                        .bold()
                        .frame(width:250, height: 55)
                        .foregroundColor(Color.white)
                        .background(Color.brown)
                        .cornerRadius(50)
                        .padding()
                    
                })
                
            }
            //Main Title
            .navigationTitle("Photo Generator")
            
            
        }
 
    }

//Demonstrates the preview of the code above
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    
    }
}
}
