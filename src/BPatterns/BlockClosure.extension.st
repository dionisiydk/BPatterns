Extension { #name : 'BlockClosure' }

{ #category : '*BPatterns' }
BlockClosure >> bmethod [
	^BPatternMethod fromBlock: self
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
