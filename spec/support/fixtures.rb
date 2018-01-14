def load_fixture(path)
  File.read fixture_file_path(path)
end

def load_json_fixture(path)
  JSON.parse(load_fixture(path))
end

def load_yml_fixture(path)
  YAML.load(load_fixture(path))
end

def fixture_file_path(path)
  RSpec.configuration.fixture_path + path
end
