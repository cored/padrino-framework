def setup_mock
    require_dependencies 'flexmock', :group => 'test'
    case options[:test].to_s
        when 'rspec'
            inject_into_file 'spec/spec_helper.rb', "  conf.mock_with :flexmock\n", :after => "Spec::Runner.configure do |conf|\n"
    end
end
