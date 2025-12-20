Class {
	#name : 'BPatternVariableNode',
	#superclass : 'OCPatternVariableNode',
	#instVars : [
		'filters'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'comparing' }
BPatternVariableNode >> = anObject [
	super = anObject ifFalse: [ ^false ].
	
	filters size = anObject filters size ifFalse: [ ^false ].
	filters with: anObject filters do: [:my :their |
		my compiledBlock = their compiledBlock ifFalse: [ ^false ]
	].
	^true
]

{ #category : 'initialization' }
BPatternVariableNode >> beArg [

	self beVariable: [:var | var isArgumentVariable ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beClassVar [

	self beVariable: [:var | var isClassVariable ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beGlobalVar [

	self beVariable: [:var | var isGlobalVariable ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beGlobalVarWithAny: valueOptions [

	self beGlobalVar.
	self where: [:var | valueOptions includes: var value ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beInstVar [

	self beVariable: [:var | var isInstanceVariable ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beLiteral [ 
	isAnything := false.
	isList := false.
	isLiteral := true
]

{ #category : 'initialization' }
BPatternVariableNode >> beLiteralWithAny: valueOptions [

	self beLiteral.
	self where: [:value | valueOptions includes: value ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beLocalVar [

	self beVariable: [:var | var isLocalVariable ]
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

	self beVariable: [:var | var isPoolVariable ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beRecursive [
	recurseInto := true
]

{ #category : 'initialization' }
BPatternVariableNode >> beShadowingVar [

	self beVariable: [:var | var isShadowing ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beStatement [
	isStatement := true.
	isList := false
]

{ #category : 'initialization' }
BPatternVariableNode >> beTempVar [

	self beVariable: [:var | var isTempVariable ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beUndeclared [

	self beVariable: [:var | var isUndeclaredVariable ]
]

{ #category : 'initialization' }
BPatternVariableNode >> beVariable [ 
	isAnything := false.
	isList := false.
	isStatement := false.
	recurseInto := true
]

{ #category : 'initialization' }
BPatternVariableNode >> beVariable: aBlock [

	self beVariable.
	self where: aBlock
]

{ #category : 'initialization' }
BPatternVariableNode >> configureDefaults [
	filters := #().
	isLiteral := isStatement := false.
	self beMultiStatements.
	self beRecursive.
	parent isDynamicArray ifTrue: [ 
		"default multiStatement is not supported under dynamic array"
		self beStatement ]. 
	"TODO: automatically determine that the receiver represents a temp var
	because it is declared under the pattern AST scope. Something like:
		(parent temporaries includes: self) ifTrue: [ self beTempVar ]
	But it should be a deeper analysys up to the root of the pattern AST"
]

{ #category : 'accessing' }
BPatternVariableNode >> filters [

	^ filters
]

{ #category : 'comparing' }
BPatternVariableNode >> hash [
	^filters inject: super hash into: [:result :each | 
		each compiledBlock hash bitXor: result hash ]
]

{ #category : 'initialization' }
BPatternVariableNode >> initializePatternVariables [
	"see #configureDefaults"
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
BPatternVariableNode >> matchFiltersFor: anObject [
	^filters allSatisfy: [ :each | each value: anObject ]

]

{ #category : 'matching' }
BPatternVariableNode >> matchLiteral: aNode inContext: aDictionary [

	aNode isLiteralNode ifFalse: [ ^false ].
	(self matchFiltersFor: aNode value) ifFalse: [ ^false ].
	
	^self compare: (aDictionary at: self ifAbsentPut: [aNode]) with: aNode
]

{ #category : 'matching' }
BPatternVariableNode >> matchVariable: aNode inContext: aDictionary [

	aNode isVariable ifFalse: [^false].
	(self matchFiltersFor: aNode variable) ifFalse: [ ^false ].

	^self compare: (aDictionary at: self ifAbsentPut: [aNode]) with: aNode
]

{ #category : 'accessing' }
BPatternVariableNode >> parent: aBRProgramNode [
	parent := aBRProgramNode
]

{ #category : 'initialization' }
BPatternVariableNode >> where: aBlock [
	filters := filters copyWith: aBlock.
]
