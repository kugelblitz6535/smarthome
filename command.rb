def ir(device, action)
  cmd = "irsend SEND_ONCE #{device} #{action}"
  system(cmd)
end

name, payload = ARGV[0].split(',')

case name
when '電気', 'ライト'
  ir('light',
     case payload
     when 'true'
       'max'
     when 'false'
       'off'
     when '-25'
       'down'
     when '25'
       'up'
     end)
when 'テレビ'
  case payload
  when 'true'
    system('sudo etherwake 00:71:CC:4E:25:A8')
    return
  when '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'
    code = codes["Num#{payload}"]
  when '13'
    code = codes['OneTouchView']
  when '21', '22', '23', '24'
    hdmi = payload.to_i - 20
    system(%(curl -d {"method":"setPlayContent","params":[{"uri":"extInput:hdmi?port=#{hdmi}"}],"id":10,"version":"1.0"}" -b #{File.expand_path('cookie.txt', __dir__)} http://#{ip}/sony/avContent))
  when '25'
    code = codes['VolumeUp']
  when '26'
    code = codes['VolumeDown']
  when 'false'
    code = codes['PowerOff']
  end

  command = %(curl -X POST -d '<?xml version="1.0" encoding="utf-8"?><s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body><u:X_SendIRCC xmlns:u="urn:schemas-sony-com:service:IRCC:1"><IRCCCode>#{code}</IRCCCode></u:X_SendIRCC></s:Body></s:Envelope>' -b #{File.expand_path('cookie.txt', __dir__)} http://#{ip}/sony/IRCC)
  system(command)

when '掃除機'
  ir('ilife',
     case payload
     when 'true'
       'start'
     when '1'
       'home'
     end)
when 'レコーダー'
  ir('recorder',
     case payload
     when 'true'
       'home'
     when '1'
       'option'
     when '2'
       'open'
     end)
end
