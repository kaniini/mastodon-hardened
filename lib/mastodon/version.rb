# frozen_string_literal: true

module Mastodon
  module Version
    module_function

    def major
      1
    end

    def minor
      6
    end

    def patch
      1
    end

    def pre
      nil
    end

    def flags
      ''
    end

    def to_a
      [major, minor, patch, pre].compact
    end

    def to_s
      [to_a.join('.'), flags].join
    end

    def source_base_url
      'https://github.com/tootsuite/mastodon'
    end

    # specify git tag or commit hash here
    def source_tag
      nil
    end

    def source_url
      if source_tag
        "#{source_base_url}/tree/#{source_tag}"
      else
        source_base_url
      end
    end
  end
end
