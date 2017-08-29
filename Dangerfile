# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

swiftlint.directory = ENV['BUDDYBUILD_WORKSPACE']
swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files


begin
  xcov.report(
    scheme: ENV['BUDDYBUILD_SCHEME'],
    project: "#{ENV['BUDDYBUILD_WORKSPACE']}/Batman.xcodeproj",
    minimum_coverage_percentage: 30,
    derived_data_path: ENV['BUDDYBUILD_TEST_DIR'],
  )
rescue
    warn("Danger was unable to gather Code Coverage.")
end

changed_files = git.modified_files + git.added_files - git.deleted_files
modified_code = changed_files.include? "Batman/*.swift"
updated_release_notes = changed_files.include? "buddybuild_release_notes.txt"

fail "You forgot to update the `buddybuild_release_notes.txt` file - ([docs](http://docs.buddybuild.com/docs/focus-message))" if modified_code && !updated_release_notes
