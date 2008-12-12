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
    @editor_presenter = EditorPresenter.new(self)
    build
    launch
  end

  def build
    @shell = shell {
      text "Glimmer Editor"
			layout GridLayout.new(1, true)

  		tab_folder {
			  layout_data GridData.new(GridData::FILL_BOTH)
    		layout FillLayout.new

  			tab_item {
  				layout GridLayout.new(1, true)
  				text "Editor"

          text(multi | border| wrap| v_scroll) {
  					layout_data GridData.new(GridData::FILL_BOTH)
            text bind(@editor_presenter, :source_code)
          }

          composite {
            layout FillLayout.new
            
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
        }
        tab_item {
				  text "Settings"
				  layout GridLayout.new(2, true)
				  label { text "There are currenlty no settings available."}
				}
			}
      composite {
        layout GridLayout.new(1, true)
        label() {
          layout_data GridData.new(GridData::FILL_VERTICAL)
          text bind(@editor_presenter, :status)
        }
      }
    }
  end  
  
  def launch
    @shell.open
    @editor_presenter.change_status "You can edit glimmer files here and run them directly."
  end
  
  def display
    @shell.display    
  end
end

GlimmerEditor.new
