xcov.report(
   scheme: ENV['BUDDYBUILD_SCHEME'],
   project: "#{ENV['BUDDYBUILD_WORKSPACE']}/Batman.xcodeproj",
   minimum_coverage_percentage: 20,
   derived_data_path: ENV['BUDDYBUILD_TEST_DIR'],
)


OUTPUT = "/tmp/sandbox/#{ENV["BUDDYBUILD_BUILD_ID"]}/raw_xcodebuild_output.txt"
FORMATTER = `bundle exec xcpretty-json-formatter`
%x( cat "#{OUTPUT}" | XCPRETTY_JSON_FILE_OUTPUT=xcodebuild_output.json bundle exec xcpretty -f "#{FORMATTER}" )
xcode_summary.project_root = ENV["BUDDYBUILD_HOME"]
xcode_summary.report 'xcodebuild_output.json'
