"
I represent a state in which a test case that produced  runtime error.
"
Class {
	#name : #GtPharoMethodTestCaseErrorState,
	#superclass : #GtPharoMethodTestCaseState,
	#category : #'GToolkit-Pharo-Coder-AddOns-Test Case'
}

{ #category : #visiting }
GtPharoMethodTestCaseErrorState class >> accept: aVisitor [
	^ aVisitor visitTestCaseErrorState: self
]

{ #category : #accessing }
GtPharoMethodTestCaseErrorState class >> color [
	^ BrGlamorousColors errorBackgroundColor
]

{ #category : #accessing }
GtPharoMethodTestCaseErrorState class >> label [
	^ 'Error'
]

{ #category : #testing }
GtPharoMethodTestCaseErrorState class >> representsTestResult: aTestResult [
	^ aTestResult hasErrors
]