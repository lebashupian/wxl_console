#!/usr/bin/env ruby
begin
 
	puts "你可以在控制台中，查看和修改变量aaaaaaaaaaa的值，你会在日志中，查看到修改的效果"
	puts "当变量特别长的时候，你可以尝试使用TAB来补齐"
	aaaaaaaaaaa=1
	Thread.new {
		f=File.open "tmp.txt","w+"
		f.sync = true
		loop {
		sleep 1
		f.write "#{aaaaaaaaaaa}\n"
		}
	}
	require "wxl_console"

	C_控制台.new.开启

rescue Interrupt
	`rm -f tmp.txt`
	puts "\n强制中断"
end
