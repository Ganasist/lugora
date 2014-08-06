# class DepleteUserCodePool
# 	def initialize(user, code_position)
# 		@user = user
# 		@code_position = code_position		
# 	end

# 	def deplete
# 		@user.code_pool.delete(@code_position)
# 		@user.code_pool_will_change!
# 		@user.save
# 	end
# end