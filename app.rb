require 'sinatra'
require 'rack/cors'
require 'pony'
 
use Rack::Cors do |config|
  config.allow do |allow|
    allow.origins '*'
    allow.resource '/mail', :methods => [:post]
  end
end

set :mail_options, {
                      :to => "officers@indysa.org",
                      :from => "Website Form",
                      :via => :smtp, 
                      :smtp => {
                        :host => 'smtp.gmail.com',
                        :port => '587',
                        :user => 'you@example.com',
                        :password => 'password',
                        :auth => :plain,
                        :domain => "example.com"
                      } 
                    }

get '/mail' do
  settings.mail_options[:body] = "hiya"

  settings.mail_options.inspect
end

post '/mail' do
  settings.mail_options[:body] = "hiya"
  settings.mail_options[:subject] = "hiya"

  Pony.mail(settings.mail_options)

  return
end