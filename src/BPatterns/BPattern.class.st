"
I represent an AST pattern which can be matched against AST nodes.
My instances are created from a pattern block using **#bpattern** message:

```
	| any anyBlock |
	[ any isNil ifTrue: anyBlock ] bpattern
```

Once you have a `BPattern` you can browse the system to find all matching methods:

```
	| any any2 |
	[ any isNil ifTrue: any2 ] bpattern browseUsers.
	[ any printString asString ] bpattern browseUsersInClass: BPatternMethodQueryTest.
```

Using two BPatterns you can rewrite the matching methods:

```
	| any |
	[ 
		[ any printString asString ] -> [ any printString ] 
	] brewrite previewForClass: BPatternMethodQueryTest
```
See `BPatternRewrite` class for more details about the rewrite.

##Patterns configuration


The variables and selectors inside the pattern block can be used as a pattern to match particular AST nodes.
By default the following objects are automatically configured as **ANY** pattern to match any AST node:
- variables started with **any** word
- selectors where a keyword is started with **any** word

To narrow the filter represented by a pattern you have to configure it using **#with:** message:

```
	| anyVar anyBlock |
	[ anyVar isNil ifTrue: anyBlock ] bpattern with: [ anyVar ] -> [:pattern | pattern beVariable ]
```

Blocks are used for variables to lexically reference them instead of using raw string names. 
Here the **#anyVar** pattern name will match only variables which are receivers of **#isNil** message.
For example it will match the following expression: 

```
 	instVar isNil ifTrue: [ anotherVar printString ]
``` 

But it will not match an expression where the receiver is an another message send:

```
 	instVar someMessage isNil ifTrue: [ anotherVar printString ]
``` 

See other config methods of `BPatternVariableNode` for other options.

By using such a configuration for non default objects they will be converted to the pattern:

```
	| someVar anyBlock |
	[ someVar isNil ifTrue: anyBlock ] bpattern with: [ someVar ] -> [:pattern | pattern beVariable ]
```

Notice without the config block the **#someVar** object would only match variables named **#someVar**.

The config block is optional and to enforce the pattern without extra settings you can just reference it:

```
	| someVar anyBlock |
	[ someVar isNil ifTrue: anyBlock ] bpattern with: [ someVar ]
```

In that case **#someVar** pattern will match **ANY** AST node like if it would be named **#anyVar**.

For the arguments of **#with:** message you can pass a block for variables, an association for a configuration or a symbol for a selector. And it can be an array of them:

```
	| any arg1 arg2 |
	[ any at: arg1 otherKeyword: arg2 ] bpattern 
		with: {[arg1. arg2] -> [:pattern | pattern beVariable]. #otherKeyword}
```

This example will match a message send with any receiver and variables as arguments and where a selector starts with **#at:** and an arbitrary second keyword (see **Selector Patterns**).

###Variable patterns

Patterns can be configured to match a particular type of variables:

```
	| anyVar anyBlock |
	[ anyVar do: anyBlock ] bpattern 
		with: [ anyVar ] -> [:pattern | pattern beInstVar ];
		with: [ anyBlock ] -> [:pattern | pattern beLocalVar ];
		browseUsers
```

See `BPatternVariableNode` for other options.

And you can specify an arbitraty block filter using **#where:** message:

```
	| anyVar anyBlock |
	[ anyVar do: anyBlock ] bpattern 
		with: [ anyVar ] -> [:pattern | pattern beInstVar ];
		with: [ anyBlock ] -> [:pattern | pattern beLocalVar where: [:var | 
				(var name beginsWith: 'a') not]];
		browseUsers
```

###Global variable patterns

TODO

###Literal patterns

Patterns can be configured to match literals:

```
	| any any2 |
	[ any + any2 ] bpattern 
		with: [ any. any2 ] -> [:pattern | pattern beLiteral ];
		browseUsers
```

This pattern will find all sum expressions with two literals.

To narrow the filter you can add a **#where:** predicate block to match the literal values by an arbitrary criteria:

```
	| any any2 |
	[ any + any2 ] bpattern 
		with: [ any. any2 ] -> [:pattern | pattern beLiteral where: [:value | value isInteger not ]];
		browseUsers
```

###Selector patterns

Selectors can be also used as patterns:

```
	| any anyArg1 anyArg2 |
	[ any at: anyArg1 anyOtherKeyword: anyArg2 ] bpattern
```

It will match any message sends with a selector started with #at: and any other second keyword. It does not require any configuration because **#anyOtherKeyword:** is started with any word.  

