Class {
	#name : 'BPatternMethodQuery',
	#superclass : 'ClyMethodQuery',
	#instVars : [
		'pattern'
	],
	#category : 'BPatterns-Calypso',
	#package : 'BPatterns-Calypso'
}

{ #category : 'instance creation' }
BPatternMethodQuery class >> withPattern: aBPattern [

	^self new 
		pattern: aBPattern bpattern
]

{ #category : 'instance creation' }
BPatternMethodQuery class >> withPattern: aBPattern from: aScope [

	^(self from: aScope) 
		pattern: aBPattern bpattern
]

{ #category : 'comparing' }
BPatternMethodQuery >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	super = anObject ifFalse: [ ^ false ].
	^pattern = anObject pattern
]

{ #category : 'tools decoration' }
BPatternMethodQuery >> decorateResultMethodEditor: aMethodEditor [

	pattern scanAST: aMethodEditor editingMethod sourceNode do: [ :node |
		aMethodEditor selectSourceNode: node.
		^self ]
]

{ #category : 'comparing' }
BPatternMethodQuery >> description [

	^'Users of [', self printPattern, ']'
]

{ #category : 'comparing' }
BPatternMethodQuery >> hash [
	^super hash bitXor: pattern hash
]

{ #category : 'accessing' }
BPatternMethodQuery >> pattern [

	^ pattern
]

{ #category : 'accessing' }
BPatternMethodQuery >> pattern: anObject [

	pattern := anObject
]

{ #category : 'execution' }
BPatternMethodQuery >> prepareStateBeforeExecution [
	super prepareStateBeforeExecution.
	
	pattern patternAST. "to ensure configs takes the effect"
	self beReadOnlyObject
]

{ #category : 'comparing' }
BPatternMethodQuery >> printExtraInfoOn: aStream [
	super printExtraInfoOn: aStream.
	
	^aStream nextPutAll: self printPattern
]

{ #category : 'comparing' }
BPatternMethodQuery >> printPattern [
	^pattern displayString
]

{ #category : 'testing' }
BPatternMethodQuery >> selectsMethod: aMethod [
	^pattern matchesMethod: aMethod
]
