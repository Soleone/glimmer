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

require File.dirname(__FILE__) + "/../../src/swt"
require File.dirname(__FILE__) + "/editor_presenter"

class GlimmerEditor
  include Glimmer
  
  include_package 'org.eclipse.swt'
  include_package 'org.eclipse.swt.widgets'
  include_package 'org.eclipse.swt.FileDialog'
  include_package 'org.eclipse.swt.layout'
  include_package 'org.eclipse.jface.viewers'
  
  def initialize
    @editor_presenter = EditorPresenter.new
    launch
  end
  
  def launch
    @shell = shell {
      layout RowLayout.new(SWT::VERTICAL)
      text "Glimmer Editor"
      
      composite {
        label { text ""}
      }
      composite {
        layout_data RowData.new 600, 400
        layout FillLayout.new
        text(SWT::MULTI | SWT::BORDER | SWT::WRAP | SWT::V_SCROLL) {
          text bind(@editor_presenter, :source_code)
        }
      }
      composite {
        layout GridLayout.new(6,false)
        
        button {
          text "&Run"
          on_widget_selected { @editor_presenter.run }
        }
        button {
          text "&Insert Header"
          on_widget_selected { @editor_presenter.insert_header }
        }
        button {
          text "&Load file"
          #TODO: Need a file dialog to set the filename dynamically
          on_widget_selected { @editor_presenter.load(File.dirname(__FILE__) + "/../login.rb") }
        }
        button {
          text "&Save file"
          #TODO: Need a file dialog to set the target filename
          on_widget_selected { @editor_presenter.save }
        }
      }
      composite {
        label {
          text bind(@editor_presenter, :status)
        }
      }
    }

    @shell.open
  end
end

GlimmerEditor.new
