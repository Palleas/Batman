# OUTPUT_PATH = "/tmp/sandbox/#{ENV["BUDDYBUILD_BUILD_ID"]}/raw_xcodebuild_output.txt"
# JSON_FORMATTER_PATH = `bundle exec xcpretty-json-formatter`
# %x( cat "#{OUTPUT_PATH}" | XCPRETTY_JSON_FILE_OUTPUT=xcodebuild_output.json bundle exec xcpretty -f "#{JSON_FORMATTER_PATH}" )
#
# xcode_summary.project_root = ENV["BUDDYBUILD_HOME"]
# xcode_summary.report 'xcodebuild_output.json'

xcov.report(
   scheme: ENV['BUDDYBUILD_SCHEME'],
   source_directory: ENV['BUDDYBUILD_WORKSPACE'],
   project: "#{ENV['BUDDYBUILD_WORKSPACE']}/Batman.xcodeproj",
   minimum_coverage_percentage: 25,
   derived_data_path: ENV["BUDDYBUILD_TEST_DIR"],
)
