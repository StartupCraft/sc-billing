# frozen_string_literal: true

GEM_ROOT = File.dirname(File.dirname(File.dirname(__FILE__)))

Dir[File.join(GEM_ROOT, '..', 'spec', 'factories', '*.rb')].each do |file|
  require(file) unless file.end_with?('/users.rb')
end
