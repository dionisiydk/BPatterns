Class {
	#name : 'BPatternRewrittenMethodExamples',
	#superclass : 'BPatternMethodExamples',
	#category : 'BPatterns-Tests',
	#package : 'BPatterns-Tests'
}

{ #category : 'examples' }
BPatternRewrittenMethodExamples >> isNilIfFalseWith: arg [
	^arg ifNotNil: [ arg printString ]
]

{ #category : 'examples' }
BPatternRewrittenMethodExamples >> methodWithArg: renamedArg [
	^renamedArg printString
]

{ #category : 'examples' }
BPatternRewrittenMethodExamples >> recursionMethod: arg1 with: arg2 [
	[ arg1 printOn: arg2 ] repeat
]
