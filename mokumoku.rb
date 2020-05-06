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
  client.message channel: ENV['EXPERIMENT_CHANNEL'], text: 'connected!'
end
mokumoku_count = 0

# ユーザからのメッセージを検知したときの処理
client.on :message do |data|
  if data.text&.match(/もくもく.*(終わり|おわり|終了|エンド|した)/)
    client.message channel: data['channel'], text: "<@#{data.user}>\nもくもくお疲れ様:relaxed:"
  elsif data.text&.match(/今、何もくもく\?/)
    client.message channel: data['channel'],
                   text: "今日までのもくもく:mokumokubot:カウントは合計 #{mokumoku_count} 回です:clap:\nまた、明日も頑張りましょう:exclamation::female-technologist::male-technologist:"
  elsif data.text&.match(/もくもく.*(はじめ|開始|始め|再開|スタート|します|!)?/)
    mokumoku_count += 1
    client.message channel: data['channel'], text: "<@#{data.user}>\nすごい！もくもく頑張ってね！:clap:"
  end
  if data.text&.match(/もくもくカウントは/) && data.user == ENV['MOKUMOKU_ADMIN']
    mokumoku_count = data.text.match(/\d+/)[0].to_i
  end
  if data.text&.match(/バルス/)
    client.message channel: data['channel'], text: 'もくもくカウントが壊れて0になりました。:cry:'
    mokumoku_count = 0
  end
end
ura_setting(client)

# Bot start
client.start!
