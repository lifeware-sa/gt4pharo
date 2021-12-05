"
I display various tags in the method coder element such as protocol or instance/class side

"
Class {
	#name : #GtPharoMethodCoderTagsElement,
	#superclass : #BlElement,
	#instVars : [
		'protocolTag',
		'methodCoderUIModel',
		'traitMethodTag',
		'classTag'
	],
	#category : #'GToolkit-Pharo-Coder-Method-UI-! Views'
}

{ #category : #private }
GtPharoMethodCoderTagsElement >> behaviorOtherSideName [
	^ self classTagStringForMeta: self methodCoderUIModel isMeta not
]

{ #category : #private }
GtPharoMethodCoderTagsElement >> behaviorProtocols [
	| allSubAndSuperclassProtocols excludedClasses |
	
	allSubAndSuperclassProtocols := Set new.
	excludedClasses := Set withAll: { ProtoObject . Object }.
	
	self methodCoderUIModel coder behavior withAllSubAndSuperclassesDo: [ :eachBehavior |
		(excludedClasses includes: eachBehavior)
			ifFalse: [ allSubAndSuperclassProtocols addAll: eachBehavior protocols ] ].

	^ allSubAndSuperclassProtocols asArray sorted
]

{ #category : #private }
GtPharoMethodCoderTagsElement >> behaviorSideName [
	^ self classTagStringForMeta: self methodCoderUIModel isMeta
]

{ #category : #initialization }
GtPharoMethodCoderTagsElement >> buildTags [	
	protocolTag := self newProtocolTag.
	traitMethodTag := self newTraitMethodTag.
	classTag := self newClassTag.

	^ { traitMethodTag. protocolTag. classTag }
]

{ #category : #private }
GtPharoMethodCoderTagsElement >> classTagStringFor: aMethodCoderUIModel [
	<return: #String>

	^ self classTagStringForMeta: aMethodCoderUIModel isMeta
]

{ #category : #private }
GtPharoMethodCoderTagsElement >> classTagStringForMeta: aBoolean [
	<return: #String>

	^ aBoolean
		ifTrue: [ 'class' ]
		ifFalse: [ 'instance' ]
]

{ #category : #'event handling' }
GtPharoMethodCoderTagsElement >> handleTraitMethodTagButtonClick: aButton [
	| aTraitElement aClass aSelector aMethod |

	aTraitElement := self methodCoderUIModel coder traitSource.
	aTraitElement
		ifNil: [ ^ self ].

	(aTraitElement isKindOf: TaCompositionElement)
		ifFalse: [ ^ self ].
	
	aClass := aTraitElement innerClass.
	aSelector := self methodCoderUIModel coder selector.
	aSelector
		ifNil: [ aButton phlow spawnTool: (GtClassCoderTool forClass: aClass).
			^ self ].
	aMethod := aClass compiledMethodAt: aSelector ifAbsent: [ ^ self ].
	aButton phlow spawnTool: (GtMethodCoderTool compiledMethod: aMethod)
]

{ #category : #initialization }
GtPharoMethodCoderTagsElement >> initialize [
	super initialize.
	
	self 
		layout: (BlLinearLayout horizontal cellSpacing: 4);
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent ].
		
	self addChildren: self buildTags
]

{ #category : #accessing }
GtPharoMethodCoderTagsElement >> methodCoderUIModel [
	^ methodCoderUIModel
]

{ #category : #accessing }
GtPharoMethodCoderTagsElement >> methodCoderUIModel: aMethodCoderUIModel [
	self
		assert: [ aMethodCoderUIModel isKindOf: GtPharoMethodCoderViewModel ]
		description: [ 'Must be method coder''s UI Model' ].

	methodCoderUIModel == aMethodCoderUIModel
		ifTrue: [ ^ self ].

	"do not forget to unsubscribe from the previous coder"
	self unsubscribeFromCoder.

	methodCoderUIModel := aMethodCoderUIModel.

	aMethodCoderUIModel coder weak
		when: GtCoderSourceCodeChanged
		send: #onCoderSourceTextModified:
		to: self.

	aMethodCoderUIModel coder weak
		when: GtCoderMethodModified
		send: #onCoderMethodModified:
		to: self.	

	BlFrameTelemetry
		time: [ self class name, ' #updateProtocolButton' ]
		during: [ self updateProtocolButton ].

	BlFrameTelemetry
		time: [ self class name, ' #updateTraitMethodButton' ]
		during: [ self updateTraitMethodButton ].

	BlFrameTelemetry
		time: [ self class name, ' #updateBehaviorSideButton' ]
		during: [ self updateBehaviorSideButton ]
]

{ #category : #'instance creation' }
GtPharoMethodCoderTagsElement >> newClassTag [
	^ BrButton new
		beTinySize;
		aptitude:
			BrGlamorousButtonWithLabelAptitude
				+
					(BrGlamorousWithDropdownAptitude
						handle: [ BrButton new
								beSmallSize;
								disable;
								aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
								label: self behaviorSideName ]
						content: [ BrButton new
								beSmallSize;
								aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
								label: self behaviorOtherSideName;
								action: [ :aButton | 
									aButton fireEvent: BrDropdownHideWish new.
									self methodCoderUIModel coder moveMethodToInstanceOrClass.
									classTag label: self behaviorSideName ] ])
]

{ #category : #'private - instance creation' }
GtPharoMethodCoderTagsElement >> newProtocolEditor [
	| anEditor |

	anEditor := BrEditableLabel new
		text: (self protocolStringFor: self methodCoderUIModel);
		constraintsDo: [ :c | c minWidth: 100 ];
		aptitude:
			(BrGlamorousEditableLabelAptitude new
				glamorousCodeFont;
				defaultForeground: Color black;
				fontSize: 13);
		padding: (BlInsets all: 4);
		switchToEditor;
		requestFocus;
		when: BrEditorAcceptWish
			do: [ :aWish | 
				aWish currentTarget fireEvent: (BrDropdownHideWish new).
				self methodCoderUIModel coder renameProtocol: aWish text asString.
				self updateProtocolButton ];
		when: BrEditorCancelWish
			do: [ :aWish | aWish currentTarget fireEvent: (BrDropdownHideWish new) ];
		whenKey: BlKeyCombination primaryC
			labelDo: [ :aShortcutEvent :aShortcut | 
				Clipboard clipboardText: aShortcutEvent currentTarget text asString ].
	(GtCompletionController
		on: anEditor
		strategy: GtMethodProtocolCompletionStrategy new) install.

	^ anEditor
]

{ #category : #'private - instance creation' }
GtPharoMethodCoderTagsElement >> newProtocolPickerList [
	^ BrSimpleList new
		vFitContentLimited;
		hExact: 250;
		itemStencil: [
			BrButton new
				beSmallSize;
				aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
				action: [ :aButton :aButtonModel |
					aButton fireEvent: (BrDropdownHideWish new).
					self methodCoderUIModel coder renameProtocol: aButtonModel model asString.
					self updateProtocolButton ] ];
		itemDataBinder: [ :eachButton :eachProtocol |
			eachButton viewModel model: eachProtocol.
			eachButton label: eachProtocol ];
		items: self behaviorProtocols
]

{ #category : #'private - instance creation' }
GtPharoMethodCoderTagsElement >> newProtocolTag [
	^ BrButton new
		beTinySize;
		aptitude: BrGlamorousButtonWithLabelAptitude + (BrGlamorousWithDropdownAptitude
			handle: [ self newProtocolEditor ]
			content: [ self newProtocolPickerList ])
]

{ #category : #'private - instance creation' }
GtPharoMethodCoderTagsElement >> newTraitMethodTag [
	^ BrButton new
		beTinySize;
		disable;
		aptitude:
			(BrGlamorousLabelAptitude new
				foreground: BrGlamorousColors disabledButtonTextColor);
		action:
				[ :aButton | self handleTraitMethodTagButtonClick: aButton ];
		label: '';
		fitContent
]

{ #category : #'event handling' }
GtPharoMethodCoderTagsElement >> onCoderMethodModified: anAnnouncement [
	self updateTraitMethodButton.
]

{ #category : #'event handling' }
GtPharoMethodCoderTagsElement >> onCoderSourceTextModified: anAnnouncement [
	protocolTag disabled: anAnnouncement coder isModified
]

{ #category : #private }
GtPharoMethodCoderTagsElement >> protocolStringFor: aMethodCoderUIModel [
	<return: #String>

	^ aMethodCoderUIModel coder protocol
]

{ #category : #private }
GtPharoMethodCoderTagsElement >> traitMethodStringFor: aMethodCoderUIModel [
	<return: #String>
	^ aMethodCoderUIModel coder isFromTrait
		ifTrue: [ aMethodCoderUIModel coder traitSource printString ]
		ifFalse: [ '' ]
]

{ #category : #private }
GtPharoMethodCoderTagsElement >> unsubscribeFromCoder [
	methodCoderUIModel
		ifNil: [ ^ self ].

	methodCoderUIModel coder unsubscribe: self
]

{ #category : #'private - update' }
GtPharoMethodCoderTagsElement >> updateBehaviorSideButton [
	classTag label: (self classTagStringFor: self methodCoderUIModel).
	
	self flag: #TODO.
	"canMoveMethodToInstanceOrClass is very expensive to compute"

	"classTag enabled: self methodCoderUIModel coder canMoveMethodToInstanceOrClass"
]

{ #category : #'private - update' }
GtPharoMethodCoderTagsElement >> updateProtocolButton [
	protocolTag label: (self protocolStringFor: self methodCoderUIModel)
]

{ #category : #'private - update' }
GtPharoMethodCoderTagsElement >> updateTraitMethodButton [
	traitMethodTag label: (self traitMethodStringFor: self methodCoderUIModel).
	self methodCoderUIModel coder isFromTrait
		ifTrue: [ traitMethodTag enable ]
		ifFalse: [ traitMethodTag disable ]
]