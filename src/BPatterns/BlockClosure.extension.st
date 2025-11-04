Extension { #name : 'BlockClosure' }

{ #category : '*BPatterns' }
BlockClosure >> bmethod [

	| methodAssoc pattern |
	methodAssoc := self value.
	pattern := methodAssoc value bpattern.
	^pattern beMethod: methodAssoc key
]

{ #category : '*BPatterns' }
BlockClosure >> bpattern [
	^BPattern fromBlock: self
]

{ #category : '*BPatterns' }
BlockClosure >> brewrite [
	^BPatternRewrite fromBlock: self
]
