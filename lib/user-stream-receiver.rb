require 'logger'
require 'oauth/cli/twitter'

class UserStreamReceiver
  include OAuth::CLI::Twitter

  CONSUMER_TOKEN = 'kHOuxYqXSINzOW3UzEqEcA'
  CONSUMER_SECRET = 'x6dzx1oFjgDrtJSM2v8YYEYhyN2LnB1zUOeNo9Y'

  attr_accessor :pit_file

  def initialize(pit_file = 'user-stream-receiver')
    @pit_file = pit_file
  end

  def new_from_access_token(access_token)
    @access_token = access_token
  end

  def access_token
    @access_token ||= self.get_access_token(:pit => @pit_file)
  end

  def run(&block)
    loop {
      begin
        self.process &block
      rescue => error
        self.logger.warn error
        sleep 1
      end
    }
  end

  protected
  ENDPOINT = URI.parse('https://userstream.twitter.com/2/user.json')

  def logger
    @logger ||= Logger.new(STDOUT)
    @logger.level = Logger::INFO
    @logger
  end

  def process(&block)
    self.logger.info("connecting")
    https = Net::HTTP.new(ENDPOINT.host, ENDPOINT.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE

    https.start{ |https|
      request = Net::HTTP::Get.new(ENDPOINT.request_uri)
      request.oauth!(https, self.access_token.consumer, self.access_token)
      https.request(request){ |response|
        raise response.code.to_i unless response.code.to_i == 200
        raise 'Response is not chuncked' unless response.chunked?
        self.logger.info("connected")
        response.read_body{ |chunk|
          self.logger.debug("received: #{chunk}")
          yield chunk
        }
      }
    }
  end
end
