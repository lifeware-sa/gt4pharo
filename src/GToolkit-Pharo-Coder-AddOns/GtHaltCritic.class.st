Class {
	#name : #GtHaltCritic,
	#superclass : #GtMethodCritic,
	#category : #'GToolkit-Pharo-Coder-AddOns-Critics'
}

{ #category : #accessing }
GtHaltCritic >> description [
	^ 'Debugging code is in method and should be removed before it is released.'
]

{ #category : #accessing }
GtHaltCritic >> haltSelectors [
	^ #(halt haltOnce haltIf:)
]

{ #category : #accessing }
GtHaltCritic >> highlightPositionsFor: aSmaCCNode [
	^ {aSmaCCNode sourceInterval}
]

{ #category : #testing }
GtHaltCritic >> includeFixIt [
	^ false
]

{ #category : #accessing }
GtHaltCritic >> matches: aNode from: aCriticRunner [
	aNode isMessage ifTrue: [ ^ self haltSelectors includes: aNode selector ].
	aNode isMessageSend
		ifTrue: [ | receiver method |
			receiver := aNode receiver.
			receiver isVariable ifFalse: [ ^ false ].
			receiver variableName = #Halt ifFalse: [ ^ false ].
			method := Halt class compiledMethodAt: aNode selector ifAbsent: [ ^ false ].
			^ method pragmas
				anySatisfy: [ :each | each selector = #debuggerCompleteToSender ] ].
	^ false
]

{ #category : #accessing }
GtHaltCritic >> name [
	^ 'Debugging code in method'
]

{ #category : #enumerating }
GtHaltCritic >> potentialFilter [
	^ ((self haltSelectors
		inject: GtSearchNullFilter new
		into: [ :sum :each | sum | each gtReferences ]) | Halt gtReferences)
		asAsyncStream
]