Class {
	#name : 'BPatternConfig',
	#superclass : 'Object',
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'instance creation' }
BPatternConfig class >> forMessageNodesFrom: selectorOrArray definedBy: configNodeBlock [

	| selectors |
	selectors := selectorOrArray isSymbol ifTrue: [ { selectorOrArray} ] ifFalse: [ selectorOrArray ].
	selectors ifEmpty: [ self error: 'Selectors should not be empty!' ].
	^BPatternPluggableSelectorConfig forSelectors: selectors definedBy: configNodeBlock.
]

{ #category : 'instance creation' }
BPatternConfig class >> forPatternNamesFrom: symbolsOrBlocks definedBy: configBlock [
	^symbolsOrBlocks first isSymbol 
		ifTrue: [ self forMessageNodesFrom: symbolsOrBlocks definedBy: configBlock ]	
		ifFalse: [ self forVarNodesFrom: symbolsOrBlocks definedBy: configBlock ]
]

{ #category : 'instance creation' }
BPatternConfig class >> forVarNodes: varNodes definedBy: configNodeBlock [

	| vars |	
	vars := varNodes collect: [ :each | each name ].
	vars ifEmpty: [ self error: 'Pattern var block has no var!' ].
	^BPatternPluggableVarConfig forVarNames: vars definedBy: configNodeBlock.
]

{ #category : 'instance creation' }
BPatternConfig class >> forVarNodesFrom: blocksWithVars definedBy: configNodeBlock [

	| vars |	
	vars := blocksWithVars flatCollect: [:eachBlock | eachBlock sourceNode variableNodes].
	^self forVarNodes: vars definedBy: configNodeBlock
]

{ #category : 'instance creation' }
BPatternConfig class >> isAbstract [ 
	^self = BPatternConfig
]

{ #category : 'instance creation' }
BPatternConfig class >> readFromSingleSpec: anObjectOrAssoc [
	| objectsWithPatternNames configBlock |
	anObjectOrAssoc isAssociation 
		ifTrue: [ 
			objectsWithPatternNames := anObjectOrAssoc key.
			configBlock := anObjectOrAssoc value ]
		ifFalse: [ objectsWithPatternNames := anObjectOrAssoc ].
	objectsWithPatternNames isArray ifFalse: [ objectsWithPatternNames := { objectsWithPatternNames } ].	
	^self forPatternNamesFrom: objectsWithPatternNames definedBy: configBlock
]

{ #category : 'instance creation' }
BPatternConfig class >> readFromSpecs: anObjectOrArray [

	anObjectOrArray isArray ifFalse: [ ^{self readFromSingleSpec: anObjectOrArray} ].
	^anObjectOrArray collect: [ :each | self readFromSingleSpec: each ]
]

{ #category : 'applying' }
BPatternConfig >> applyForNode: anASTNode [
	anASTNode bePatternNode
]

{ #category : 'testing' }
BPatternConfig >> isForNode: anASTNode [
	^self subclassResponsibility 
]
