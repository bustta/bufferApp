require "google_drive"

session = GoogleDrive.login("honju.tsai@gmail.com", "devgmail")

ws = session.spreadsheet_by_key("0AhRADkWEsF8xdEFtVUplWENCdGVSRjQ5NWxreVF0bHc").worksheets[0]

p index =  ws[1,1]

ws[1,1] = index.to_i + 1
ws.save()