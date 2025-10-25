"
I represent a source code rewrite rule using two pattern blocks:

```Smalltalk
	[:any :any2 | [ any isNil ifTrue: any2 ] -> [ any ifNil: any2 ]] brewrite
```

The main outer block encloses an association of two pattern blocks: the search pattern and the replace pattern. The arguments of the outer block represent the pattern variables so that both pattern blocks can reference them as normal variables. As result the #brewrite message creates my instance with two BPattern objects:

```Smalltalk
	BPatternREwrite fromPattern: searchPattern to: rewritePattern
```

Once you have a brewrite instance you can preview the system changes it represents and apply them using the refactoring UI:

```Smalltalk
	[:any :any2 | any isNil ifTrue: any2 ] brewrite preview.
	[:any | [ any printString asString ] -> [ any printString ]] brewrite 
		previewForClass: BPatternMethodQueryTest.
```

"
Class {
	#name : 'BPatternRewrite',
	#superclass : 'Object',
	#instVars : [
		'definitionBlock',
		'searchPattern',
		'rewritePattern'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'instance creation' }
BPatternRewrite class >> fromBlock: definitionBlock [
	| ruleAssoc searchPattern rewritePattern |
	ruleAssoc := definitionBlock valueWithArguments: (Array new: definitionBlock numArgs).
	searchPattern := ruleAssoc key bpattern.
	rewritePattern := ruleAssoc value bpattern.
	^self fromPattern: searchPattern to: rewritePattern
]

{ #category : 'instance creation' }
BPatternRewrite class >> fromPattern: searchPattern to: rewritePattern [
	searchPattern isSequenceNode = rewritePattern isSequenceNode 
		ifFalse: [ searchPattern isSequenceNode
				ifTrue: [ rewritePattern adoptToSequenceNode ]
				ifFalse: [ searchPattern adoptToSequenceNode ]].
	^self new 
		searchPattern: searchPattern;
		rewritePattern: rewritePattern 
]

{ #category : 'printing' }
BPatternRewrite >> displayStringOn: aStream [ 
	
	aStream nextPutAll: '[ '.
	searchPattern displayStringOn: aStream.
	aStream nextPutAll: ' ] -> [ '.
	rewritePattern displayStringOn: aStream.
	aStream nextPutAll: ' ]'
]

{ #category : 'rewriting' }
BPatternRewrite >> preview [
	| methods |
	methods := searchPattern users.
	^self previewForMethods: methods
]

{ #category : 'rewriting' }
BPatternRewrite >> previewForClass: aClass [
	| methods |
	methods := searchPattern usersInClass: aClass.
	^self previewForMethods: methods
]

{ #category : 'rewriting' }
BPatternRewrite >> previewForMethods: methods [
	| changes preview |
	changes := self changeForMethods: methods.
	preview := StRefactoringPreviewPresenter for: changes scopes: {ClyNavigationEnvironment currentImageScope}.
	preview openModal
]

{ #category : 'printing' }
BPatternRewrite >> printOn: aStream [
	super printOn: aStream.
	
	aStream nextPut: $(.
	self displayStringOn: aStream.
	aStream nextPut: $)
]

{ #category : 'rewriting' }
BPatternRewrite >> rewriteAST: anAST [
	^searchPattern rewriteAST: anAST with: rewritePattern
]

{ #category : 'rewriting' }
BPatternRewrite >> rewriteMethod: aMethod [
	^self rewriteAST: aMethod sourceNode copy
]

{ #category : 'accessing' }
BPatternRewrite >> rewritePattern [

	^ rewritePattern
]

{ #category : 'accessing' }
BPatternRewrite >> rewritePattern: anObject [

	rewritePattern := anObject
]

{ #category : 'accessing' }
BPatternRewrite >> searchPattern [

	^ searchPattern
]

{ #category : 'accessing' }
BPatternRewrite >> searchPattern: anObject [

	searchPattern := anObject
]
