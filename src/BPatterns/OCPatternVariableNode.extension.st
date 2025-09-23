Extension { #name : 'OCPatternVariableNode' }

{ #category : '*BPatterns' }
OCPatternVariableNode >> beList [ 
	isAnything := true.
	isList := true
]

{ #category : '*BPatterns' }
OCPatternVariableNode >> beLiteral [ 
	isAnything := false.
	isList := false.
	isLiteral := true
]

{ #category : '*BPatterns' }
OCPatternVariableNode >> bePatternNode [
]

{ #category : '*BPatterns' }
OCPatternVariableNode >> beRecursive [
	recurseInto := true
]

{ #category : '*BPatterns' }
OCPatternVariableNode >> beStatement [ 
	isAnything := false.
	isList := false.
	isStatement := true
]

{ #category : '*BPatterns' }
OCPatternVariableNode >> beVariable [ 
	isAnything := false.
	isList := false.
	isStatement := false.
]

{ #category : '*BPatterns' }
OCPatternVariableNode >> prepareForBPattern [
	isList := isLiteral := isStatement := recurseInto := false.
	isAnything := true.
	self beRecursive
]
