class User
  include Mongoid::Document
  authenticates_with_sorcery!
  include Mongoid::Timestamps

  field :_id, type: String #email
  field :activation_state, type: String
  field :activation_token, type: String
end
