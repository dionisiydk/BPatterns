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
BPatternMethodExamples >> methodWithRenamedArg: arg [
	^arg printString
]

{ #category : 'examples' }
BPatternMethodExamples >> recursionMethod: arg1 with: arg2 [
	arg1 printOn: arg2.
	self recursionMethod: arg1 with: arg2
]

{ #category : 'examples' }
BPatternMethodExamples >> recursionMethodByRenamedTemp: arg1 with: arg2 [
	| tempA tempB |
	^tempA + tempB
]

{ #category : 'examples' }
BPatternMethodExamples >> recursionMethodWithTemps: arg1 with: arg2 [
	| tempA tempB |
	arg1 printOn: arg2.
	self recursionMethodWithTemps: arg1 with: arg2
]
