Class {
	#name : #GtPharoSnippetCoderViewModel,
	#superclass : #GtPharoSourceCoderViewModel,
	#instVars : [
		'context',
		'sharedBindings'
	],
	#category : #'GToolkit-Pharo-Coder-Method-UI-! View Models'
}

{ #category : #accessing }
GtPharoSnippetCoderViewModel >> allowSaveDueTo: anObject [
	"do nothing"
]

{ #category : #'api - coder model' }
GtPharoSnippetCoderViewModel >> behavior [
	^ self selfObject class
]

{ #category : #'private - bindings' }
GtPharoSnippetCoderViewModel >> compositeVariableBindings [
	| theBindings |

	theBindings := super compositeVariableBindings.
	theBindings addBindings: sharedBindings.
	
	context ifNotNil: [ :aContext | theBindings addBindings: (GtContextVariablesBindings new context: aContext) ].
	
	^ theBindings
]

{ #category : #accessing }
GtPharoSnippetCoderViewModel >> context [
	^ context
]

{ #category : #accessing }
GtPharoSnippetCoderViewModel >> context: anObject [
	context := anObject
]

{ #category : #'private - evaluation' }
GtPharoSnippetCoderViewModel >> evaluationContext [
	^ super evaluationContext
		runtimeContext: self context
]

{ #category : #'api - coder model' }
GtPharoSnippetCoderViewModel >> hasDeclaredVariableNamed: aVariableName [
	"Return true if a variable with a given name is declared"
	<return: #Boolean>

	(super hasDeclaredVariableNamed: aVariableName)
		ifTrue: [ ^ true ].

	"in case of the workspace we ignore non-capitalized variables as they are temporary variables
	and are always declared"
	aVariableName first isUppercase not
		ifTrue: [ ^ true ].

	^ false
]

{ #category : #initialization }
GtPharoSnippetCoderViewModel >> initialize [
	super initialize.
	
	sharedBindings := GtSharedVariablesBindings new
]

{ #category : #'api - coder model' }
GtPharoSnippetCoderViewModel >> onCoderModelChanged [
	super onCoderModelChanged.

	self localBindings
		localAt: #thisCoderViewModel
		put: self.
		
	self localBindings
		localAt: #thisCoder
		put: self coderModel
]

{ #category : #accessing }
GtPharoSnippetCoderViewModel >> preventSaveDueTo: anObject [
	"do nothing"
]

{ #category : #'api - actions' }
GtPharoSnippetCoderViewModel >> profileWithMessageTally [
	<return: #Boolean>

	^ self coderModel profileWithMessageTallyInContext: self evaluationContext
]

{ #category : #'api - bindings' }
GtPharoSnippetCoderViewModel >> sharedBindings [
	<return: #GtSharedVariablesBindings>

	^ sharedBindings
]

{ #category : #'api - bindings' }
GtPharoSnippetCoderViewModel >> sharedBindings: aGtSharedVariablesBindings [
	sharedBindings := aGtSharedVariablesBindings
]