Class {
	#name : 'BPatternDefaultSelectorConfig',
	#superclass : 'BPatternSelectorConfig',
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'testing' }
BPatternDefaultSelectorConfig >> isForKeyword: aSymbol [
	^aSymbol beginsWith: 'any'
]
