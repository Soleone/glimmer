# Default settings for all widgets (style and initializers).
# 
# The plan is to make these overrideable with a yaml/ruby file for each project.
# Currently you can override defaults using style=() and initializer=()
module Default
  include_package "org.eclipse.swt"

  @@widget_styles = {
    "text" => SWT::BORDER,
    "table" => SWT::BORDER,
    "spinner" => SWT::BORDER,
    "list" => SWT::BORDER | SWT::V_SCROLL,
    "button" => SWT::PUSH,
  }
  
  @@initializers = {
    "composite" => Proc.new {|composite| composite.setLayout(GridLayout.new) },
    "table" => Proc.new do |table| 
      table.setHeaderVisible(true)
      table.setLinesVisible(true)
    end,
    "table_column" => Proc.new { |table_column| table_column.setWidth(80) },
    "group" => Proc.new {|group| group.setLayout(GridLayout.new) },
  }
  
  # class methods
  class << self
    def style(widget)
      @@widget_styles[widget] || SWT::NONE
    end
    
    def style=(widget, value)
      @@widget_styles[widget] = value
    end
    
    def initializer(name)
      initializer = @@initializers[name] || lambda { || }
    end

    def initializer=(name, &block)
      @@initializers[name] = block
    end
    
    # Initialize the widget 
    def initialize!(name, widget)
      initializer(name).call(widget)
    end
  end
end