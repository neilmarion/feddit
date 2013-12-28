class User
  include Mongoid::Document
  include Mongoid::Timestamps

  #field :email, type: String
  field :_id, type: String#, default: ->{ email.to_s.parameterize }
end
