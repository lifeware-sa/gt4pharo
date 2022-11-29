Class {
	#name : #GtParenthesisFolderAttribute,
	#superclass : #BrGlamorousTriangleExpanderTextAttribute,
	#instVars : [
		'attribute'
	],
	#category : #'GToolkit-Pharo-Coder-UI-Attributes'
}

{ #category : #accessing }
GtParenthesisFolderAttribute class >> forAttribute: anAttribute [
	^self new attribute: anAttribute
]

{ #category : #accessing }
GtParenthesisFolderAttribute >> applyExpandedOrCollapsedAttributesOn: aTBrTextEditorTextualPiece in: aTextEditor [
	| text |
	text := aTextEditor text.
	text
		findAttribute: attribute
		indicesDo: [ :aParenthesesStart :aParenthesesEnd | 
			isExpanded
				ifTrue: [ text
						clearAttributes: aParenthesesStart
						to: aParenthesesEnd
						if: [ :att | att class == BrTextHideAttribute ] ]
				ifFalse: [ text
						clearAttributes: aParenthesesStart
						to: aParenthesesEnd
						if: [ :att | 
							att ~= attribute
								and: [ att isOverwritableByStyler or: [ att class == GtParenthesisFolderAttribute ] ] ].
					text
						attribute: BrTextHideAttribute new beNotOverwritableByStyler
						from: aParenthesesStart
						to: aParenthesesEnd ] ].
	aTextEditor text: text
]

{ #category : #accessing }
GtParenthesisFolderAttribute >> attribute: anAttribute [
	attribute := anAttribute
]

{ #category : #accessing }
GtParenthesisFolderAttribute >> initialize [
	super initialize.
	self beNotOverwritableByStyler.
	isExpanded := true
]