Extension { #name : 'BlockClosure' }

{ #category : '*BPatterns' }
BlockClosure >> bpattern [
	^BPattern fromBlock: self
]

{ #category : '*BPatterns' }
BlockClosure >> brewrite [
	^BPatternRewrite fromBlock: self
]
