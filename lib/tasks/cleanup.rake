namespace :cleanup do
	desc 'Delete users who did not activate their accounts within a week.'
	task :users => :environment do
		dd = DateTime.now - 7.days
		#users = User.where(['created_at < ? and confirmed_at IS NULL', dd]).destroy_all
		users = User.where(['role = 0 and created_at < ? and confirmed_at IS NULL', dd]).order(:id => :desc)
		users.each do |p|
			test = Payment.where(:user_id => p.id).first
			if !test
				p.destroy
			end
		end
		puts "Done!"
	end

	task :test => :environment do
		dd = DateTime.now - 7.days
		puts dd
		users = User.where(['role = 0 and created_at < ? and confirmed_at IS NULL', dd]).order(:id => :desc)
		i = 0
		users.each do |p|
			test = Payment.where(:user_id => p.id).first
			if test
				#puts "Miss!"
			else
				i += 1
				puts p.id.to_s + " " + p.name + " " + p.created_at.to_s + " " + p.sign_in_count.to_s
			end
		end
		puts "Total count: " + i.to_s
	end

end

