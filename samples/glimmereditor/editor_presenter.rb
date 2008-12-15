################################################################################
# Copyright (c) 2008 Annas Al Maleh.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
#
# Contributors:
#    Annas Al Maleh - initial API and implementation
#    Dennis Theisen - glimmer sample editor
################################################################################ 

class EditorPresenter
  attr_accessor :source_code, :status
  
  def initialize(gui, source_code=nil)
    @gui = gui
    @source_code = source_code ? source_code.to_s : TEMPLATE_HEADER + TEMPLATE_BODY
    @status = ' '*100 # Because label is truncated to initial width, even when text is updated
  end
  
  def load(filename)
    File.open(filename, 'r') do |file|
      self.source_code = file.readlines.join('')
    end
    change_status "Loaded the login sample file"
  end
  
  def save(filename=nil)
    return change_status "Sorry, saving is currently not supported!" unless filename
    File.open(filename, 'w') do |file|
      file.write(self.source_code)
    end
  end
  
  def insert_header
    change_status "Inserted basic requirements for using Glimmer."
    self.source_code = TEMPLATE_HEADER + @source_code
  end

  # Run each line of ruby code from the command line using the -e switch
  def run
    change_status "Running source code...", false do
      Thread.new do
        source_in_one_line = @source_code.split("\n").map do |line| 
          "-e \"#{line.gsub('"', '\"')}\""
        end.join(' ')
        system("jruby #{source_in_one_line}")
        change_status '', false
      end
    end
  end
  
  def change_status(new_status, reset=true)
    Thread.new do
      @gui.display.async_exec { self.status = new_status }
      yield if block_given?
      if reset
        sleep 5
        @gui.display.async_exec { self.status = '' }
      end
    end
  end
  
TEMPLATE_HEADER = <<EOS
require 'rubygems'
require 'swt'

EOS
  
TEMPLATE_BODY = <<EOS
class HelloWorld
\textend Glimmer

\tshell {
\t\ttext "Hello World"
\t}.open
end   
EOS

end