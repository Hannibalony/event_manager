require 'csv'
require 'sunlight/congress'
require 'erb'

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.rjust(0,"5")[0..4]
end
    

def legislators_by_zipcode(zipcode)
  Sunlight::Congress::Legislator.by_zipcode(zipcode)
end


def save_thank_you_letters(id,form_letter)
  Dir.mkdir("output") unless Dir.exists?("output")

  filename = "output/thanks_#{id}.html"

  File.open(filename,'w') do |file|
    file.puts form_letter
  end
end



def clean_phone(phone)
  phone.rjust(1, "\n")[0..11]

end

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol 

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  phone = clean_phone(row[:homephone])
  legislators = legislators_by_zipcode(zipcode)
  
  form_letter = erb_template.result(binding)
  
  save_thank_you_letters(id,form_letter)

  puts "#{name} | #{zipcode} | #{legislators} | #{phone}"
  
end 

