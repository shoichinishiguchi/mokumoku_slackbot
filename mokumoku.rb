# frozen_string_literal: true

require 'slack-ruby-client'
require_relative 'other_setting'
require_relative 's3_count_save'
require_relative 'children_channel'

Slack.configure do |conf|
  conf.token = ENV['MOKUMOKU_BOT_TOKEN']
end
MOKUMOKU_CHANNELS = [
  'C01339G8S1F', # 宣言用
  'C0135C2JS0L' # 実験用
].freeze

KIRIBAN = [
  729,
  777,
  888,
  999,
  1024,
  1111,
  1234,
  2048,
  2222,
  3333,
  4444,
  4096,
  5555,
  6666,
  7777,
  8192,
  8888,
  9999
].freeze

# RTM Clientのインスタンス生成
client = Slack::RealTime::Client.new

# slackに接続できたときの処理
client.on :hello do
  puts 'connected!'
  # client.message channel: 'C0135C2JS0L', text: 'connected!'
end
mokumoku_count = s3_mokumoku_count

# ユーザからのメッセージを検知したときの処理(もくもく宣言関連のみ)
client.on :message do |data|
  if MOKUMOKU_CHANNELS.include?(data.channel)
    if data.text&.match(/もくもく.*(終わり|おわり|終了|エンド)/)
      client.message channel: data['channel'], text: "<@#{data.user}>\nもくもくお疲れ様:relaxed:"
    elsif data.text&.match(/今、何もくもく\?/)
      client.message channel: data['channel'],
                     text: "今日までのもくもく:mokumokubot:カウントは合計 #{mokumoku_count} 回です:clap:\nまた、来週も頑張りましょう:exclamation::female-technologist::male-technologist:"
    elsif data.text&.match(/もくもく.*(はじめ|開始|始め|再開|スタート|します|!)?/)
      mokumoku_count = s3_mokumoku_count_up_and_return

      if mokumoku_count % 1000 == 0
        client.message channel: data['channel'], text: ":congratulations: おめでとうございます！:congratulations:\n:tada:#{mokumoku_count}回目のもくもく:mokumokubot: です！！最高!:laughing::tada:\nみなさん、今後ともよろしくもくもく:mokumokubot: お願いします！"
      elsif mokumoku_count % 100 == 0
        client.message channel: data['channel'], text: ":tada::tada:<@#{data.user}>:tada::tada:\nおめでとうございます。あなたで、\nちょうど:congratulations: #{mokumoku_count}回目:congratulations: のもくもくです。すごい！!\n:mokumokubot: :mokumokubot: みなさん、これからもよろしくもくもくおねがいします！:mokumokubot::mokumokubot: "
      elsif KIRIBAN.include?(mokumoku_count)
        client.message channel: data['channel'], text: "キリ番ゲット!:sunglasses:\nちょうど:confetti_ball: #{mokumoku_count}回目:confetti_ball: のもくもく:mokumokubot: です！\n<@#{data.user}>もくもく頑張ってね！:mokumokubot::clap:"
      else
        client.message channel: data['channel'], text: "<@#{data.user}>\nすごい！もくもく頑張ってね！:clap:"
      end
    end

    if data.text&.match(/もくもくカウントは/) && data.user == ENV['MOKUMOKU_ADMIN']
      mokumoku_count = data.text.match(/\d+/)[0].to_i
      s3_mokumoku_count_save(mokumoku_count)
    end
    if data.text&.match(/^バルス$/)
      client.message channel: data['channel'], text: 'もくもくカウントが壊れて0になりました。:cry:'
      mokumoku_count = 0
    end
  end
end
ura_setting(client)
children_channel(client)

# Bot start
client.start!
