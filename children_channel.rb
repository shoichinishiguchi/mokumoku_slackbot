# frozen_string_literal: true

# 技術チャンネルをここに追加していけばいい
GIJUTU_CHILDLEN = [
  'C013RHP1PRB', # 実験用子チャンネル
  ''
].freeze

GIJUTU_PARENT = 'C012J618JN7'

def children_channel(client)
  client.on :message do |data|
    if GIJUTU_CHILDLEN.include?(data.channel)
      client.message channel: GIJUTU_PARENT, text: data.text
    end
  end
end
