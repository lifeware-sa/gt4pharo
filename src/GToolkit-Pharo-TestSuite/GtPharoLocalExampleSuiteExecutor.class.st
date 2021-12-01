Class {
	#name : #GtPharoLocalExampleSuiteExecutor,
	#superclass : #Object,
	#traits : 'TGtPharoSuiteExecutor',
	#classTraits : 'TGtPharoSuiteExecutor classTrait',
	#category : #'GToolkit-Pharo-TestSuite-Executor'
}

{ #category : #'api - testing' }
GtPharoLocalExampleSuiteExecutor >> isLocal [

	^ true
]

{ #category : #'api - execution' }
GtPharoLocalExampleSuiteExecutor >> playSelectedInMethodsCoder: aMethodsCoder [

	"Execute examples of a given methods coder"

	aMethodsCoder exampler runExamples
]

{ #category : #'api - execution' }
GtPharoLocalExampleSuiteExecutor >> playSuiteCase: aSuiteCase [
	"Execute a given test case / example"
	
	aSuiteCase hasNoTestPragma
		ifFalse: [ aSuiteCase run ]
]