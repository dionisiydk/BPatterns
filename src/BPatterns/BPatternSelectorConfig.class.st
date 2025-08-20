Class {
	#name : 'BPatternSelectorConfig',
	#superclass : 'BPatternConfig',
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'instance creation' }
BPatternSelectorConfig class >> isAbstract [ 
	^self = BPatternSelectorConfig
]

{ #category : 'applying' }
BPatternSelectorConfig >> applyForNode: anASTNode [
	super applyForNode: anASTNode.
	
	anASTNode keywords 
		select: [ :each | self isForKeyword: each ]
		thenDo: [ :each | anASTNode addPatternKeyword: each ]
]

{ #category : 'testing' }
BPatternSelectorConfig >> isForKeyword: aSymbol [
	self subclassResponsibility 
]

{ #category : 'testing' }
BPatternSelectorConfig >> isForNode: anASTNode [
	(anASTNode isMessage or: [ anASTNode isMethod ]) ifFalse: [ ^false ].
	
	^anASTNode keywords anySatisfy: [:eachKeyword | self isForKeyword: eachKeyword ]
]
