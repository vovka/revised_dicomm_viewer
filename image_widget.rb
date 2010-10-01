# Widget for displaying the image data.
# If you want mouse events for interacting with the image, they can be put in this class.

class ImageWidget < Qt::Widget

  # Initialize the widget.
  def initialize(parent=nil)
    @parent = parent
    super(parent)
    setMinimumSize(512, 512)
    @pixmap = Qt::Pixmap.new
  end

  # This method paints the image to the screen.
  def paintEvent(event)
    painter = Qt::Painter.new
    painter.begin(self)
    painter.drawPixmap(0, 0, @pixmap)
    painter.end
  end

  # Converts the RMagick object to a Qt pixmap.
  def load_pixmap
    blob = @parent.image.to_blob {
      self.format = "PGM"
      self.depth = 8
    }
    @pixmap.loadFromData(Qt::ByteArray.fromRawData(blob, blob.size))
    update
  end

end
