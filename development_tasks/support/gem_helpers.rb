module GemHelpers
  def add_gem(name, attributes = {})
    line = if attributes.empty?
            "gem '#{name}'"
          else
            "gem '#{name}', #{attributes.to_s}"
          end
    
    append_to_file('Gemfile', "#{line}\n")
  end


  # 'Override'/force a specific gem version, as defined in the Appraisal.
  def ensure_gem_versions_defined_in_appraisal_are_used
    gems_defined_in_appraisal = retrieve_gems_from_gemfile(ENV['BUNDLE_GEMFILE'])
    gems_defined_in_gemfile = retrieve_gems_from_gemfile('Gemfile').collect { |l| l.gem_name }

    gems_to_override = gems_defined_in_appraisal.reject { |l| gems_defined_in_gemfile.include? l.gem_name }.each do |gem|
      add_gem gem.gem_name, gem.attributes.join(',')
    end
  end

  def install_simplecov(coverage_dir)
    append_to_beginning_of_file 'spec/spec_helper.rb', %{
      require 'simplecov'
      require 'rails_readonly_injector'
    }
    append_to_beginning_of_file 'features/support/env.rb', "require 'simplecov'"
    
    write_file_with_content '.simplecov', %{
      SimpleCov.start do
        coverage_dir '#{coverage_dir}'
      end
    }
  end

  def unset_appraisal_environment_variables
    ENV.delete('BUNDLE_GEMFILE')
    ENV.delete('BUNDLE_BIN_PATH')
    ENV.delete('RUBYOPT')
  end

  private

  def retrieve_gems_from_gemfile(file_path)
    gems = []

    File.open(file_path).readlines.each do |line|
      matches = line.match /^\s*gem\s+['|"]/

      next if matches.nil?

      parts = line.split(',')
      
      gem_name = parts.first.gsub(/\s*gem\s*|["|']|\n/, '')

      gems << OpenStruct.new({ gem_name: gem_name, attributes: parts.drop(1) })
    end

    gems
  end
end