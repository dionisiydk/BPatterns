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
BPatternSelectorConfig >> applyForPatternNode: aMessagePatternNode [ "or aMethodPatternNode"
	aMessagePatternNode selector isUnary ifTrue: [ 
		"unary selector works as a selector list pattern by default.
		It matches any kind of selector (unary, bunary and keyword) with any number of arguments"
		aMessagePatternNode beSelectorList ].	
	aMessagePatternNode selector keywords 
		select: [ :each | self isForKeyword: each ] 
		thenDo: [ :each | aMessagePatternNode addPatternKeyword: each ].		
	super applyForPatternNode: aMessagePatternNode.	

]

{ #category : 'testing' }
BPatternSelectorConfig >> isForKeyword: aSymbol [
	self subclassResponsibility 
]

{ #category : 'testing' }
BPatternSelectorConfig >> isForNode: anASTNode [
	(anASTNode isMessage or: [ anASTNode isMethod or: [ anASTNode isPragma ]]) ifFalse: [ ^false ].
	
	^anASTNode selector keywords anySatisfy: [:eachKeyword | self isForKeyword: eachKeyword ]
]
