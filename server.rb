require 'yaml'
require 'sinatra'

CONFIG_FILE = 'repo.yml'

class RepoConfig

  class YAMLFileLoader

    def initialize path
      @path = path
      reload!
    end

    def reload!
      @stored_config = YAML.load(File.read(@path))
    end

    def set_config_state config
      config.distribution = distribution
      config.versions, _ = versions
      config.repos = all_repos
    end

    private

    def distribution
      @stored_config['ubuntu']
    end

    def versions
      versions = @stored_config['versions']
      version_names = versions.keys
      [version_names, versions] 
    end

    def groups version
      _, version_data = versions
      groups = version_data[version]
      group_names, groups = [groups.keys, groups]
      [group_names, groups]
    end

    def sections version, group
      group_names, groups = groups(version)

      section_names, sections = groups.keys, groups[group]
      [section_names, sections]
    end

    def component_names version_name, group_name, section_name
      _, sections = sections(version_name, group_name)
      component_names = sections[section_name]
      component_names
    end

    def repos version_name, group_name, section_name, component_name
        _, sections = sections(version_name, group_name)
        section_data = sections[section_name]
        component_names(version_name,group_name,section_name).map do |component_name|
        {
          :canonical_path => Dir.abspath(File.join(section_data['path'], component_name)),
          :name => "#{version}/#{group}/#{section}/#{component_name}"
        }
      end
    end

    def all_repos
      all_version_names, _ = versions
      all_group_names = all_version_names.map{|v| group_names, _ = groups(v); group_names }.flatten
      all_section_names = all_version_names.map{|v| all_group_names.map{|g| section_names, _ = sections(v,g); section_names }}.flatten

      all_component_names = all_section_names.map{|s| 
                                 all_group_names.map{|g| 
                                   all_version_names.map{|v|
                                     component_names(v, g, s)
                                   }
                                 }
                               }.flatten

      all_repos = all_component_names.map{|c| all_section_names.map{|s| all_group_names.map{|g| all_version_names.map{|v| repos(v, g, s, c) }}}}.flatten
    end

  end

  def initialize loader
    @loader = loader
    loader.set_config_state(self)
  end

  attr_accessor :distribution, :versions, :repos

  def self.from_yaml_file path
    new YAMLFileLoader.new(path)
  end

end

config = RepoConfig.from_yaml_file(CONFIG_FILE)

get '/' do
  config.repos.inspect
end

config = RepoConfig.from_yaml_file(CONFIG_FILE)
