# namespace :db do
#   namespace :schema do
#     # desc 'Dump additional database schema'
#     task :dump => [:environment, :load_config] do
#       filename = "#{Rails.root}/db/uk_external_schema.rb"
#       File.open(filename, 'w:utf-8') do |file|
#         ActiveRecord::Base.schema_format = :sql
#         ActiveRecord::Base.establish_connection("uk_external_#{Rails.env}")
#         ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
#       end
#     end
#   end
#
#   namespace :test do
#     # desc 'Purge and load foo_test schema'
#     task :load_schema do
#       # like db:test:purge
#       abcs = ActiveRecord::Base.configurations
#       ActiveRecord::Base.connection.recreate_database(abcs['uk_external_test']['database'], psql_creation_options(abcs['uk_external_test']))
#       # like db:test:load_schema
#       ActiveRecord::Base.establish_connection('uk_external_test')
#       ActiveRecord::Schema.verbose = false
#       load("#{Rails.root}/db/uk_external_schema.rb")
#     end
#   end
# end
