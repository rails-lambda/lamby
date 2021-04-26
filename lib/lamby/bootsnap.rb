unless ENV['LAMBY_BOOTSNAP_PRECOMPILE']
  require 'bootsnap'
  Bootsnap::LoadPathCache::Store.class_eval do
    def commit_transaction ; end
  end
end
require 'bootsnap/bootsnap' # https://git.io/JOSzG
require 'bootsnap/setup'
