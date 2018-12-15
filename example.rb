#!/usr/bin/env ruby
begin
	puts "你可以在控制台中，查看和修改a变量的值，你会在日志中，查看到修改的效果"
	a=1
	Thread.new {
		f=File.open "tmp.txt","w+"
		f.sync = true
		loop {
		sleep 1
		f.write "#{a}\n"
		}
	}
	require "wxl_console"

	C_控制台.new.开启
rescue Interrupt
	puts "\n强制中断"
end
