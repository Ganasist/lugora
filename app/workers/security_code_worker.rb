class SecurityCodeWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true

  def perform(user_id)
    user = User.find(user_id)
    user.security_codes = []
    random_array = (100000..999999).to_a.shuffle!
    codes = []
    144.times do
      code = random_array.slice!(0)
      codes.push(code)
    end
    user.security_codes = codes
    user.save!
  end
end