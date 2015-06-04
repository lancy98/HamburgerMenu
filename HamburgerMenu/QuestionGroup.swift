//
//  QuestionGroup.swift
//  HamburgerMenu
//
//  Created by Lancy on 29/05/15.
//  Copyright (c) 2015 Coder. All rights reserved.
//


class QuestionGroup {
    
    var name: String
    var level: Int
    var questions: [String]?
    var questionGroup: [QuestionGroup]?
    weak var parentQuestionGroup: QuestionGroup?
    
    init(index: Int, level: Int, parentQuestionGroup: QuestionGroup?) {
        self.name = "Question Group Number \(index)"
        self.level = level
        self.parentQuestionGroup = parentQuestionGroup
    }
    
    func totalRows() -> Int {
        var count = 1
        if (questionGroup != nil && questionGroup?.count != nil) {
            for eachObject in questionGroup! {
                count += eachObject.totalRows()
            }
        }
        return count
    }
    
    
    func object(group: [QuestionGroup], searchIndex: Int, var objectIndex: Int = 0) -> (QuestionGroup?, Int){
        
        var returnObj: QuestionGroup?
        
        for eachObject in group {
            
            if objectIndex == searchIndex {
                returnObj = eachObject
                return (returnObj, objectIndex)
            }
            
            objectIndex += 1

            if eachObject.questionGroup != nil && eachObject.questionGroup?.count != nil {
                let (returnedObj, index) = object(eachObject.questionGroup!, searchIndex: searchIndex, objectIndex: objectIndex)
                
                
                if returnedObj != nil {
                    return (returnedObj, index)
                }
                
                objectIndex = index
            }
        }
        
        return (nil, objectIndex)
    }
    
    subscript(index: Int) -> QuestionGroup? {
        let (obj, returnIndex) = object(questionGroup!, searchIndex: index)
        return obj
    }
    
    class func testData() -> QuestionGroup {
        
        let mainQuestionGroup = QuestionGroup(index: -1, level: -1, parentQuestionGroup: nil)
        
        let arr = map(0...10){ QuestionGroup(index: $0, level: mainQuestionGroup.level+1, parentQuestionGroup: mainQuestionGroup) }
        
        var questionGroup = arr[0]
        questionGroup.questionGroup = map(0..<2){ QuestionGroup(index: $0, level: questionGroup.level+1, parentQuestionGroup: questionGroup) }
        
        var subgroup = questionGroup.questionGroup![0]
        subgroup.questionGroup = map(0..<2){ QuestionGroup(index: $0, level: subgroup.level+1, parentQuestionGroup: subgroup) }
        
        questionGroup = arr[4]
        questionGroup.questionGroup = map(0..<4){ QuestionGroup(index: $0, level: questionGroup.level+1, parentQuestionGroup: questionGroup) }
        
        questionGroup = questionGroup.questionGroup![1]
        questionGroup.questionGroup = map(0..<4){ QuestionGroup(index: $0, level: questionGroup.level+1, parentQuestionGroup: questionGroup) }
        
        mainQuestionGroup.questionGroup = arr
        return mainQuestionGroup
        
    }
}