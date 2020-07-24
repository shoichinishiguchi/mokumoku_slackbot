# frozen_string_literal: true

#  ここにメソッドを書けば、新しい設定ができます。
def ura_setting(client)
  client.on :message do |data|
    if data.text&.match(/裏設定ファイル/)
      client.message channel: data['channel'], text: 'Welcome to underground'
    end
  end
end

def mokumoku_count_up_and_save(mokumoku_count)
  count = mokumoku_count

  File.open 'mokumoku_count.txt', File::RDONLY do |f|
    count = f.read.to_i + 1
  end

  File.open 'mokumoku_count.txt', File::TRUNC | File::RDWR do |f|
    f.print count.to_s
  end
  count
end
