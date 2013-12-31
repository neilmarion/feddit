class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, type: String
  field :token, type: String
  field :is_active, type: Boolean 

  index({token: 1}, {unique: true, background: true}) #unique token
  index({is_active: 1, _id: 1}, {background: true})

  validates_format_of :_id, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: "Not an email!"

  before_create :set_token

  def activate!
    self.is_active = true
    set_token # set new token for deactivation
    self.save
  end

  def deactivate!
    self.is_active = false
    set_token #set new token for activation
    self.save
  end

  def self.active_users
    where(:is_active => true)
  end

  private

  def generate_token
    o = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
    (0...100).map { o[rand(o.length)] }.join
  end

  def set_token
    self.token = self._id.gsub(/\.|@/, '') + generate_token  
  end
end
