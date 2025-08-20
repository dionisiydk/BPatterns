Class {
	#name : 'BPatternPluggableSelectorConfig',
	#superclass : 'BPatternSelectorConfig',
	#instVars : [
		'definitionBlock',
		'patternKeywords'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'instance creation' }
BPatternPluggableSelectorConfig class >> forSelectors: selectors definedBy: nodeBlock [

	^self new 
		patternSelectors: selectors;
		definitionBlock: nodeBlock
]

{ #category : 'applying' }
BPatternPluggableSelectorConfig >> applyForNode: anASTNode [
	super applyForNode: anASTNode.
	
	definitionBlock ifNotNil: [ definitionBlock value: anASTNode ]
]

{ #category : 'accessing' }
BPatternPluggableSelectorConfig >> definitionBlock [

	^ definitionBlock
]

{ #category : 'accessing' }
BPatternPluggableSelectorConfig >> definitionBlock: anObject [

	definitionBlock := anObject
]

{ #category : 'testing' }
BPatternPluggableSelectorConfig >> isForKeyword: aSymbol [
	^patternKeywords includes: aSymbol
]

{ #category : 'accessing' }
BPatternPluggableSelectorConfig >> patternKeywords [
	^patternKeywords
]

{ #category : 'accessing' }
BPatternPluggableSelectorConfig >> patternKeywords: symbols [
	^patternKeywords := symbols
]

{ #category : 'accessing' }
BPatternPluggableSelectorConfig >> patternSelectors: symbols [
	^patternKeywords := symbols flatCollect: [:each | each keywords ]
]

{ #category : 'printing' }
BPatternPluggableSelectorConfig >> printOn: aStream [
	super printOn: aStream.
	
	aStream nextPut: $(.
	patternKeywords
		do: [:each | aStream nextPutAll: each ] 
		separatedBy: [ aStream nextPut: ', ' ].
	aStream nextPut: $).
]
