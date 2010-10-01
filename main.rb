# Main file of DICOM viewer. Execute this file to start the program.

# Load necessary libraries:
require 'rubygems'
require 'Qt4'
require 'RMagick'
#require 'dicom'

# Load our QtRuby main window class:
require 'main_window'

# Launch the application:
app = Qt::Application.new(ARGV)
win = MainWindow.new
win.show
app.exec
