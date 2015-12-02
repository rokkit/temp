# ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.tap do |klass|
# # Use identity which does no casting
#   klass::OID.register_type('mchar', klass::OID::Identity.new)
# end
