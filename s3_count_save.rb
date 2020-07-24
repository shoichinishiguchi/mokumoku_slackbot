# frozen_string_literal: true

require 'aws-sdk'
require 'aws-sdk-s3'

secret = ENV['AWS_SECRET_ACCESS_KEY']
akid = ENV['AWS_ACCESS_KEY_ID']

Aws.config.update({
                    region: 'ap-northeast-1',
                    credentials: Aws::Credentials.new(akid, secret)
                  })

def s3_mokumoku_count
  s3 = Aws::S3::Resource.new
  bucket = s3.bucket('mokumoku-bot-count')

  bucket.object('mokumoku-bot-count/mokumoku_count.txt').get.body.read.to_i
end

def s3_mokumoku_count_save(mokumoku_count)
  s3 = Aws::S3::Resource.new
  bucket = s3.bucket('mokumoku-bot-count')

  bucket.object('mokumoku-bot-count/mokumoku_count.txt')
  bucket.put_object(key: 'mokumoku-bot-count/mokumoku_count.txt',
                    body: mokumoku_count.to_s)
end

def s3_mokumoku_count_up_and_return
  up_count = s3_mokumoku_count + 1

  s3_mokumoku_count_save(up_count)

  up_count
end
