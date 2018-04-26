require 'fileutils'

module FileHelpers
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
end