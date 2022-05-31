Class {
	#name : #GtExtractTemporaryRefactoringController,
	#superclass : #GtPharoSourceCoderRefactoringController,
	#instVars : [
		'node',
		'tempName'
	],
	#category : #'GToolkit-Pharo-Coder-AddOns-Refactoring - Variables'
}

{ #category : #private }
GtExtractTemporaryRefactoringController >> ast [
	^ sourceCoderViewModel astAwait
]

{ #category : #accessing }
GtExtractTemporaryRefactoringController >> behavior [
	^ sourceCoderViewModel behavior
]

{ #category : #executing }
GtExtractTemporaryRefactoringController >> findNodeAssigning: aString [
	self ast allNodesDo: [ :each | (each isAssignment and: [ each variable source = aString ]) ifTrue: [ ^ each variable ] ].
	^ nil
]

{ #category : #accessing }
GtExtractTemporaryRefactoringController >> node: aProgramNode [
	node := aProgramNode
]

{ #category : #accessing }
GtExtractTemporaryRefactoringController >> refactoring [
	| model class selector |
	model := self createRefactoringModel.
	class := model classFor: self behavior.
	selector := self selector.
	tempName := self safeTemporaryName.
	^ RBExtractToTemporaryRefactoring
		model: model
		extract: self sourceInterval
		to: tempName
		from: selector
		in: class
]

{ #category : #accessing }
GtExtractTemporaryRefactoringController >> refactoringName [
	^ 'Create temporary from ' , node source
]

{ #category : #private }
GtExtractTemporaryRefactoringController >> safeTemporaryName [
	| name index found ast |
	name := '_'.
	index := 0.
	ast := self ast.
	[ found := false.
	ast nodesDo: [ :each | (each defines: name) ifTrue: [ found := true ] ].
	found or: [ (self behavior allInstVarNames includes: name) or: [ self behavior allClassVarNames includes: name asSymbol ] ] ]
		whileTrue:
			[ name := 't' , index printString.
			index := index + 1 ].
	^ name
]

{ #category : #executing }
GtExtractTemporaryRefactoringController >> safelyExecute [
	| refactoring model |
	refactoring := self refactoring.
	refactoring primitiveExecute.
	model := refactoring model.
	self setText: (self updatedSourceFrom: model).
	(self findNodeAssigning: tempName)
		ifNotNil:
			[ :var | 
			sourceCoderViewModel
				selectNone;
				moveCursorTo: var stopPosition;
				renameLocalVariableAt: var stopPosition ]
]

{ #category : #accessing }
GtExtractTemporaryRefactoringController >> selector [
	^ sourceCoderViewModel selector
]

{ #category : #accessing }
GtExtractTemporaryRefactoringController >> sourceInterval [
	^ node sourceInterval
]

{ #category : #executing }
GtExtractTemporaryRefactoringController >> updatedSourceFrom: model [
	^ (model classFor: self behavior) sourceCodeFor: self selector
]