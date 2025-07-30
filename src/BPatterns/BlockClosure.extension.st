Extension { #name : 'BlockClosure' }

{ #category : '*BPatterns' }
BlockClosure >> bmethod [

	| methodAssoc pattern |
	methodAssoc := self valueWithArguments: (Array new: self numArgs).
	pattern := methodAssoc value bpattern.
	^pattern beMethod: methodAssoc key.
]

{ #category : '*BPatterns' }
BlockClosure >> bmethodHeaderAST [
	^self sourceNode body sendNodes first
]

{ #category : '*BPatterns' }
BlockClosure >> bpattern [
	^BPattern fromBlock: self
]

{ #category : '*BPatterns' }
BlockClosure >> bpattern: varSpecs [
	^self bpattern configureBy: varSpecs
]

{ #category : '*BPatterns' }
BlockClosure >> brewrite [
	^BPatternRewrite fromBlock: self
]
