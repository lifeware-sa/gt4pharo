"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestGToolkitPharoCoderMethod,
	#superclass : #PackageManifest,
	#category : #'GToolkit-Pharo-Coder-Method-Manifest'
}

{ #category : #asserting }
ManifestGToolkitPharoCoderMethod class >> mustNotDependOn [
	^ { 
		'GToolkit-Pharo-Coder-Method-UI'.
		'GToolkit-Pharo-Coder'.
		'GToolkit-Pharo-Coder-UI'.
		'GToolkit-Pharo-Coder-AddOns'.
	}
]

{ #category : #asserting }
ManifestGToolkitPharoCoderMethod class >> mustOnlyDependOn [
		^ {
		'AST-Core'.
		'Collections-Sequenceable'.
		'Collections-Strings'.
		'Collections-Unordered'.
		'Futures'.
		'Futures-Extra'.
		'GT-Inspector'.
		'GToolkit-Coder'.
		'GToolkit-Coder-StreamingCoders'.
		'GToolkit-Completer'.
		'GToolkit-Examples'.
		'GToolkit-Pharo-Completer'.
		'GToolkit-Pharo-Metamodels'.
		'GToolkit-Pharo-Parser'.
		'GToolkit-Pharo-SearchFilters'.
		'GToolkit-Pharo-System'.
		'GToolkit-VariableBindings'.
		'Kernel'.
		'OpalCompiler-Core'.
		'Refactoring-Changes'.
		'Refactoring-Core'.
		'Refactoring-Environment'.
		'Refactoring2-Core'.
		'SmaCC_Runtime'.
		'System-Announcements'.
		'Transcript-NonInteractive'
	}
]

{ #category : #asserting }
ManifestGToolkitPharoCoderMethod class >> shouldDependOn [
	^ { 
		'GToolkit-Coder'.
		'GToolkit-Coder-StreamingCoders'.
		'GToolkit-Completer'.
		'GToolkit-Pharo-Completer'.
		'GToolkit-Pharo-Metamodels'.
		'GToolkit-Pharo-Parser'.
		'GToolkit-Pharo-SearchFilters'.
		'GToolkit-Pharo-System'.
		'GToolkit-VariableBindings'
	}
]