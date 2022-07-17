Class {
	#name : #GtUnoptimizedToDoAdvice,
	#superclass : #GtMethodAdvice,
	#category : #'GToolkit-Pharo-Coder-AddOns-MethodAdvices'
}

{ #category : #accessing }
GtUnoptimizedToDoAdvice >> description [
	^ '#to:do: is optimized by the compiler and is faster than using (to:)do:'
]

{ #category : #private }
GtUnoptimizedToDoAdvice >> fixItActionsFor: aNode using: aCriticStyler [
	^ {(GtRemoveParenthesisFixItAction
			forCoder: aCriticStyler coderModel
			node: aNode receiver)
			description: 'Convert to optimized #' , aNode receiver selector , aNode selector;
			yourself}
]

{ #category : #styling }
GtUnoptimizedToDoAdvice >> highlightPositionsFor: aSmaCCNode [
	^ OrderedCollection new
		addAll: (aSmaCCNode receiver message selectorParts collect: #sourceInterval);
		addAll: (aSmaCCNode message selectorParts collect: #sourceInterval);
		yourself
]

{ #category : #accessing }
GtUnoptimizedToDoAdvice >> matches: aNode from: aCriticRunner [
	(aNode isMessageSend and: [ aNode receiver isMessageSend ])
		ifFalse: [ ^ false ].
	^ aNode message selector = #do:
		and: [ #(to: #to:by:) includes: aNode receiver message selector ]
]

{ #category : #accessing }
GtUnoptimizedToDoAdvice >> name [
	^ 'to:{by:}do: not optimized'
]

{ #category : #enumerating }
GtUnoptimizedToDoAdvice >> potentialFilter [
	^ (#do: gtReferences & (#to: gtReferences | #to:by: gtReferences))
		asAsyncStream
]