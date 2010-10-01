# Main window of the application (defining GUI layout and actions).

require 'tree_model'
require 'image_widget'

class MainWindow < Qt::MainWindow
  include Magick

  slots 'open_file()', 'about()'
  attr_reader :image

  def initialize(parent=nil)
    super(parent)
    setupMenus
    setupWidgets
    setSizePolicy(Qt::SizePolicy.new(Qt::SizePolicy::Fixed, Qt::SizePolicy::Fixed))
    setWindowTitle(tr("DICOM VIEWER"))
  end

  # Displays an information text box:
  def about
    Qt::MessageBox.information(self, tr("About"), tr("This is a simple DICOM Viewer made with QtRuby."))
  end

  # Reads the DICOM file, loads image as a RMagick object and transfers information to the tree model and image widget.
  def load_dicom(file)
    #obj = DICOM::DObject.new(file, :verbose => false)
    #if obj.read_success
      # Load image as RMagick object:
      #@image = obj.get_image_magick(:rescale => true)
      @image = ImageList.new(file)
      puts "@image.class: #{@image.class}"
      unless @image # Load an empty image object.
        @image = Magick::ImageList.new
        @image.new_image(0,0){ self.background_color = "black" }
      end
      # Add information from the DICOM object to the the tree model and update widgets:
      #model = TreeModel.new(obj)
      #@treeView.model = model
      @imageWidget.load_pixmap
    #else # Failed:
    #  Qt::MessageBox.warning(self, tr("Open file"), tr("Error: Selected file is not recognized as a DICOM file."))
    #end
  end

  # Launching open file dialogue.
  def open_file
    fileName = Qt::FileDialog.getOpenFileName(self, tr("Open file"), "", "DICOM-files (*)")
    load_dicom(fileName) unless fileName.nil?
  end

  # Setting up menu items.
  def setupMenus
    # Menus:
    fileMenu = menuBar().addMenu(tr("&File"))
    helpMenu = menuBar().addMenu(tr("&Help"))
    # Menu items:
    openFile = fileMenu.addAction(tr("&Open..."))
    openFile.shortcut = Qt::KeySequence.new(tr("Ctrl+O"))
    exitAction = fileMenu.addAction(tr("E&xit"))
    exitAction.shortcut = Qt::KeySequence.new(tr("Ctrl+X"))
    aboutView = helpMenu.addAction(tr("&About"))
    aboutView.shortcut = Qt::KeySequence.new(tr("Ctrl+A"))
    # Menu item actions:
    connect(openFile, SIGNAL('triggered()'), self, SLOT('open_file()'))
    connect(exitAction, SIGNAL('triggered()'), $qApp, SLOT('quit()'))
    connect(aboutView, SIGNAL('triggered()'), self, SLOT('about()'))
  end

  # Setting up the widgets in the main window.
  def setupWidgets
    # Create a frame which in which widgets will be ordered horisontally:
    frame = Qt::Frame.new
    frameLayout = Qt::HBoxLayout.new(frame)
    @imageWidget = ImageWidget.new(self)
    @treeView = Qt::TreeView.new
    # Add the two widgets (tree view and image) to the frame:
    frameLayout.addWidget(@treeView)
    frameLayout.addWidget(@imageWidget)
    setCentralWidget(frame)
  end

end
