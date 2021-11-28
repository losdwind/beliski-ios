//
//  WoopDetailView.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/28.
//

import SwiftUI

struct WoopDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let attrStr = try! AttributedString(markdown: woopDetail, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
        VStack(alignment: .leading, spacing: 20){
            HStack{
                
                Button {
                    
                    withAnimation{
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
            }
            .overlay(
                
                Text("WOOP")
                    .font(.system(size: 18))
            )
            
            
            
            Text(attrStr)
                .foregroundStyle(.primary, .gray, .pink)
            
        }
    }
        .padding()
        .background(Color.gray.opacity(0.2))
        
    }
}

struct WoopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WoopDetailView()
    }
}


let woopDetail = """
# How to Use WOOP to Accomplish Your Big Goals
There has been [a lot of buzz](http://www.businessinsider.com/gabriele-oettingen-woop-2016-6) recently about WOOP. No, not the sound you make when you're really excited about something. We're talking about W.O.O.P., a productivity solution developed by Dr. Gabriele Oettingen that provides a framework for accomplishing big goals one step at a time. W.O.O.P. stands for "Wish, Outcome, Obstacle, Plan," and it outlines the four steps that make it most easy for you to actually accomplish your goals.

![productivity solutions for productivity in the workplace](https://www.commandhound.com/wp-content/uploads/2019/05/1_Two20creative20millenial20small20business20owners20working20on20social20media20strategy20brainstorming20using20adhesive20notes20in20windows.jpg "productivity solutions for productivity in the workplace")\
**Realizing goals requires effort, wishing alone is not enough**

We are all surrounded by things that distract us from our goals. The internet is constantly providing new articles, social media posts, and cat GIFs that lure us in and to prevent us from focusing on important tasks.\
At the office, chatty coworkers and needless meetings stop us from actually getting things done. A myriad of other tasks and distractions get in the way of accomplishing both our personal and our professional goals to increase productivity in the workplace.

## How Does W.O.O.P. Work

So how does the W.O.O.P. system actually help with outlining goals and achieving them? The process is based on the simple idea that "[the obstacles that we think most impede us from fulfilling our wishes can actually help us to realize them](http://woopmylife.org/woop-1/)." It consists of four simple steps that help you figure out what your goal is, what is getting in the way, and how to overcome those obstacles:

### Step 1: Wish

-   Come up with your goal. What do you want to accomplish? A wish should be exciting, challenging, and realistic.
-   *Ex. I would like to be promoted to the position of VP*

### Step 2: Outcome

-   What is your desired outcome? If everything goes right, what will happen?
-   Think about how accomplishing your goal will make you feel.
-   *Ex. If I am promoted, I will feel good about myself because I have more responsibility and a larger salary.*

### Step 3: Obstacle

-   Imagine the personal obstacles that are preventing you from accomplishing your goal.
-   *Ex. When my manager asks me to finish a task, I often turn it in late because I get easily distracted by emails. *

### Step 4: Plan

-   Develop a plan for how to overcome these obstacles.
-   Think of a simple action or thought that can help you overcome each obstacle, then develop an If/Then plan for it.
-   *Ex. If I find myself being distracted from the tasks my manager wants me to finish, I will close my email and redirect my attention to that task.*

## Ideas and Action

![goals for productivity in the workplace](https://www.commandhound.com/wp-content/uploads/2019/05/1_A20Goal20Without20a20Plan20Is20Just20A20Wish20sign20with20a20desert20background.jpg "goals for productivity in the workplace")\
**WOOP provides a simple framework to turn goals into reality**

This process gets at the crucial intersection between ideas and action. It is only by putting your goals, dreams, and ideas into individual steps that you can actually achieve them. W.O.O.P. allows you to envision your goals and then to [develop a concrete plan](safari-reader://www.commandhound.com/stop-spinning-your-wheels-and-get-things-done) to make sure that they actually get done.\
Automate certain steps along the way. If you outsource the reminders that keep you on task and on track to achieving your goal, you can spend more mental energy on bigger ideas and problems.\
If you plan to increase communication with your manager, for example, by checking in with her once a day, use an automated system that reminds you to send your manager an email or to stop by their desk at 4pm each day.\
This concrete, daily progress on your goal will keep you motivated and oriented towards the big picture. Because you don't have to worry about scheduling the meeting *every* *day* or reminding yourself to talk to your manager, you also give yourself more time to devote to excelling at other tasks.\
Turn your goals into action by automating the small steps. When those small steps all come together, you will find yourself much closer to your goal than you ever thought possible.

## Making Progress on Your Goals

So what sorts of productivity solutions can you use to automate the small steps on the way to your big goal? A task management and accountability software like [CommandHound](https://www.commandhound.com/) allows you to assign yourself individual tasks and track your progress over time to increase your productivity in the workplace.\
CommandHound also allows your manager to see how well you are doing at accomplishing tasks on time, or to involve team members in the completion of complex but critical tasks.\
Software like CommandHound can be an invaluable partner to help you make steady progress towards your big goals.\
Would you like to learn more?

[Learn More about CommandHound](safari-reader://www.commandhound.com/?p=2464)
"""

