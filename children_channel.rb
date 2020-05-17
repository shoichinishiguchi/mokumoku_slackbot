# frozen_string_literal: true

#  ここにメソッドを書けば、新しい設定ができます。
CHANNEL_CHILDLEN = [
  'C013RHP1PRB', # 実験用子チャンネル
  ''
].freeze

GIJUTU_PARENT = 'C012J618JN7'

def children_channel(client)
  client.on :message do |data|
    if CHANNEL_CHILDLEN.include?(data.channel)
      client.message channel: GIJUTU_PARENT, text: data.text
    end
  end
end
