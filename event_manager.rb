require 'csv'
require 'sunlight/congress'
template_letter = File.read "form_letter.html"

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  if zipcode.nil?
    zipcode = "00000"
    elsif zipcode.length < 5 
    zipcode = zipcode.rjust(5, "0")
  elsif zipcode.length > 5 
    zipcode[0..4]
  else 
    zipcode 
  end 
end
      


def legislators_by_zipcode(zipcode)
  
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
  
  legislator_names = legislators.collect do |legislator|
    "#{legislator.first_name} #{legislator.last_name}"
  end
  
  legislator_names.join(" | ")
end

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol 

contents.each do |row|
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  
  legislators = legislators_by_zipcode(zipcode)
  
   personal_letter = template_letter.gsub('first_name',name)
  personal_letter.gsub!('legislators',legislators)
  
  puts "#{name} | #{zipcode} | #{legislators}"
  
end 

