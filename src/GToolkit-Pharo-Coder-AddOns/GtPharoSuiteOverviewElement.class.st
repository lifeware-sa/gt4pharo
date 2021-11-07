Class {
	#name : #GtPharoSuiteOverviewElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtPharoWithSuiteViewModel',
	#classTraits : 'TBrLayoutResizable classTrait + TGtPharoWithSuiteViewModel classTrait',
	#instVars : [
		'listElement',
		'toolbarElement',
		'localToggle',
		'remoteToggle',
		'playButton',
		'updater',
		'errorElement'
	],
	#category : #'GToolkit-Pharo-Coder-AddOns-Test Case'
}

{ #category : #'private - accessing' }
GtPharoSuiteOverviewElement >> allStates [

	^ self suiteViewModel allStates
]

{ #category : #initialization }
GtPharoSuiteOverviewElement >> defaultLayout [

	^ BlLinearLayout vertical
]

{ #category : #'private - accessing' }
GtPharoSuiteOverviewElement >> errorElement [

	^ errorElement
]

{ #category : #initialization }
GtPharoSuiteOverviewElement >> initialize [

	super initialize.
	self initializeUpdater.
	self initializeListElement.
	self initializeToolbar.
	self initializeErrorElement.

	self addChild: self listElement as: #list.
	self addChild: self toolbarElement as: #toolbar.
	self addChild: self errorElement as: #error.
	self addAptitude:
		(BrLayoutResizerAptitude new vAnyToFitContent: self toolbarElement).
	self fitContent
]

{ #category : #initialization }
GtPharoSuiteOverviewElement >> initializeErrorElement [

	errorElement := BrButton new
		                beSmallSize;
		                vFitContent;
		                hMatchParent;
		                aptitude:
			                (BrGlamorousButtonExteriorAptitude new 
				                 backgroundPaint:
					                 BrGlamorousColors paleErrorBackgroundColor)
			                + BrGlamorousButtonRectangularAptitude
			                + BrGlamorousButtonIconAptitude
			                + BrGlamorousButtonLabelAptitude;
		                margin: (BlInsets top: 10);
		                visibility: BlVisibility gone;
		                icon: BrGlamorousVectorIcons inspect;
		                label: 'Execution error';
		                action: [ :aButton | 
			                self spawnErrorDetailFrom: aButton ]
]

{ #category : #initialization }
GtPharoSuiteOverviewElement >> initializeListElement [

	listElement := BrColumnedList new.
	listElement
		margin: (BlInsets bottom: 10);
		constraintsDo: [ :c | 
			c minWidth: 170. 
			c minHeight: 10. ];
		fitContent.

	listElement
		addEventHandlerOn: BrSelectionChanged
		do: [ :anEvent | 
			anEvent selectedDo: [ :theIndices | 
				| aWidgetElement aSelectedObject |
				aWidgetElement := anEvent currentTarget.
				aSelectedObject := aWidgetElement viewModel itemAt:
					                   theIndices first.
				self updateCoderFilterWith: aSelectedObject ] ].

	listElement column
		title: 'Icon';
		cellStencil: [ 
			GtPharoTestCaseUtility newColoredIcon: BlBackground transparent ];
		dataBinder: [ :anElement :anItem | 
			anElement background: anItem color ];
		width: 10.

	listElement column
		title: 'Name';
		cellStencil: [ BrLabel new aptitude: BrGlamorousLabelAptitude ];
		dataBinder: [ :anElement :anItem | anElement text: anItem label ];
		width: 120.

	listElement column
		title: 'Amount';
		cellStencil: [ 
			BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				fitContent ];
		dataBinder: [ :anElement :anItem | 
			| aTotal aTotalString aTotalText |
			aTotalString := self totalStringForState: anItem.
			aTotalText := aTotalString asRopedText foreground: Color gray.
			anElement text: aTotalText ].
	^ listElement
]

{ #category : #initialization }
GtPharoSuiteOverviewElement >> initializeToolbar [

	toolbarElement := BrToolbar new.
	toolbarElement aptitude: (BrGlamorousToolbarAptitude new spacing: 0).
	toolbarElement
		hMatchParent;
		vFitContent.

	toolbarElement addItem: (BrToggleGroup new
			 aptitude: BrGlamorousToggleGroupAptitude new;
			 addToggle: (localToggle := BrToggle new
					                 activate;
					                 disable;
					                 beSmallSize;
					                 aptitude: BrGlamorousToggleWithLabelAptitude new;
					                 label: 'Local';
					                 when: BrToggleActivatedEvent
					                 do: [ :anEvent | self onLocalActivated: anEvent ]);
			 addToggle: (remoteToggle := BrToggle new
					                  disable;
					                  beSmallSize;
					                  aptitude:
						                  BrGlamorousToggleWithLabelAptitude new;
					                  label: 'Remote';
					                  when: BrToggleActivatedEvent
					                  do: [ :anEvent | 
						                  self onRemoteActivated: anEvent ])).

	toolbarElement addItem: (BlElement new
			 viewModel: BrWidgetModel new;
			 constraintsDo: [ :c | 
				 c horizontal matchParent.
				 c vertical exact: 0 ]).

	toolbarElement addItem: (playButton := BrButton new
			               disable;
			               beSmallSize;
			               aptitude:
				               BrGlamorousButtonWithIconAndLabelAptitude new;
			               icon: BrGlamorousVectorIcons play;
			               label: 'Run';
			               action: [ :aButton | self playFrom: aButton ])
]

{ #category : #initialization }
GtPharoSuiteOverviewElement >> initializeUpdater [

	updater := GtPhlowUpdateRequester new
		           element: self
		           selector: #updateElement
]

{ #category : #'private - accessing' }
GtPharoSuiteOverviewElement >> listElement [

	^ listElement
]

{ #category : #'private - accessing' }
GtPharoSuiteOverviewElement >> localToggle [

	^ localToggle
]

{ #category : #'private - announcement handling' }
GtPharoSuiteOverviewElement >> onCodersCoderChanged [

	self updater requestUpdate
]

{ #category : #'private - announcement handling' }
GtPharoSuiteOverviewElement >> onCodersCoderChanged: anAnnouncement [

	self updater requestUpdate
]

{ #category : #'private - event handling' }
GtPharoSuiteOverviewElement >> onLocalActivated: anEvent [

	self suiteViewModel beLocalFrom: self
]

{ #category : #'private - event handling' }
GtPharoSuiteOverviewElement >> onRemoteActivated: anEvent [

	self suiteViewModel beRemoteFrom: self
]

{ #category : #'api - suite view model' }
GtPharoSuiteOverviewElement >> onSuiteViewModelChanged [

	self updateElement
]

{ #category : #'private - accessing' }
GtPharoSuiteOverviewElement >> playButton [

	^ playButton
]

{ #category : #'private - event handling' }
GtPharoSuiteOverviewElement >> playFrom: aButton [

	self suiteViewModel playFrom: aButton
]

{ #category : #'private - accessing' }
GtPharoSuiteOverviewElement >> remoteToggle [

	^ remoteToggle
]

{ #category : #'private - event handling' }
GtPharoSuiteOverviewElement >> spawnErrorDetailFrom: aButton [

	self suiteViewModel hasExecutionError ifFalse: [ ^ self ].

	aButton phlow spawnObject: self suiteViewModel executionDetail
]

{ #category : #'api - suite view model' }
GtPharoSuiteOverviewElement >> subscribeToSuiteViewModel [

	self suiteViewModel weak
		when: GtPharoSuiteViewModelChanged
		send: #onCodersCoderChanged:
		to: self
]

{ #category : #'private - accessing' }
GtPharoSuiteOverviewElement >> toolbarElement [

	^ toolbarElement
]

{ #category : #'private - accessing' }
GtPharoSuiteOverviewElement >> totalStringForState: aState [

	^ self suiteViewModel totalStringForState: aState
]

{ #category : #'api - suite view model' }
GtPharoSuiteOverviewElement >> unsubscribeFromSuiteViewModel [

	self suiteViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtPharoSuiteOverviewElement >> updateCoderFilterWith: aState [

	self suiteViewModel updateCoderFilterWith: aState source: self
]

{ #category : #'private - updating' }
GtPharoSuiteOverviewElement >> updateElement [

	self updateListElement.
	self updateToggles.
	self updatePlayButton.
	self updateErrorElement.
]

{ #category : #'private - updating' }
GtPharoSuiteOverviewElement >> updateErrorElement [

	| isVisible |
	isVisible := self suiteViewModel hasPendingExecution not and: [ 
		             self suiteViewModel hasExecutionError ].

	isVisible
		ifTrue: [ self errorElement visibility: BlVisibility visible ]
		ifFalse: [ self errorElement visibility: BlVisibility gone ]
]

{ #category : #'private - updating' }
GtPharoSuiteOverviewElement >> updateListElement [

	self listElement items: self allStates
]

{ #category : #'private - updating' }
GtPharoSuiteOverviewElement >> updatePlayButton [

	| isButtonEnabled hasPendingExecution |
	hasPendingExecution := self suiteViewModel hasPendingExecution.
	isButtonEnabled := hasPendingExecution not and: [ 
		                   self suiteViewModel
			                   hasSelectedExecutableSuiteItems ].

	self playButton enabled: isButtonEnabled.

	hasPendingExecution
		ifTrue: [ self playButton label: 'Running' ]
		ifFalse: [ self playButton label: 'Run' ]
]

{ #category : #'private - updating' }
GtPharoSuiteOverviewElement >> updateToggles [

	| hasPendingExecution |
	hasPendingExecution := self suiteViewModel hasPendingExecution.

	self localToggle enabled: hasPendingExecution not.
	self remoteToggle enabled: hasPendingExecution not.

	self suiteViewModel isLocal
		ifTrue: [ self localToggle activate ]
		ifFalse: [ self remoteToggle activate ]
]

{ #category : #'private - accessing' }
GtPharoSuiteOverviewElement >> updater [

	^ updater
]