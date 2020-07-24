# frozen_string_literal: true

require 'aws-sdk'
require 'aws-sdk-s3'

secret = ENV['AWS_SECRET_ACCESS_KEY']
akid = ENV['AWS_ACCESS_KEY_ID']

Aws.config.update({
                    region: 'ap-northeast-1',
                    credentials: Aws::Credentials.new(akid, secret)
                  })

def mokumoku_count_save_on_s3(mokumoku_count)
  s3 = Aws::S3::Resource.new
  bucket = s3.bucket('mokumoku-bot-count')

  mokumoku_count =
    [bucket.object('mokumoku-bot-count/mokumoku_count.txt').get.body.read.to_i, mokumoku_count].max

  mokumoku_count_up_and_local_save(mokumoku_count)

  bucket.object('mokumoku-bot-count/mokumoku_count.txt')
  bucket.put_object(key: 'mokumoku-bot-count/mokumoku_count.txt', body: File.open('mokumoku_count.txt'))
end

def mokumoku_count_up_and_local_save(mokumoku_count, file = 'mokumoku_count.txt')
  count = mokumoku_count

  File.open file, File::TRUNC | File::RDWR do |f|
    f.print count.to_s
  end

  File.open file, File::RDONLY do |f|
    count = f.read.to_i + 1
  end

  File.open file, File::TRUNC | File::RDWR do |f|
    f.print count.to_s
  end
  count
end
