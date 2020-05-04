
def ura_setting(client)
  client.on :message do |data|
    if data.text&.match(/裏設定ファイル/)
      client.message channel: data['channel'], text: "ようこそ"
    end
  end
end
