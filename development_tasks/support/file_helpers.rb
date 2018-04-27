require 'fileutils'

module FileHelpers
  GEM_ROOT_PATH = File.expand_path('../../..', __FILE__).freeze
  RAILS_APP_PATH = File.expand_path(File.join(GEM_ROOT_PATH, 'tmp', 'rails_app')).freeze

  def append_to_file(path_to_file, content)
    raise 'The specified path is not a file!' unless File.file? path_to_file

    File.open(path_to_file, 'a') do |f|
      f.write content
    end
  end

  def append_to_beginning_of_file(path_to_file, content)
    raise 'The specified path is not a file!' unless File.file? path_to_file

    existing_content_as_array = File.open(path_to_file, 'r').readlines

    new_content_arr = [content] + existing_content_as_array

    write_file_with_content path_to_file, new_content_arr.join("\n")
  end

  def write_file_with_content(path_to_file, content)
    File.open(path_to_file, 'w') do |f|
      f.write content
    end
  end

  def switch_to_gems_root_path
    FileUtils.cd GEM_ROOT_PATH
  end

  def switch_to_rails_app_path
    FileUtils.cd RAILS_APP_PATH
  end

  def generate_rails_application
    # Remove the app, if it exists already
    system("rm -rf #{RAILS_APP_PATH}")

    FileUtils.mkdir_p RAILS_APP_PATH
    system("bundle exec rails new #{RAILS_APP_PATH}")
  end

  def gems_root_path
    GEM_ROOT_PATH
  end

  def rails_app_path
    RAILS_APP_PATH
  end
end