Class {
	#name : #GtRBPushDownMethodRefactoring,
	#superclass : #RBPushDownMethodRefactoring,
	#category : #'GToolkit-Pharo-Coder-AddOns-Refactoring - Method'
}

{ #category : #accessing }
GtRBPushDownMethodRefactoring >> preconditions [
	| condition |
	condition := selectors
			inject: self trueCondition
			into: [ :cond :each | 
				cond & (RBCondition definesSelector: each in: class)
					& (self
							forPharo12: [ RBCondition subclassesOf: class isDoingASuperSendFor: each ]
							forPharo11AndPharo10: [ RBCondition subclassesOf: class referToSelector: each ])
							not ].
	^ condition
]

{ #category : #transforming }
GtRBPushDownMethodRefactoring >> privateTransform [
	class isAbstract
		ifFalse: [ | message |
			message := class name
					, ' is not abstract. Pushing down a method can cause an error if it is called directly on '
					, class name.
			GtRefactoringNotification
				signal: message
				withTag: [ :button | 
					| container label waitingLabel stillReferencedLabel referencesButton references noReferencesLabel vertPane |
					selectors
						do: [ :each | 
							references := references
									ifNil: [ each gtReferences ]
									ifNotNil: [ references | each gtReferences ] ].
					vertPane := BrVerticalPane new
							margin: (BlInsets all: 10);
							hMatchParent;
							vFitContent.
					container := BrHorizontalPane new
							margin: (BlInsets top: 10);
							hMatchParent;
							vFitContent.

					waitingLabel := BrLabel new
							aptitude: BrGlamorousLabelAptitude new italic;
							text: 'Searching references...'.
					stillReferencedLabel := BrLabel new
							aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
							text: (selectors size > 1
									ifTrue: [ 'Selectors are' asRopedText ]
									ifFalse: [ selectors anyOne asRopedText bold , ' is' asRopedText ])
									, ' referenced in ' asRopedText.
					referencesButton := BrButton new
							aptitude: BrGlamorousLinkSquaredButtonWithLabelAptitude new glamorousCodeSmallSize;
							beSmallSize;
							margin: (BlInsets left: 2);
							label: '0 methods';
							action: [ button phlow spawnObject: references ].
					noReferencesLabel := BrLabel new
							aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
							text: 'No references were found.'.

					container
						withAsyncSinkDo: [ :anElementSink | 
							anElementSink
								sink: AsyncCounterSink new;
								whenPending: [ :aContainer :aSink | 
									aSink count > 0
										ifTrue: [ waitingLabel visibility: BlVisibility gone.
											stillReferencedLabel visibility: BlVisibility visible.
											referencesButton visibility: BlVisibility visible ].

									referencesButton
										label: (String
												streamContents: [ :aStream | 
													aStream
														print: aSink count;
														space;
														nextPutAll: ('place' asPluralBasedOn: aSink count);
														nextPutAll: '...' ]) ];
								whenSuccess: [ :aContainer :aSink | 
									waitingLabel visibility: BlVisibility gone.

									aSink count > 0
										ifTrue: [ stillReferencedLabel visibility: BlVisibility visible.
											referencesButton visibility: BlVisibility visible ]
										ifFalse: [ stillReferencedLabel visibility: BlVisibility gone.
											referencesButton visibility: BlVisibility gone.
											noReferencesLabel visibility: BlVisibility visible ].

									referencesButton
										label: (String
												streamContents: [ :aStream | 
													aStream
														print: aSink count;
														space;
														nextPutAll: ('place' asPluralBasedOn: aSink count) ]) ] ].

					container asyncSink forwardStream: references asAsyncStream.


					label := BrEditor new
							aptitude: BrGlamorousRegularEditorAptitude;
							hMatchParent;
							vFitContent;
							padding: (BlInsets all: 0);
							text: message asRopedText glamorousRegularFontAndSize.
					container
						addChildren: {waitingLabel.
								stillReferencedLabel visibility: BlVisibility gone.
								referencesButton visibility: BlVisibility gone.
								noReferencesLabel visibility: BlVisibility gone}.

					vertPane
						addChildren: {label.
								container} ] ].
	super privateTransform
]

{ #category : #accessing }
GtRBPushDownMethodRefactoring >> transform [
	class isAbstract
		ifFalse: [ | message |
			message := class name
					, ' is not abstract. Pushing down a method can cause an error if it is called directly on '
					, class name.
			GtRefactoringNotification
				signal: message
				withTag: [ :button | 
					| container label waitingLabel stillReferencedLabel referencesButton references noReferencesLabel vertPane |
					selectors
						do: [ :each | 
							references := references
									ifNil: [ each gtReferences ]
									ifNotNil: [ references | each gtReferences ] ].
					vertPane := BrVerticalPane new
							margin: (BlInsets all: 10);
							hMatchParent;
							vFitContent.
					container := BrHorizontalPane new
							margin: (BlInsets top: 10);
							hMatchParent;
							vFitContent.

					waitingLabel := BrLabel new
							aptitude: BrGlamorousLabelAptitude new italic;
							text: 'Searching references...'.
					stillReferencedLabel := BrLabel new
							aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
							text: (selectors size > 1
									ifTrue: [ 'Selectors are' asRopedText ]
									ifFalse: [ selectors anyOne asRopedText bold , ' is' asRopedText ])
									, ' referenced in ' asRopedText.
					referencesButton := BrButton new
							aptitude: BrGlamorousLinkSquaredButtonWithLabelAptitude new glamorousCodeSmallSize;
							beSmallSize;
							margin: (BlInsets left: 2);
							label: '0 methods';
							action: [ button phlow spawnObject: references ].
					noReferencesLabel := BrLabel new
							aptitude: BrGlamorousLabelAptitude new glamorousRegularFont;
							text: 'No references were found.'.

					container
						withAsyncSinkDo: [ :anElementSink | 
							anElementSink
								sink: AsyncCounterSink new;
								whenPending: [ :aContainer :aSink | 
									aSink count > 0
										ifTrue: [ waitingLabel visibility: BlVisibility gone.
											stillReferencedLabel visibility: BlVisibility visible.
											referencesButton visibility: BlVisibility visible ].

									referencesButton
										label: (String
												streamContents: [ :aStream | 
													aStream
														print: aSink count;
														space;
														nextPutAll: ('place' asPluralBasedOn: aSink count);
														nextPutAll: '...' ]) ];
								whenSuccess: [ :aContainer :aSink | 
									waitingLabel visibility: BlVisibility gone.

									aSink count > 0
										ifTrue: [ stillReferencedLabel visibility: BlVisibility visible.
											referencesButton visibility: BlVisibility visible ]
										ifFalse: [ stillReferencedLabel visibility: BlVisibility gone.
											referencesButton visibility: BlVisibility gone.
											noReferencesLabel visibility: BlVisibility visible ].

									referencesButton
										label: (String
												streamContents: [ :aStream | 
													aStream
														print: aSink count;
														space;
														nextPutAll: ('place' asPluralBasedOn: aSink count) ]) ] ].

					container asyncSink forwardStream: references asAsyncStream.


					label := BrEditor new
							aptitude: BrGlamorousRegularEditorAptitude;
							hMatchParent;
							vFitContent;
							padding: (BlInsets all: 0);
							text: message asRopedText glamorousRegularFontAndSize.
					container
						addChildren: {waitingLabel.
								stillReferencedLabel visibility: BlVisibility gone.
								referencesButton visibility: BlVisibility gone.
								noReferencesLabel visibility: BlVisibility gone}.

					vertPane
						addChildren: {label.
								container} ] ].
	super transform
]
