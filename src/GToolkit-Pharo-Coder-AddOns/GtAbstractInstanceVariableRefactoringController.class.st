Class {
	#name : 'GtAbstractInstanceVariableRefactoringController',
	#superclass : 'GtVariableRefactoringController',
	#category : 'GToolkit-Pharo-Coder-AddOns-Variables refactoring'
}

{ #category : 'accessing' }
GtAbstractInstanceVariableRefactoringController >> refactoring [
	| aModel aClass |
	
	aModel := self createRefactoringModel.
	aClass := aModel classFor: sourceCoderViewModel behavior.

	^ RBAbstractInstanceVariableRefactoring
		model: aModel
		variable: self variableName
		class: (aClass whoDefinesClassVariable: self variableName)
]

{ #category : 'accessing' }
GtAbstractInstanceVariableRefactoringController >> refactoringName [
	^ 'Abstract instance variable {1}' format: { self variableName }
]