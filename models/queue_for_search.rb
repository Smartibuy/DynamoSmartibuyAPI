require 'aws-sdk'
require './config/config_env.rb'

class Queue_for_search

    def initialize
      # create credentials
      aws_access = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])

      # are credentials set?
      puts aws_access.set?

      # create the sqs object
      @sqs = Aws::SQS::Client.new(
        region: ENV['AWS_REGION'],
        credentials: aws_access,
      )
    end

    def enqueue(key_word)
      resp = @sqs.send_message({
        queue_url: ENV['QUEUE_URL_FOR_SEARCH'],
        message_body: key_word,
      })

      if resp.successful?
        puts 'successful'
      else
        puts 'failed'
      end
    end
end
