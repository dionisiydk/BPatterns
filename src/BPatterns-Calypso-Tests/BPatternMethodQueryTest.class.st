Class {
	#name : 'BPatternMethodQueryTest',
	#superclass : 'ClyMethodQueryTest',
	#instVars : [
		'pattern'
	],
	#category : 'BPatterns-Calypso-Tests',
	#package : 'BPatterns-Calypso-Tests'
}

{ #category : 'running' }
BPatternMethodQueryTest >> createQuery [
	^BPatternMethodQuery 
			withPattern: [:any | any printString asString ] bpattern 
			from: (ClyClassScope of: self class in: environment)
]

{ #category : 'tests' }
BPatternMethodQueryTest >> exampleWithPattern [
	^self printString asString
]

{ #category : 'tests' }
BPatternMethodQueryTest >> exampleWithoutPattern [
	^self printString
]

{ #category : 'tests' }
BPatternMethodQueryTest >> testComparison [

	| anotherQuery |
	self assert: query = query.
	self assert: query = query copy.
	self assert: query hash equals: query copy hash.
	
	anotherQuery := BPatternMethodQuery withPattern: [ #anotherPattern ] bpattern from: query scope.
	self deny: query = anotherQuery
]

{ #category : 'tests' }
BPatternMethodQueryTest >> testDescription [
	
	self assert: query description equals: 'Users of [any printString asString]'
]

{ #category : 'tests' }
BPatternMethodQueryTest >> testFromMethodScope [

	self queryFromScope: ClyMethodScope ofAll: {(self class >> #exampleWithPattern) . (self class >> #exampleWithoutPattern)}.

	self assert: resultItems size equals: 1.
	self assert: resultItems first identicalTo: self class >> #exampleWithPattern
]
