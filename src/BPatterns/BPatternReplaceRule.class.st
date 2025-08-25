Class {
	#name : 'BPatternReplaceRule',
	#superclass : 'OCStringReplaceRule',
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'initialization' }
BPatternReplaceRule >> replaceTree: anAST [
	replaceTree := anAST.
	searchTree isSequence = replaceTree isSequence
		ifFalse: [ searchTree isSequence
				ifTrue: [ replaceTree := OCSequenceNode statements: (Array with: replaceTree) ]
				ifFalse: [ searchTree := OCSequenceNode statements: (Array with: searchTree) ] ]
]

{ #category : 'accessing' }
BPatternReplaceRule >> searchTree: anObject [

	searchTree := anObject
]
