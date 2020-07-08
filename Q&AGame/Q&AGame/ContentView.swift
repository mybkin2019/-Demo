//
//  ContentView.swift
//  Q&AGame
//
//  Created by billbill on 2020/7/7.
//  Copyright © 2020 billbill. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	
	@State var score: Int = 0
	@State var questionIndex = 0
	
	@State var isShowAlert = false
	
	@State var finalScore: Int = 0
	
	var dataModel: DataModel = DataModel()
	
	// 用来控制云朵的漂浮范围
	var offsetCloud1: Int = Int.random(in: 5...15)
	var offsetCloud2: Int = Int.random(in: 5...15)
	
	@State var StartMoving: Bool = false
	
	// 重置所有数据
	func updataDataForRestart() {
		questionIndex = 0
		score = 0
	}
	
	// 用来作弊的一个功能 把答案显示在 questionNumber 旁边
	func tips(dataModel: DataModel, index: Int) -> String {
		let tips = String(dataModel.isTrue[index])
		return tips
	}
	
    var body: some View {
		// UI 设计效果
		
		return VStack {
			Spacer()
			Text("猜猜游戏")
				.font(.largeTitle)
				.frame(width: UIScreen.main.bounds.width)
				.background(
					LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
					.blur(radius: 10)
					.opacity(0.3)
				)
				.padding()
				
			Spacer()
				.frame(height: 75)
			Text("显示第 \(questionIndex+1) 题 \(tips(dataModel: dataModel, index: questionIndex))")
				.font(.system(size: 20))
				.foregroundColor(.white)
				.frame(width: 200, height: 40)
				.background(
					RoundedRectangle(cornerRadius: 20, style: .continuous)
						.foregroundColor(.blue)
				)
				.shadow(radius: 20)
				// 当这个 label 控件出现的时候 就会执行 StartMoving 反向 让触发让云朵 offset 位移
				// 配上特效就是云飘起来
				.onAppear {
					self.StartMoving.toggle()
				}
			
			// 从实例化的 dataModel 中取到 contentOfQuestions String 数组 然后用下标取到具体的题目
			Text(dataModel.contentOfQuestion[questionIndex])
				.fontWeight(.bold)
				.font(.system(size: 25))
				.multilineTextAlignment(.center)
				.modifier(QuestionPanelModifier())
			// false true 按钮模块
			HStack{
				// false button
				Button(action: {
					
					if self.dataModel.isTrue[self.questionIndex] == false {
						self.score += 1
					} else {
						
					}
					self.questionIndex += 1
					if self.questionIndex == self.dataModel.contentOfQuestion.count {
						// 当正常情况下 questionIndex 是要比 题目数量.count 少一的 因为用于下标
						// 当两个数相等的时候
						// 显示的这题已经是最后一题了,如果把 questionIndex 继续传下去显示超出下标的下一题的话就会出事
						// fatal error out of index
						// 所以这里要做截停 重置 questionIndex
						self.finalScore = self.score
						self.isShowAlert = true
						self.updataDataForRestart()
					}
					
				}) { // label 外包装模块
					Text("false")
						.font(.system(size: 20))
						.foregroundColor(.white)
						.frame(width: 100, height: 100*0.3)
						.background(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
						.clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
				}
				.padding()
				.shadow(radius: 20)
				
				Spacer()
				Button(action: {
					
					if self.dataModel.isTrue[self.questionIndex] {
						self.score += 1
					} else {
						
					}
					
					self.questionIndex += 1
					if self.questionIndex == self.dataModel.contentOfQuestion.count {
						self.finalScore = self.score
						self.isShowAlert = true
						self.updataDataForRestart()
					}
					
				}) {
				Text("true")
					.foregroundColor(.white)
					.font(.system(size: 20))
					.frame(width: 100, height: 100*0.3)
					.background(Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)))
					.clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
				}
				.padding()
				.shadow(radius: 20)
				
			}
			.padding(.horizontal)
			Spacer()
			// 分数显示模块
			VStack {
				HStack {
					Spacer()
					Text("Score: \(score)")
						.foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
						.font(.system(.headline))
						.padding(.trailing, 40)
				}
				// 用答题成功的题目数量去控制 width
				// total Width -> UIScreen.main.bounds.width - 30
				HStack {
					RoundedRectangle(cornerRadius: 10, style: .continuous)
						.foregroundColor(Color(#colorLiteral(red: 0.6663457306, green: 0.601424956, blue: 0.9803921569, alpha: 1)))
						.frame(width: UIScreen.main.bounds.width / CGFloat(dataModel.contentOfQuestion.count) * CGFloat(self.score)+10, height: 20)
						.padding(.horizontal)
						.animation(.linear(duration: 1))
					Spacer()
				}
				.padding()
			}
			
		}
			// 弹出警告效果
		.alert(isPresented: $isShowAlert, content: { () -> Alert in
			Alert(title: Text("恭喜🎆"),
				  message: Text("你的得分为 \(self.finalScore) !!!"),
				  dismissButton: .default(Text("再来一遍👍")))
		})
		.frame(width: UIScreen.main.bounds.width)
		.background(
			ZStack {
				Rectangle()
					.foregroundColor(.clear)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.background(
					LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))]), startPoint: .top, endPoint: .bottom)
				)
				VStack {
					HStack {
						Image("cloud1")
							.resizable()
							.scaledToFit()
							// 让初始的 y 位置就发生位移
							.offset(y: 150)
							// 云朵飘动位移效果
							.offset(y: self.StartMoving ? CGFloat(self.offsetCloud1) * 20 : 0)
							.animation(Animation.linear(duration: 4).repeatForever(autoreverses: true))
						Image("cloud2")
							.resizable()
							.scaledToFit()
							.offset(y: 250)
							.offset(y: self.StartMoving ? CGFloat(self.offsetCloud2) * 20 : 0)
							.animation(Animation.linear(duration: 10).repeatForever(autoreverses: true))
					}
					Spacer()
				}
				
			}
		)
		.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(offsetCloud1: 100, offsetCloud2: 100)
    }
}