The **keyword selector** pattern matches any type of selectors with same number of arguments.
For example the following pattern will match any binary messages like 1 + 2 together with any one argument keywords:

```
	| any any2 |
	[ any anyMessage: any2 ] bpattern
```

To narrow the filter to the keyword type use **#beKeyword** config:

```
	| any any2 |
	[ any anyMessage: any2 ] bpattern with: #anyMessage: -> [:pattern | pattern beKeyword ].
```

To narrow the filter to the binary type use **#beBinary** config:

```
	| any any2 |
	[ any anyMessage: any2 ] bpattern with: #anyMessage: -> [:pattern | pattern beBinary ].
```

Or you can configure any binary selector as a pattern:

```
	| any any2 |
	[ any + any2 ] bpattern with: #+.
```

Both examples will match any binary message sends lile #+, #-, #=, etc..

To play a bit try to browse all messages where receiver and arguments are literals:

```
	| anyRcv anyArg |
	[ anyRcv + anyArg ] bpattern
		with: {#+. [ anyRcv. anyArg ] -> [:pattern | pattern beLiteral ]};
		browseUsers
```

###Unary selector patterns

The unary patterns are special. If an unary selector begins with **any** word it will match any type of messages (unary, binary and keyword) with any number of arguments. No need to reference arguments explicitly:

```
	[ instVar anyMessage printString ] bpattern
```

It will match expressions like:

```
	(instVar at: #key) printString.
	instVar variable anotherVariable printString.
	(instVar + 1) printString.
```

Unary patterns are usefull to describe an arbitrary message sends. For example you can find all super calls with subsequent message sends:

```
	[ super anySuperCall anyMessage ] bpattern browseUsers
```

If you need a pattern to match **the unary** type of messages you have to explicitly configure it:

```
	[ super anySuperCall anyMessage ] bpattern 
		with: #anyMessage -> [:pattern | pattern beUnary ];
		browseUsers
```

##BMethod

Patterns defined by **#bpattern** message does not allow to use method header. To represent a method with a full signature there are **#bmethod** expressions:

```
	| anyArg1 anyArg2 |
	[[ self anyMethodName: anyArg1 anyExtraKeyword: anyArg2 ] -> [ anyArg1 isNil ifTrue: anyArg2 ]] bmethod
```

Here the enclosing block of **#bmethod** returns an association of a pattern block for a method header and a pattern block for a method body. By convention the method header should contain single message send with any receiver. AST node for this message send is extracted as a pattern to describe the method header. The selector and arguments from the header message can be used inside the body pattern:


```
		| anyStatement |
		[[ self anyMessage ] -> [ anyStatement. super anyMessage ]] bmethod 
			with: [ anyStatement ] -> [:pattern| pattern beMultiStatements ]; 
			browseUsers
```

This pattern will find all methods with a super call after any sequence of other statements.

The result of **#bmethod** is an instance of `BPattern` and therefore it can be used for the code search and for the rewrite:

```
	| stmts |
	[
		[[ self anyMessage ] -> [ stmts. self anyMessage ]] bmethod 
			->
		[[ self anyMessage ] -> [ [ stmts ] repeat ]] bmethod
	] brewrite with: [stmts] -> [:pattern| pattern beMultiStatements ]
```
Here is a rewrite example which will find a simple recursion and replace it with a loop. The recursive call can be any kind of message send with any number of arguments.

###Pragma patterns

TODO


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

{ #category : 'copying' }
BPattern >> postCopy [ 
	super postCopy.
	
	patternAST := patternAST copy.
	configs := configs copy.
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

	| rewriter bodySearch bodyRewrite |
	rewriter := BPatternASTRewriter new.
	rewriter addRule: (BPatternReplaceRule new 
			searchTree: self patternAST;
			replaceTree: rewritePattern patternAST).
	patternAST isMethod ifTrue: [ 
		bodySearch := self patternAST body statements size > 1
			ifTrue: [ self patternAST body ]
			ifFalse: [ self patternAST statements first ].
		bodyRewrite := rewritePattern patternAST body statements size > 1
			ifTrue: [ rewritePattern patternAST body ]
			ifFalse: [ rewritePattern patternAST statements first ].
		rewriter addRule: (BPatternReplaceRule new 
			searchTree: bodySearch;
			replaceTree: bodyRewrite).		
	].
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

{ #category : 'initialization' }
BPattern >> with: configSpecs [
	
	| patternConfigs |
	patternConfigs := BPatternConfig readFromSpecs: configSpecs.
	configs addAll: patternConfigs.
	isConfigured := false
]
