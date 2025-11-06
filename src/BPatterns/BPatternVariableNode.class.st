Class {
	#name : 'BPatternVariableNode',
	#superclass : 'OCPatternVariableNode',
	#instVars : [
		'filterBlock'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'initialization' }
BPatternVariableNode >> beArg [

	self where: [:var | var isArgumentVariable ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beClassVar [

	self where: [:var | var isClassVariable ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beGlobalVar [

	self where: [:var | var isGlobalVariable ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beInstVar [

	self where: [:var | var isInstanceVariable ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beLiteral [ 
	isAnything := false.
	isList := false.
	isLiteral := true
]

{ #category : 'initialization' }
BPatternVariableNode >> beLocalVar [

	self where: [:var | var isLocalVariable ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beMultiStatements [ 
	isAnything := true.
	isList := true
]

{ #category : 'converting' }
BPatternVariableNode >> bePatternNode [
]

{ #category : 'initialization' }
BPatternVariableNode >> bePoolVar [

	self where: [:var | var isPoolVariable ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beRecursive [
	recurseInto := true
]

{ #category : 'initialization' }
BPatternVariableNode >> beShadowingVar [

	self where: [:var | var isShadowing ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beStatement [ 
	isAnything := false.
	isList := false.
	isStatement := true
]

{ #category : 'initialization' }
BPatternVariableNode >> beTemp [

	self where: [:var | var isTempVariable ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beUndeclared [

	self where: [:var | var isUndeclaredVariable ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beVariable [ 
	isAnything := false.
	isList := false.
	isStatement := false.
]

{ #category : 'accessing' }
BPatternVariableNode >> filterBlock [

	^ filterBlock
]

{ #category : 'initialization' }
BPatternVariableNode >> initializePatternVariables [
	isList := isLiteral := isStatement := recurseInto := false.
	isAnything := true.
	self beRecursive
]

{ #category : 'matching' }
BPatternVariableNode >> match: aNode inContext: aDictionary [

	self isAnything
		ifTrue: [^ self compare: (aDictionary at: self ifAbsentPut: [aNode]) with: aNode].
	self isLiteralNode ifTrue: [^self matchLiteral: aNode inContext: aDictionary].
	self isStatement ifTrue: [^self matchStatement: aNode inContext: aDictionary].
	^self matchVariable: aNode inContext: aDictionary
]

{ #category : 'matching' }
BPatternVariableNode >> matchLiteral: aNode inContext: aDictionary [

	aNode isLiteralNode ifFalse: [ ^false ].
	filterBlock ifNotNil: [
		 (filterBlock value: aNode value) ifFalse: [ ^false ]].
	
	^self compare: (aDictionary at: self ifAbsentPut: [aNode]) with: aNode
]

{ #category : 'matching' }
BPatternVariableNode >> matchVariable: aNode inContext: aDictionary [

	aNode isVariable ifFalse: [^false].
	filterBlock ifNotNil: [
		 (filterBlock value: aNode variable) ifFalse: [ ^false ]].

	^self compare: (aDictionary at: self ifAbsentPut: [aNode]) with: aNode
]

{ #category : 'initialization' }
BPatternVariableNode >> prepareForBPattern [
	isList := isLiteral := isStatement := recurseInto := false.
	isAnything := true.
	self beRecursive
]

{ #category : 'accessing' }
BPatternVariableNode >> where: aBlock [

	filterBlock := aBlock
]
