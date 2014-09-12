require 'grape'

module NewsletterCollector
  class API < Grape::API
    version 'v1', using: :header, vendor: 'neilmarion'
    format :json

    resource :newsletterfortheday do
      get do
        Newsletter.find("hot").topics
      end
    end
  end
end
