Extension { #name : 'BPattern' }

{ #category : '*BPatterns-Calypso' }
BPattern >> asMethodQuery [

	^BPatternMethodQuery withPattern: self
]

{ #category : '*BPatterns-Calypso' }
BPattern >> browseUsers [

	^ClyQueryBrowserMorph openOn: self asMethodQuery
]

{ #category : '*BPatterns-Calypso' }
BPattern >> browseUsersInClass: aClass [

	^self browseUsersInScope: (ClyBothMetaLevelClassScope of: aClass in: ClyNavigationEnvironment currentImage)
]

{ #category : '*BPatterns-Calypso' }
BPattern >> browseUsersInScope: aScope [

	^ClyQueryBrowserMorph openOn: (self asMethodQuery withScope: aScope)
]
