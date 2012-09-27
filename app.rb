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
                      :to => 'info@indysa.org',
                      :from => ENV['INDYSA_USER'],
                      :via => :smtp, 
                      :via_options => {
                        :address => ENV['INDYSA_SERVER'],
                        :port => 25,
                        :domain => 'heroku.com',
                        :user_name => ENV['INDYSA_USER'],
                        :password => ENV['INDYSA_PASSWORD'],
                        :authentication => :plain,
                        :enable_starttls_auto => true
                      }
                    }

get '/status' do
  "<h1 style='color: green'>Operational</h1>"
end

post '/mail' do
  senders_name = params[:name]
  senders_email = params[:email]
  msg = params[:message]
  subject = params[:subject]

  body = "#{senders_name}, #{senders_email}\n\n#{subject}\n\n#{msg}"

  settings.mail_options[:body] = body
  settings.mail_options[:subject] = "New message via IndySA.org contact form"

  Pony.mail(settings.mail_options)
  redirect "http://indysa.org/success.html"
end