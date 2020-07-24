# frozen_string_literal: true

#  ここにメソッドを書けば、新しい設定ができます。
def ura_setting(client)
  client.on :message do |data|
    if data.text&.match(/裏設定ファイル/)
      client.message channel: data['channel'], text: 'Welcome to underground'
    end
  end
end
