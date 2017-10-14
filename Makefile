CARTHAGE=carthage
BREW=brew
SWIFTGEN=swiftgen
ROME=rome

update: dependencies
	$(CARTHAGE) update --no-use-binaries --platform ios
	$(ROME) upload --platform ios

bootstrap: dependencies rebuild-assets
	$(CARTHAGE) update --no-build --no-use-binaries --platform ios
	$(ROME) download --platform ios

dependencies:
	$(BREW) update
	$(BREW) install swiftgen
	$(BREW) install blender/homebrew-tap/rome

rebuild-assets:
	$(SWIFTGEN) xcassets -t swift3 --param module=Batman -o Batman/Resources/Assets.swift Batman/Resources/Assets.xcassets
	$(SWIFTGEN) storyboards -t swift3 --param module=Batman -o Batman/Resources/Storyboards.swift Batman/Resources/Base.lproj/Main.storyboard
