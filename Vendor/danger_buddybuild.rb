module Danger
  module CISource
    class Buddybuild < CI

      #######################################################################
      def self.validates_as_ci?(env)
        return false unless env["BUDDYBUILD_PULL_REQUEST"]

        return true
      end

      #######################################################################
      def self.validates_as_pr?(env)
        # This will get used if it's available, instead of the API faffing.
        return false unless env["BUDDYBUILD_PULL_REQUEST"]

        return true
      end

      #######################################################################
      def supported_request_sources
        @supported_request_sources ||= [Danger::RequestSources::GitHub]
      end

      #######################################################################
      def initialize(env)
        self.repo_slug = env["BUDDYBUILD_REPO_SLUG"]
        self.pull_request_id = env["BUDDYBUILD_PULL_REQUEST"]
      end
    end
  end
end
