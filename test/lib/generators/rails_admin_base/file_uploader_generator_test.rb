require 'test_helper'
require 'generators/file_uploader/file_uploader_generator'

module RailsAdminBase
  class FileUploaderGeneratorTest < Rails::Generators::TestCase
    tests FileUploaderGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
