# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

swiftlint.directory = ENV['BUDDYBUILD_WORKSPACE']
swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files

xcov.report(
  scheme: ENV['BUDDYBUILD_SCHEME'],
  project: "#{ENV['BUDDYBUILD_WORKSPACE']}/Batman.xcodeproj",
  minimum_coverage_percentage: 30,
  derived_data_path: ENV['BUDDYBUILD_TEST_DIR'],
)
