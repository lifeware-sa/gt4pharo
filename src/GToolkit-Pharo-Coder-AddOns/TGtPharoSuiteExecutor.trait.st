Trait {
	#name : #TGtPharoSuiteExecutor,
	#category : #'GToolkit-Pharo-Coder-AddOns-Test Case'
}

{ #category : #'api - testing' }
TGtPharoSuiteExecutor >> isLocal [

	"Return true if execution happens in the same image (process)."

	^ false
]

{ #category : #'api - testing' }
TGtPharoSuiteExecutor >> isRemote [

	"Return true if execution happens in another image (process)."

	^ false
]

{ #category : #'api - execution' }
TGtPharoSuiteExecutor >> playSelectedInMethodsCoder: aMethodsCoder [

	"Execute test cases of a given methods coder"

	self explicitRequirement
]