# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

swiftlint.directory = ENV['BUDDYBUILD_WORKSPACE']
swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files

OUTPUT = "/tmp/sandbox/#{ENV["BUDDYBUILD_BUILD_ID"]}/raw_xcodebuild_output.txt"
FORMATTER = "bundle exec xcpretty-json-formatter"
%x( cat "#{OUTPUT}" | XCPRETTY_JSON_FILE_OUTPUT=xcodebuild_output.json bundle exec xcpretty -f "#{FORMATTER}" )

xcode_summary.project_root = ENV["BUDDYBUILD_HOME"]   xcode_summary.report 'xcodebuild_output.json'
#xcov.report(
#  scheme: ENV['BUDDYBUILD_SCHEME'],
#  project: "#{ENV['BUDDYBUILD_WORKSPACE']}/Batman.xcodeproj",
#  minimum_coverage_percentage: 30,
#  derived_data_path: ENV['BUDDYBUILD_TEST_DIR'],
#)
