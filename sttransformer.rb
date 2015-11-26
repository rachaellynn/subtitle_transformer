#subtitle exercise for Mohan 7/28/15
# this takes two subtitle files for a single movie that both start at times and writes a new file with the time shifted forward appropriately. 

#this prints out the file => this works
#txt = open('subtitles2.txt')
#print txt.read
#txt.close

#another way to print out a file, line by line => this also works
# File.open('subtitles2.txt', 'r+') do |f1|  
#   while line = f1.gets  
#     puts "this is f1: " + f1.to_s 
#     puts "this is f1.gets: " + line  
#   end  
# end  


#read text line by line with a number by each line =>
#I discovered that lines don't have particular numbers -- oh well!
# f = File.open('subtitles2.txt','r+')
# n = 1
# f.each do |line| 
# 	puts n.to_s + ":" + line
# 	n += 1
# end

#find lines with the word "good" in the text
# f = File.open('subtitles2.txt','r+')
# f.each do |line| 
# 	if (line =~ /Good(.*)/)
# 	puts line
# 	end
# end

#time to add
addtime = 1 * 3600 + 11 * 60 + 16.437

#find lines with dates in the text
f = File.open('subtitles2.txt','r+')
f.each do |line| 
	if (line =~ /\d{2}:\d{2}:(.*)/)
		#replace the comma with a decimal
		line_num = line.gsub(",",".")	
		#pull the elements out of each date line
		newline = /(?<hour>\d{2}):(?<minute>\d{2}):(?<second>\d{2}.\d{3})\W{5}(?<hour2>\d{2}):(?<min2>\d{2}):(?<sec2>\d{2}.\d{3})/.match(line_num)
		#convert hours to seconds
		hour = newline['hour'].to_f * 3600
		hour2 = newline['hour2'].to_f * 3600
		#convert minutes to seconds
		minute = newline['minute'].to_f * 60
		min2 = newline['min2'].to_f * 60
		# create a "seconds" variable
		second = newline['second'].to_f 
		sec2 = newline['sec2'].to_f
		# addup all the seconds
		time = hour + minute + second
		time2 = hour2 + min2 + sec2
		# add the time to the existing time (in seconds)
		time_new = time + addtime
		time_new2 = time2 + addtime
		# convert second back to our original format 
		time_new = Time.at(time_new).utc.strftime("%H:%M:%S,%L")
		time_new2 = Time.at(time_new2).utc.strftime("%H:%M:%S,%L")
		# a) get the two old times so I can replace them
		timeout = /(?<time1>\d{2}:\d{2}:\d{2},\d{3})\W{5}(?<time2>\d{2}:\d{2}:\d{2},\d{3})/.match(line)
		# create variables with the substitution
		new_contents = line.gsub(timeout['time1'],time_new).gsub(timeout['time2'],time_new2)
		#puts new_contents
		#write these to the file
	elsif (line =~ /\d+/)
		#puts "found a single digit line"
		#grab the number from the string
		number = /(?<ournumber>\d+)/.match(line)
		#puts number
		new_contents = number['ournumber'].to_i + 638
		new_contents = new_contents.to_s + "\n"
		#puts "got a new number:" + new_contents
	else
		new_contents = line
	end
	#write contents to a new file
	File.open('subtitles_new.txt','a') { |file| file.write new_contents}
	#merge subtitles1.txt and subtitles_new.txt into one file and give it a .srt extension
end

#here are the unix commands for concatenant and renaming these files
# cat subtitles_1.txt subtitles_new.txt > complete_subtitles.txt
# mv complete_subtitles.txt complete_subtitles.srt

#split a numbered line into part
# => it appears that I'm not able to split these ruby time strings, even when I use .to_s -- strange!!!

#THIS IS DATA FOR INSIDE MY LOOP
# line = '00:00:55,324 --> 00:00:58,054'
# #newline = line.split(/(\d{2}):(\d{2}):(\d{2})\,(\d{3})/)
# newline = /(?<hour>\d{2}):(?<minute>\d{2}):(?<second>\d{2})\,(?<frac>\d{3})\W{5}(?<hour2>\d{2}):(?<min2>\d{2}):(?<sec2>\d{2}),(?<frac2>\d{3})/.match(line)
# hour = 360 * newline['hour'].to_i
# minute = 60 * newline['minute'].to_i
# second = newline['second'].to_i
# time = hour + minute + second
# #this line has a problem
# time = (time + "." + frac).to_f

# hour = 360 * newline['hour2'].to_i
# minute = 60 * newline['minute2'].to_i
# second = newline['second2'].to_i
# time = hour + minute + second
# time2 = time + ", " + frac2

# puts time1
# puts time2

#HERE'S WHERE I WORKED OUT MOST OF THE CODE
# line = '00:00:55,324 --> 00:00:58,054'
# #replace the comma with a decimal
# line_num = line.gsub(",",".")
# #pull the elements out of each date line
# newline = /(?<hour>\d{2}):(?<minute>\d{2}):(?<second>\d{2}.\d{3})\W{5}(?<hour2>\d{2}):(?<min2>\d{2}):(?<sec2>\d{2}.\d{3})/.match(line_num)
# #convert hours to seconds
# hour = newline['hour'].to_f * 3600
# hour2 = newline['hour2'].to_f * 3600
# #convert minutes to seconds
# minute = newline['minute'].to_f * 60
# min2 = newline['min2'].to_f * 60
# # create a "seconds" variable
# second = newline['second'].to_f 
# sec2 = newline['sec2'].to_f
# # addup all the seconds
# time = hour + minute + second
# time2 = hour2 + min2 + sec2
# # add the time to the existing time (in seconds)
# time_new = time + addtime
# time_new2 = time2 + addtime
# # convert second back to our original format 
# time_new = Time.at(time_new).utc.strftime("%H:%M:%S,%L")
# time_new2 = Time.at(time_new2).utc.strftime("%H:%M:%S,%L")
# #replace one item with the new one
# # a) get the two old times so I can replace them
# timeout = /(?<time1>\d{2}:\d{2}:\d{2},\d{3})\W{5}(?<time2>\d{2}:\d{2}:\d{2},\d{3})/.match(line)
# new_contents = line.gsub(timeout['time1'],time_new)
# new_contents2 = line.gsub(timeout['time2'],time_new2)
# puts new_contents
# puts new_contents2
#example replace
# new_contents = text.gsub(/search_regexp/, "replacement string")
# File.open(file_name, "w") {|file| file.puts new_contents }



#Time.at(total_seconds).utc.strftime("%H:%M:%S")

#THIS CODE DOES WORK FOR TIME
# line = '10:00:55,324'
# line = line.gsub(",",".")
# newline = /(?<hour>\d{2}):(?<minute>\d{2}):(?<second>\d{2}.\d{3})/.match(line)
# hour = newline['hour'].to_f * 60 * 60
# minute = newline['minute'].to_f * 60
# second = newline['second'].to_f 
# time = hour + minute + second
# puts time

# #convert seconds back to time, including miliseconds
# time = Time.at(time).utc.strftime("%H:%M:%S.%L")
# puts time


# puts newline
#puts hour
# puts "Hour: #{newline['hour']}"

# puts Time.now.hour
# puts Time.now.min
# puts Time.now.sec


#Course Code: #{parts['Code']}


#pull the first date out of the line
# f = File.open('subtitles2.txt','r+')
# f.each do |line| 
# 	#puts line #here the lines are still all together
# 	newline = line.split
# 	puts newline
# 	#if (line =~ /\d{2}:\d{2}:(.*)/)
# 	#date = line.split
# 	#puts date
# 	#end
# end




