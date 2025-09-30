"
I represent an AST pattern which can be matched agains AST nodes.
My instances are created from a pattern block:

```Smalltalk
	[:any :any2 | any isNil ifTrue: any2 ] bpattern
```

Once you have a bpattern you can browse the system to find all matching methods:

```Smalltalk
	[:any :any2 | any isNil ifTrue: any2 ] bpattern browseUsers.
	[:any | any printString asString ] bpattern browseUsersInClass: BPatternMethodQueryTest.
```

And you can rewrite the matching methods using the another bpattern:

```Smalltalk
	[:any | 
		[ any printString asString ] -> [ any printString ] 
	] brewrite previewForClass: BPatternMethodQueryTest
```
See BPatternRewrite class for more details about the rewrite.

AST of the bpattern block is used to construct the pattern nodes from the rewrite engine.
Thus I allow to replace the rewrite syntax like:

```Smalltalk
	'``@rcvr isNil ifTrue: ``@arg'
```	
By default the block arguments define the pattern variables representing any node. This behaviour can be configured:

```Smalltalk
	[:any :any2 | any isNil ifTrue: any2 ] bpattern: 'any' -> [:pattern | pattern beVariable ]
```

Here is an example where #any pattern will match only variable nodes receiving #isNil message ('var someMessage isNil' will not be matched). See other config methods of OCPatternVariable for other options.

Besides variables any selector can be configured as a pattern:

```Smalltalk
	[:any :anyAg1 :anyArg2 | any at: anyArg1 anyOtherKeyword: anyArg2 ] bpattern
```
It will match any message sends with a selector started with #at: keyword and an another second part.

For a comparison the rewrite engine syntax for this example would look like:

```Smalltalk
	'``@rcvr at: ``@arg `msg2: ``@arg2'
```

For convenience any selectors and variables started with the word #any are traited as a pattern automatically. Other names require an explicit configuration:

```Smalltalk
	[:any :arg1 :arg2 | any at: arg1 otherKeyword: arg2 ] bpattern: #('arg1' 'arg2' #otherKeyword)
```

The block for the pattern config is optional. If you just need to inforce the pattern then no need to pass an empty block.

For automatic message patterns the unary selector matches any type of selectors (unary, binary and keyword) and any arguments:

```Smalltalk
	[ instVar anyMessage printString ] bpattern
