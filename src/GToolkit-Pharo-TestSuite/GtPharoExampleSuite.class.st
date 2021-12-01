"
I am an example executor.
I am used by {{gtClass:GtCodersModel}}, see: {{gtMethod:Behavior>>#gtCoderStreamingMethodsFor:context:}} for a usage.


"
Class {
	#name : #GtPharoExampleSuite,
	#superclass : #Object,
	#instVars : [
		'examplesWithResultStream',
		'examplesWithResultCache',
		'examplesCache'
	],
	#category : #'GToolkit-Pharo-TestSuite-Base'
}

{ #category : #'api - instance creation' }
GtPharoExampleSuite class >> forStream: anAsyncStream [
	^ self new stream: anAsyncStream
]

{ #category : #'api - enumeration' }
GtPharoExampleSuite >> allExampleCodersDo: aBlock [
	"iterate all coders with examples"
	self subclassResponsibility
]

{ #category : #'api - accessing' }
GtPharoExampleSuite >> allExampleStates [
	<return: #TAsyncStream>

	^ (self allExamples collect: [ :eachExampleWithResult | self stateOf: eachExampleWithResult ]) withoutDuplicates
]

{ #category : #'api - accessing' }
GtPharoExampleSuite >> allExamples [
	<return: #TAsyncStream>

	^ examplesWithResultStream asyncSimilarCopy
]

{ #category : #'api - enumeration' }
GtPharoExampleSuite >> allExecutableExampleCodersDo: aBlock [
	self allExampleCodersDo: [ :aCoder :anExample | 
		aCoder canExecuteExample ifTrue: [ 
			aBlock cull: aCoder cull: anExample ] ]
]

{ #category : #'api - enumeration' }
GtPharoExampleSuite >> allExecutableExampleCodersWithResultsDo: aBlock [
	self allExecutableExampleCodersDo: [ :aCoder :anExample | 
		aCoder exampleResult ifNotNil: [ :aResult |
			aBlock cull: aCoder cull: anExample cull: aResult ] ]
]

{ #category : #'private - instance creation' }
GtPharoExampleSuite >> createExampleCaseForMethod: aCompiledMethod [
	^ aCompiledMethod gtExample
]

{ #category : #'api - accessing' }
GtPharoExampleSuite >> exampleWithResultForMethod: aCompiledMethod [
	<return: #GtExampleWithResult or: nil>

	^ (examplesCache
		at: aCompiledMethod
		ifAbsentPut: [ aCompiledMethod gtExample ])
			ifNotNil: [ :anExample |
				examplesWithResultCache
					at: anExample
					ifAbsentPut: [ anExample asExampleWithResult ] ]
]

{ #category : #'api - testing' }
GtPharoExampleSuite >> hasErrorExamples [
	<return: #Boolean>
	self allExecutableExampleCodersWithResultsDo: [ :eachCoder | 
		eachCoder exampleResult isError ifTrue: [ 
			^ true ] ].
	^ false
]

{ #category : #'api - testing' }
GtPharoExampleSuite >> hasExamples [
	"Returns a future that resolves to true if there is at least one example"
	<return: #TAsyncFuture>

	^ self allExamples isNotEmpty
]

{ #category : #'api - testing' }
GtPharoExampleSuite >> hasFailureExamples [
	<return: #Boolean>
	self allExecutableExampleCodersWithResultsDo: [ :eachCoder | 
		eachCoder exampleResult isFailure ifTrue: [ 
			^ true ] ].
	^ false
]

{ #category : #'api - testing' }
GtPharoExampleSuite >> hasNotExecutedExamples [
	<return: #Boolean>
	self allExecutableExampleCodersDo: [ :eachCoder | 
		eachCoder exampleResult ifNil: [ 
			^ true ] ].
	^ false
]

{ #category : #'api - testing' }
GtPharoExampleSuite >> hasSelectedExecutableExamples [
	self selectedExecutableExampleCodersDo: [ ^ true ].
	^ false
]

{ #category : #'api - testing' }
GtPharoExampleSuite >> hasSuccessExamples [
	<return: #Boolean>
	self allExecutableExampleCodersWithResultsDo: [ :eachCoder | 
		eachCoder exampleResult isSuccess ifTrue: [ 
			^ true ] ].
	^ false
]

{ #category : #'api - accessing' }
GtPharoExampleSuite >> numberOfAllExamples [
	<return: #Integer>
	| aTotal |
	aTotal := 0.
	self allExecutableExampleCodersDo: [ :eachCoder | 
		aTotal := aTotal + 1 ].
	^ aTotal
]

{ #category : #'api - accessing' }
GtPharoExampleSuite >> numberOfErrorExamples [
	<return: #Integer>
	| aTotal |
	aTotal := 0.
	self allExecutableExampleCodersWithResultsDo: [ :eachCoder | 
		eachCoder exampleResult isError ifTrue: [ 
			aTotal := aTotal + 1 ] ].
	^ aTotal
]

{ #category : #'api - accessing' }
GtPharoExampleSuite >> numberOfFailureExamples [
	<return: #Integer>
	| aTotal |
	aTotal := 0.
	self allExecutableExampleCodersWithResultsDo: [ :eachCoder | 
		eachCoder exampleResult isFailure ifTrue: [ 
			aTotal := aTotal + 1 ] ].
	^ aTotal
]

{ #category : #'api - accessing' }
GtPharoExampleSuite >> numberOfNotExecutedExamples [
	<return: #Integer>
	| aTotal |
	aTotal := 0.
	self allExecutableExampleCodersDo: [ :eachCoder | 
		eachCoder exampleResult ifNil: [ 
			aTotal := aTotal + 1 ] ].
	^ aTotal
]

{ #category : #'api - accessing' }
GtPharoExampleSuite >> numberOfSuccessExamples [
	<return: #Integer>
	| aTotal |
	aTotal := 0.
	self allExecutableExampleCodersWithResultsDo: [ :eachCoder | 
		eachCoder exampleResult isSuccess ifTrue: [ 
			aTotal := aTotal + 1 ] ].
	^ aTotal
]

{ #category : #'api - execution' }
GtPharoExampleSuite >> runExamples [
	self selectedExecutableExampleCodersDo: [ :eachCoder | 
		(eachCoder isModified or: [ eachCoder example hasNoTestPragma ]) ifFalse: [ 
			eachCoder example run ] ]
]

{ #category : #'api - execution' }
GtPharoExampleSuite >> runExamplesFrom: anElement [
	self runExamples. 
]

{ #category : #'api - execution' }
GtPharoExampleSuite >> runNoTestExamples [
	self selectedExecutableExampleCodersDo: [ :eachCoder | 
		(eachCoder isModified not and: [ eachCoder example hasNoTestPragma ]) ifTrue: [ 
			eachCoder example run ] ]
]

{ #category : #'api - enumeration' }
GtPharoExampleSuite >> selectedExampleCodersDo: aBlock [
	"iterate selected coders with examples"
	self subclassResponsibility
]

{ #category : #'api - enumeration' }
GtPharoExampleSuite >> selectedExecutableExampleCodersDo: aBlock [
	self selectedExampleCodersDo: [ :aCoder :anExample | 
		aCoder canExecuteExample ifTrue: [ 
			aBlock cull: aCoder cull: anExample ] ]
]

{ #category : #'api - enumeration' }
GtPharoExampleSuite >> selectedExecutableExampleCodersWithResultsDo: aBlock [
	self selectedExecutableExampleCodersDo: [ :aCoder :anExample | 
		aCoder exampleResult ifNotNil: [ :aResult |
			aBlock cull: aCoder cull: anExample cull: aResult ] ]
]

{ #category : #'api - accessing' }
GtPharoExampleSuite >> stateOf: aGtExampleWithResult [
	^ GtExampleState default stateFromExample: aGtExampleWithResult
]

{ #category : #initialization }
GtPharoExampleSuite >> stream: anAsyncStream [
	examplesCache := AsyncSharedDictionary new.
	examplesWithResultCache := AsyncSharedDictionary new.

	examplesWithResultStream := (((anAsyncStream
		map: [ :eachMethod | eachMethod gtExample ] cache: examplesCache)
		filter: [ :eachExample | eachExample notNil ])
		map: [ :eachExample | eachExample asExampleWithResult ] cache: examplesWithResultCache)
		cached
]