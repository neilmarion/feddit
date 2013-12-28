require 'spec_helper'

describe UsersController do
  describe "create" do
    it "successfully creates a user" do
      expect {
        xhr :get, :create, :email => "user@email.com"
      }.to change(User, :count).by 1
    end
  end
end
