# frozen_string_literal: true

require 'slack-ruby-client'
require_relative 'other_setting'

Slack.configure do |conf|
  conf.token = ENV['MOKUMOKU_BOT_TOKEN']
end

# RTM Clientのインスタンス生成
client = Slack::RealTime::Client.new

# slackに接続できたときの処理
client.on :hello do
  puts 'connected!'
  client.message channel: 'C0135C2JS0L', text: 'connected!'
end
mokumoku_count = 0

# ユーザからのメッセージを検知したときの処理
client.on :message do |data|
  mokumoku_count += 1 if data.text&.match(/もくもく/)
  if data.text&.match(/もくもく(はじめ|開始|始め|再開|スタート)/)
    client.message channel: data['channel'], text: "<@#{data.user}>, もくもく頑張ってね！"
  end
  if data.text&.match(/もくもく(終わり|おわり|終了|エンド)/)
    client.message channel: data['channel'], text: "<@#{data.user}>, もくもくお疲れ様"
  end
  if data.text&.match(/何もくもく?/)
    client.message channel: data['channel'],
                   text: "もくもくカウントは #{mokumoku_count} 回です。"
  end
end
ura_setting(client)

# Bot start
client.start!
