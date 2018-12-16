#!/usr/bin/env ruby
# coding: utf-8
#如果报readline找不到，需要
#1，yum -y install readline readline-devel
#2，重新编译ruby 加上--with-ext  ./configure --prefix=/opt/ruby_2.2.3/ --with-ext

########################################################
#   加载库
########################################################

require "readline"
require "gdbm"  #支持中文
require 'socket'



class C_控制台
	
	def initialize(外部绑定=TOPLEVEL_BINDING)
		@命令段落=""
		@命令行提示符="->"
		#
		# 配置参数
		#
		@代码回显=false
		@执行回显=true
		@外部绑定=外部绑定
		@内部绑定=binding
		刷新命令补齐
	end

	def 开启
		while 读取行 = Readline.readline(@命令行提示符, true)
			#退出	
			exit if 读取行=='exit' || 读取行=='quit' ;
			if ! 读取行.include? ";"
				@命令段落 << 读取行 + "\n"
				@命令行提示符="  "
			else
				@命令段落 << 读取行
				puts "#{@命令段落}" if @代码回显
				if @命令段落.include?('配置') or @命令段落.include?('切换代码回显') or @命令段落.include?('切换执行回显') or @命令段落.include?('帮助')
					begin
						eval @命令段落 , @内部绑定
					rescue Exception => e
						puts e
					end
				else
					begin
						eval @命令段落 , @外部绑定
					rescue Exception => e
						puts e
					end
					
				end
				@命令段落=''
				@命令行提示符="->"
				刷新命令补齐
			end
		end		
	end

	def 配置
		puts "@代码回显 #{@代码回显}"
		puts "@执行回显 #{@执行回显}"
	end
	def 切换代码回显
		@代码回显 = ! @代码回显
	end

	def 切换执行回显
		@执行回显 = ! @执行回显
	end

	def 帮助
		puts "命令："
		puts "	    配置;   #显示配置参数"
		puts "      帮助;   #显示帮助内容"
		puts "      切换代码回显; #切换代码的回显设置"
		puts "      切换执行回显; #切换执行的回显设置"
	end

	def 刷新命令补齐
		补齐列表 =  eval "local_variables",TOPLEVEL_BINDING
		tmp=[]
		补齐列表.each {|x|
			tmp += eval "#{x}.methods",TOPLEVEL_BINDING

		}
		补齐列表 += tmp
		补齐过程 = proc { |s| 补齐列表.grep(/^#{Regexp.escape(s)}/) }
		Readline.completion_proc = 补齐过程
		#
		# completion_append_character 补齐之后，后面自动补上的字符
		# completer_word_break_characters ，比如 a.cc ，这里设置的是以.为起始，cc开头的
		Readline.completion_append_character = ""
		Readline.completer_word_break_characters = ' ."\''  #这里可以设置多个起始的判断字符，让操作支持的范围更广
	end
end
=begin
a=100
bb=100
ccc=100
dddd=1000
C_控制台.new().开启 
=end



