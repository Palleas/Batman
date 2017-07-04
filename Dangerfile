# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"


puts "----------"
swiftlint.directory = ENV['BUDDYBUILD_WORKSPACE']
#swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files
puts "----------"

xcov.report(
  scheme: ENV['BUDDYBUILD_SCHEME'],
  project: "#{ENV['BUDDYBUILD_WORKSPACE']}/Batman.xcodeproj",
  minimum_coverage_percentage: 30,
  derived_data_path: ENV['BUDDYBUILD_TEST_DIR'],
)
