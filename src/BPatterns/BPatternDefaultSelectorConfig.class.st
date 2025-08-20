Class {
	#name : 'BPatternDefaultSelectorConfig',
	#superclass : 'BPatternSelectorConfig',
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'applying' }
BPatternDefaultSelectorConfig >> applyForNode: aMessageNode [
	super applyForNode: aMessageNode.
	
	aMessageNode selector isUnary ifTrue: [ 
		"unary any~ selector works as a selector list pattern. 
		It matches any selector with any number of arguments"
		aMessageNode beSelectorList ]
	
]

{ #category : 'testing' }
BPatternDefaultSelectorConfig >> isForKeyword: aSymbol [
	^aSymbol beginsWith: 'any'
]