```

It will match expressions like:

```Smalltalk
	(instVar at: #key) printString.
	instVar variable anotherVariable printString
	(instVar + 1) printString
```
This behaviour differs from the rewrite engine where you have to specify arguments together with a selector:

```Smalltalk
	`self `@args: `@vars' 
```






"
Class {
	#name : 'BPattern',
	#superclass : 'Object',
	#instVars : [
		'patternAST',
		'configs',
		'isConfigured'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'instance creation' }
BPattern class >> fromAST: anASTNode [ 
	^self new 
		patternAST: anASTNode
]

{ #category : 'instance creation' }
BPattern class >> fromBlock: definitionBlock [ 
	| definitionAST patternAST |
	definitionAST := definitionBlock sourceNode.
	patternAST := (definitionAST statements size == 1 and: [ definitionAST temporaries isEmpty ])
		  ifTrue: [ definitionAST statements first ]
		  ifFalse: [ definitionAST body ].
	^self fromAST: patternAST
	
]

{ #category : 'comparing' }
BPattern >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject ifTrue: [ ^ true ].
	self class = anObject class ifFalse: [ ^ false ].
	^self patternAST = anObject patternAST
]

{ #category : 'converting' }
BPattern >> adoptToSequenceNode [ 
	patternAST isSequence ifFalse: [ 
		patternAST := OCSequenceNode statements: (Array with: patternAST)]
]

{ #category : 'private' }
BPattern >> applyConfigs [
	| astBuilder |
	astBuilder := BPatternASTBuilder configuredBy: configs.
	astBuilder visitNode: patternAST.
	isConfigured := true
]

{ #category : 'converting' }
BPattern >> beMethod: headerBlock [
	self adoptToSequenceNode.
	patternAST := BPatternMethodNode 
						fromHeaderBlock: headerBlock 
						body: patternAST.

]

{ #category : 'converting' }
BPattern >> bpattern [
	^self
]

{ #category : 'converting' }
BPattern >> bpattern: varSpecs [
	^self configureBy: varSpecs
]

{ #category : 'initialization' }
BPattern >> configureBy: configSpecs [
	
	| patternConfigs |
	patternConfigs := BPatternConfig readFromSpecs: configSpecs.
	configs addAll: patternConfigs
]

{ #category : 'printing' }
BPattern >> displayStringOn: aStream [
	
	aStream nextPutAll: patternAST formattedCode
]

{ #category : 'comparing' }
BPattern >> hash [
	^self patternAST hash
]

{ #category : 'initialization' }
BPattern >> initialize [ 
	super initialize.

	configs := OrderedCollection new.
	isConfigured := false.
	self useDefaultConfigs
]

{ #category : 'testing' }
BPattern >> isSequenceNode [ 
	^patternAST isSequence
]

{ #category : 'testing' }
BPattern >> matchesAST: aNode [
	self scanAST: aNode do: [ :each | ^true ].
	^false
]

{ #category : 'testing' }
BPattern >> matchesMethod: aMethod [
	^self matchesAST: aMethod sourceNode
]

{ #category : 'accessing' }
BPattern >> patternAST [
	isConfigured ifFalse: [ self applyConfigs ].
	^ patternAST 
]

{ #category : 'accessing' }
BPattern >> patternAST: anASTNode [
	patternAST := anASTNode copy
]

{ #category : 'printing' }
BPattern >> printOn: aStream [
	super printOn: aStream.
	
	aStream nextPut: $(.
	self displayStringOn: aStream.
	aStream nextPut: $)
]

{ #category : 'rewriting' }
BPattern >> rewriteAST: originalAST with: rewritePattern [

	| rewriter |
	rewriter := BPatternASTRewriter new.
	rewriter addRule: (BPatternReplaceRule new 
			searchTree: self patternAST;
			replaceTree: rewritePattern patternAST).
	rewriter executeTree: originalAST.
	^rewriter tree
	
]

{ #category : 'scanning' }
BPattern >> scanAST: anAST [
	| searcher result |
	
	searcher := OCParseTreeSearcher new.
	searcher addRule: (BPatternSearchRule new 
			searchTree: self patternAST;
			answerBlock: [ :aNode :answer | result := searcher context ]).
	searcher executeTree: anAST.
	^result
	
]

{ #category : 'scanning' }
BPattern >> scanAST: anAST do: nodeBlock [
	| searcher |
	
	searcher := OCParseTreeSearcher new.
	searcher addRule: (BPatternSearchRule new 
			searchTree: self patternAST;
			answerBlock: [ :aNode :answer | nodeBlock value: aNode ]).
	searcher executeTree: anAST
]

{ #category : 'initialization' }
BPattern >> useDefaultConfigs [
	configs add: BPatternDefaultVarConfig new.
	configs add: BPatternDefaultSelectorConfig new
]

{ #category : 'scanning' }
BPattern >> users [

	| result |
	result := OrderedCollection new.
	Smalltalk allClasses 
		do:[:aClass| result addAll: (self usersInClass: aClass) ]
		displayingProgress: 'Lookup for [', self displayString, ']'
		every: 1000.
	^result
]

{ #category : 'scanning' }
BPattern >> usersInClass: aClass [
	
	| result |
	result := OrderedCollection new.
	aClass methodsDo: [:each | 	(self matchesMethod: each) ifTrue: [ result add: each ]].
	aClass class methodsDo: [:each | 	(self matchesMethod: each) ifTrue: [ result add: each ]].
	^result

]
