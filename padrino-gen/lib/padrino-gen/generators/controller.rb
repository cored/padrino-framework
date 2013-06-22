module Padrino
  module Generators
    ##
    # Responsible for generating route controllers and associated tests within a Padrino application.
    #
    class Controller < Thor::Group

      # Add this generator to our padrino-gen
      Padrino::Generators.add_generator(:controller, self)

      # Define the source template root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      # Defines the banner for this CLI generator
      def self.banner; "padrino-gen controller [name]"; end

      # Include related modules
      include Thor::Actions
      include Padrino::Generators::Actions
      include Padrino::Generators::Components::Actions

      desc "Description:\n\n\tpadrino-gen controller generates a new Padrino controller"

      argument     :name,      :desc => 'The name of your padrino controller'
      argument     :fields,    :desc => 'The fields for the controller',                            :default => [],     :type => :array
      class_option :root,      :desc => 'The root destination',                   :aliases => '-r', :default => '.',    :type => :string
      class_option :app,       :desc => 'The application destination path',       :aliases => '-a', :default => '/app', :type => :string
      class_option :destroy,                                                      :aliases => '-d', :default => false,  :type => :boolean
      class_option :namespace, :desc => 'The name space of your padrino project', :aliases => '-n', :default => '',     :type => :string
      class_option :layout,    :desc => 'The layout for the controller',          :aliases => '-l', :default => '',     :type => :string
      class_option :parent,    :desc => 'The parent of the controller',           :aliases => '-p', :default => '',     :type => :string
      class_option :provides,  :desc => 'the formats provided by the controller', :aliases => '-f', :default => '',     :type => :string

      # Show help if no argv given
      require_arguments!

      # Execute controller generation
      #
      # @api private
      def create_controller
        self.destination_root = options[:root]
        if in_app_root?
          app = options[:app]
          check_app_existence(app)
          @project_name = options[:namespace].underscore.camelize
          @project_name = fetch_project_name(app) if @project_name.empty?
          @app_name     = fetch_app_name(app)
          @actions      = controller_actions(fields)
          @controller   = name.to_s.underscore
          @layout       = options[:layout] if options[:layout] && !options[:layout].empty?
          
          block_opts = []
          block_opts << ":parent => :#{options[:parent]}" if options[:parent] && !options[:parent].empty?
          block_opts << ":provides => [#{options[:provides]}]" if options[:provides] && !options[:provides].empty?
          @block_opts_string = block_opts.join(', ') unless block_opts.empty?

          self.behavior = :revoke if options[:destroy]
          template 'templates/controller.rb.tt', destination_root(app, 'controllers', "#{name.to_s.underscore}.rb")
          template 'templates/helper.rb.tt',     destination_root(app, 'helpers', "#{name.to_s.underscore}_helper.rb")
          empty_directory destination_root(app, "/views/#{name.to_s.underscore}")
          include_component_module_for(:test)
          generate_controller_test(name) if test?
        else
          say 'You are not at the root of a Padrino application! (config/boot.rb not found)'
        end
      end
    end # Controller
  end # Generators
end # Padrino
