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
  
  def initialize(source_code=nil)
    @source_code = source_code ? source_code.to_s : TEMPLATE_HEADER + TEMPLATE_BODY
    @status = 'Edit Glimmer code above and run it directly'
  end
  
  def load(filename)
    File.open(filename, 'r') do |file|
      self.source_code = file.readlines.join('')
    end
  end
  
  def save(filename=nil)
    return puts "Need a file dialog to set the filename" unless filename
    File.open(filename, 'w') do |file|
      file.write(self.source_code)
    end
  end
  
  def insert_header
    self.source_code = TEMPLATE_HEADER + @source_code
  end

  # Run each line of ruby code from the command line using the -e switch
  def run
    change_status "Running source code..." do
      Thread.new(@source_code) do |source_code|
        source_in_one_line = source_code.split("\n").map do |line| 
          "-e \"#{line.gsub('"', '\"')}\""
        end.join(' ')
        `jruby #{source_in_one_line}`
      end
    end
  end
  
  def change_status(new_status)
    old_status = self.status
    self.status = new_status
    yield
    # TODO: reset status after (must be in same Thread ?)
    #self.status = old_status
  end
  
TEMPLATE_HEADER = <<EOS
require 'rubygems'
require 'swt'

EOS
  
TEMPLATE_BODY = <<EOS
class HelloWorld
  extend Glimmer

  shell {
    text "Hello World"    
  }.open
end   
EOS

end