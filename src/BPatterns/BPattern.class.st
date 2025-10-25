"
I represent an AST pattern which can be matched against AST nodes.
My instances are created from a pattern block using #bpattern message:

```Smalltalk
	[:any :any2 | any isNil ifTrue: any2 ] bpattern
```

Once you have a BPattern you can browse the system to find all matching methods:

```Smalltalk
	[:any :any2 | any isNil ifTrue: any2 ] bpattern browseUsers.
	[:any | any printString asString ] bpattern browseUsersInClass: BPatternMethodQueryTest.
```

Using two BPatterns you can rewrite the matching methods:

```Smalltalk
	[:any | 
		[ any printString asString ] -> [ any printString ] 
	] brewrite previewForClass: BPatternMethodQueryTest
```
See BPatternRewrite class for more details about the rewrite.

The variables and selectors inside the pattern block can be used as a pattern to match particular AST nodes.
By default the following objects are automatically configured as ANY pattern to match any AST node:
- variables started with #any word
- selectors where a keyword is started with #any word

To narrow the filter represented by a pattern you have to configure it:

```Smalltalk
	| anyVar anyBlock |
	[ anyVar isNil ifTrue: anyBlock ] bpattern: [ anyVar ] -> [:pattern | pattern beVariable ]
```

Here the #anyVar pattern will match only variables which are receivers of #isNil message.
For example it will match the following expression: 

```Smalltalk
 	instVar isNil ifTrue: [ anotherVar printString ]
``` 

But it will not match an expression where the receiver is an another message send:

```Smalltalk
 	instVar someMessage isNil ifTrue: [ anotherVar printString ]
``` 

See other config methods of OCPatternVariable for other options.

Applying such configuration for other non default objects they will be converted to the pattern:

```Smalltalk
	| var anyBlock |
	[ var isNil ifTrue: anyBlock ] bpattern: [ var ] -> [:pattern | pattern beVariable ]
```

The config block is optional and to make a pattern object you can just reference it:

```Smalltalk
	| var anyBlock |
	[ var isNil ifTrue: anyBlock ] bpattern: [ var ]
```

In that case #var pattern will match ANY AST node like if it would be named #anyVar.

For the arguments of #bpattern: message you can pass single element such as a block for varibales, an association for configuration or a symbol for selectors. And it can be an array of them:

```Smalltalk
	| any arg1 arg2 |
	[ any at: arg1 otherKeyword: arg2 ] bpattern: {[arg1. arg2] -> [:pattern | pattern beVariable]. #otherKeyword}
```

This example will match a message send with any receiver and variables as arguments and where a selector started with #at: and an arbitrary second keyword.
Blocks are used for variables to lexically reference them instead of using raw string names. 

Thus selectors can be also used as patterns:

```Smalltalk
	[:any :anyAg1 :anyArg2 | any at: anyArg1 anyOtherKeyword: anyArg2 ] bpattern
```

It will match any message sends with a selector started with #at: and any other second keyword. It does not require any configuration because #anyOtherKeyword: is started with any word.  

For binary selectors you have to use the config block:

```Smalltalk
	| any any2 |
	[ any + any2 ] bpattern: #+.
```

This pattern will match any expressions with any binary message lile #+, #-, #=, etc..
You can add a configuration for the argument to find all binary expressions where the argument is a literal:

```Smalltalk
	| any anyLiteral |
	[ any + anyLiteral ] bpattern: {#+. [ anyLiteral ] -> [:pattern | pattern beLiteral ]}
```
----
For other variables and selectors you have to explicitly configure them:

Similar to variables the #any word is used for the default configuration. Any other pattern keywords have to be configured explicitly:

```Smalltalk
	[:any :anyAg1 :anyArg2 | any at: anyArg1 otherKeyword: anyArg2 ] bpattern: #otherKeyword
```

The block for the pattern config is optional. If you just need to enforce the pattern then no need to pass an empty block.

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

Internally the AST of a bpattern block is used to construct the pattern nodes from the rewrite engine.
Thus I allow to replace the rewrite syntax like:

```Smalltalk
	'``@rcvr isNil ifTrue: ``@arg'
```	

Besides variables any selector can be used as a pattern:

```Smalltalk
	[:any :anyAg1 :anyArg2 | any at: anyArg1 anyOtherKeyword: anyArg2 ] bpattern
```
It will match any message sends with a selector started with #at: keyword and an another second part.

For a comparison the rewrite engine syntax for this example would looks like:

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

For some cases it is necessery to describe the pattern for the entire method including the method header. It can be achived using #bmethod DSL:

```Smalltalk
	[:arg1 :arg2 :block | [ self methodName: arg1 part2: arg2 ] -> [ arg1 isNil ifTrue: block ]] bmethod
```

Here the enclosing block of #bmethod returns an association of the method header pattern block and the method body pattern. The method header block must contains a single message send to any receiver. This message is extracted as a pattern for the method header.
BMethod is still an instance of BPattern and therefore it can be used for the code search and rewrite:

```Smalltalk
	[:stmts |
			[[ self anyMessage ] -> [ stmts. self anyMessage ]] bmethod 
				->
			[[ self anyMessage ] -> [ [ stmts ] repeat ]] bmethod
	] brewrite
```
Here is a method pattern example which will find a simple recursion and replace it with the loop. The recursive call can be an any kind of message sends with any number of arguments.



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
