Class {
	#name : 'BPatternMethodExamples',
	#superclass : 'Object',
	#category : 'BPatterns-Tests',
	#package : 'BPatterns-Tests'
}

{ #category : 'examples' }
BPatternMethodExamples >> isNilIfFalseWith: arg [
	^arg isNil ifFalse: [ arg printString ]
]

{ #category : 'examples' }
BPatternMethodExamples >> methodWithArg: arg [
	^arg printString
]

{ #category : 'examples' }
BPatternMethodExamples >> recursionMethod: arg1 with: arg2 [
	arg1 printOn: arg2.
	self recursionMethod: arg1 with: arg2
]
