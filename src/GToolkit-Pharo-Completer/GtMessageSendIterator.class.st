Class {
	#name : #GtMessageSendIterator,
	#superclass : #Object,
	#instVars : [
		'code',
		'block',
		'conditionalForwardJumps',
		'backwardJumps'
	],
	#classVars : [
		'ConditionalSelectors',
		'LoopSelectors'
	],
	#category : #'GToolkit-Pharo-Completer-Completion'
}

{ #category : #examples }
GtMessageSendIterator class >> example [
	<gtExample>
	
	| messages condition values |
	
	"Some dummy code to affect the results"
	condition := #printString = #printOn:.
	condition ifTrue: [ [ condition not ] whileTrue: [ condition := condition not ] ].
	condition ifFalse: [ condition := condition not ].
	
	messages := GtPrefixTree new.
	self messageSendsIn: thisContext method do: [ :selector :count | messages add: selector weight: count ].
	values := #(#('=' 1) #('ifTrue:' 1) #('not' 3) #('whileTrue:' 1) #('ifFalse:' 1) #('new' 1) #(#messageSendsIn:do: 1) #('method' 1) #(#add:weight: 1) #('do:' 1) #('assert:equals:' 2) #('weightOf:' 1) #('first' 1) #('last' 1) #('size' 2)).
	values do: [ :each | self assert: (messages weightOf: each first) equals: each last ].
	self assert: values size equals: messages size.
	^ messages
]

{ #category : #initialization }
GtMessageSendIterator class >> initialize [
	ConditionalSelectors := IdentitySet
		withAll:
			#(ifTrue: ifFalse: and: or: #ifTrue:ifFalse: #ifFalse:ifTrue: ifNil: ifNotNil: #ifNil:ifNotNil: #ifNotNil:ifNil: caseOf: #caseOf:otherwise:).
	LoopSelectors := IdentitySet withAll: #(whileTrue whileTrue: whileFalse whileFalse: #to:do: #to:by:do: repeat)
]

{ #category : #processing }
GtMessageSendIterator class >> messageSendsIn: aCompiledCode do: aBlock [
	self new messageSendsIn: aCompiledCode do: aBlock
]

{ #category : #'instruction decoding' }
GtMessageSendIterator >> conditionalJump: distance [
	distance > 0
		ifTrue: [ conditionalForwardJumps := conditionalForwardJumps + 1 ]
		ifFalse: [ backwardJumps := backwardJumps + 1 ]
]

{ #category : #initialization }
GtMessageSendIterator >> initialize [
	super initialize.
	conditionalForwardJumps := 0.
	backwardJumps := 0
]

{ #category : #'instruction decoding' }
GtMessageSendIterator >> jump: distance [
	distance > 0 ifFalse: [ backwardJumps := backwardJumps + 1 ]
]

{ #category : #processing }
GtMessageSendIterator >> messageSendsIn: aCompiledCode do: aBlock [
	block := aBlock.
	code := aCompiledCode.
	self processNormalSends.
	self processBlocksAndOptimizedSends
]

{ #category : #processing }
GtMessageSendIterator >> processBlocksAndOptimizedSends [
	| loopSelectors count conditionalSelectors |
	conditionalSelectors := OrderedCollection new.
	loopSelectors := OrderedCollection new.
	1
		to: code numLiterals - code literalsToSkip
		do:
			[ :index | 
			| value |
			value := code literalAt: index.
			(value isKindOf: CompiledCode) ifTrue: [ self class messageSendsIn: value do: block ].
			value isSymbol
				ifTrue:
					[ (ConditionalSelectors includes: value) ifTrue: [ conditionalSelectors add: value ].
					(LoopSelectors includes: value) ifTrue: [ loopSelectors add: value ] ] ].
			
	"We don't know which jumps correspond to which sends, so we just estimate them."
	conditionalForwardJumps := conditionalForwardJumps - backwardJumps max: 0.
	conditionalForwardJumps > 0
		ifTrue:
			[ conditionalSelectors notEmpty
				ifTrue:
					[ count := (conditionalForwardJumps / conditionalSelectors size) ceiling.
					conditionalSelectors do: [ :each | block value: each value: count ] ]
				ifFalse: [ backwardJumps := backwardJumps + conditionalForwardJumps ] ].
	(backwardJumps > 0 and: [ loopSelectors notEmpty ])
		ifTrue:
			[ count := (backwardJumps / loopSelectors size) ceiling.
			loopSelectors do: [ :each | block value: each value: count ] ]
]

{ #category : #processing }
GtMessageSendIterator >> processNormalSends [
	| instruction instructionStream |
	instructionStream := InstructionStream on: code.
	[ instructionStream atEnd ]
		whileFalse:
			[ instruction := instructionStream nextInstruction.
			#send:super:numArgs: = instruction selector ifTrue: [ block value: instruction arguments first value: 1 ].
			#jump: = instruction selector ifTrue: [ self jump: instruction arguments first ].
			#jump:if: = instruction selector ifTrue: [ self conditionalJump: instruction arguments first ] ]
]