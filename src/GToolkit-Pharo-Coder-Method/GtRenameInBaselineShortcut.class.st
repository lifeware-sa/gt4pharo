Class {
	#name : #GtRenameInBaselineShortcut,
	#superclass : #GtSourceCoderInlineRenameShortcut,
	#category : #'GToolkit-Pharo-Coder-Method-Rename'
}

{ #category : #accessing }
GtRenameInBaselineShortcut >> description [
	^ 'Performs the rename refactoring of the selected variable/class/method/package.'
]

{ #category : #accessing }
GtRenameInBaselineShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	| position |
	self
		forEditor: aBrTextEditor
		selectionIntervalDo: [ :aSelectionInterval | position := aSelectionInterval last ]
		orCursorStringPositionDo: [ :aCursorTextPosition | position := aCursorTextPosition ].
	position notNil
		ifTrue: [ (aSourceCoderViewModel coder
				renamePackageAt: position
				in: aSourceCoderViewModel) ifTrue: [ ^ self ].
			(aSourceCoderViewModel coder
				renameBaselineAt: position
				in: aSourceCoderViewModel) ifTrue: [ ^ self ] ].
	super
		performOnEditor: aBrTextEditor
		element: aBrEditorElement
		coderViewModel: aSourceCoderViewModel
		dueTo: aShortcutEvent
]