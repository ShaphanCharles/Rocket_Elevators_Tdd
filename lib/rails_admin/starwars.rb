require "json"
require "ibm_watson/authenticators"
require "ibm_watson/text_to_speech_v1"
require 'faker'

module RailsAdmin
  module Config
    module Actions
      class Starwars < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :root? do
          true
        end
        
        register_instance_option :breadcrumb_parent do
          nil
        end
        
        register_instance_option :auditing_versions_limit do
          100
        end

        register_instance_option :route_fragment do
          'starwars.html.erb'
        end

        register_instance_option :link_icon do
          'icon-check'
        end

        register_instance_option :statistics? do
          false
        end


        register_instance_option :controller do
          proc do
            authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
                apikey: ENV["WATSON_TTS_API_KEY"]
            )
            textToSpeech = IBMWatson::TextToSpeechV1.new(
            authenticator: authenticator
            )
            textToSpeech.service_url = ENV["WATSON_TTS_URL"]
            message = Faker::Movies::StarWars.quote 

            File.open("#{Rails.root}/public/starwars.mp3", "wb") do |audio_file|
                response = textToSpeech.synthesize(
                    text: message,
                    accept: "audio/mp3",
                    voice: "en-US_AllisonVoice"
                ).result
                audio_file.write(response)
            end
          end
        end
      end
    end
  end
end