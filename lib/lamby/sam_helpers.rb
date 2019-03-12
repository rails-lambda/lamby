module Lamby
  module SamHelpers

    def sam_local?
      ENV['AWS_SAM_LOCAL'] == 'true'
    end

  end
end
