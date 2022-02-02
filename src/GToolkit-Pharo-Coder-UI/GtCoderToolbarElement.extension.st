Extension { #name : #GtCoderToolbarElement }

{ #category : #'*GToolkit-Pharo-Coder-UI' }
GtCoderToolbarElement >> addBaselineTab: look [
	<gtCreateComponentTab: 40>
	^ BrTab new
		aptitude: BrGlamorousTabAptitude new;
		label: 'Baseline';
		stencil: [ | element |
			element := GtPharoCreateBaselineElement new.
			element
				behaviorBlock: [ :cls | 
					look hide.
					navigationModel selectClass: cls ].
			element forBaselineDefinition.
			navigationModel
				selectedPackageDo: [ :package | element forPackageReference: package ].
			element ]
]