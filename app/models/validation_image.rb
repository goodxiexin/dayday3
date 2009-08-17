require 'rubygems'
require 'RMagick'

class ValidationImage
  include Magick
  attr_reader :text, :image
  Jiggle = 15
  Wobble = 15

  def initialize(len=4)
    chars = ('a'..'z').to_a  + ('0'..'9').to_a
    text_array=[]
    1.upto(len) {text_array << chars[rand(chars.length)]}
    granite = Magick::ImageList.new('xc:#EDF7E7')
    canvas = Magick::ImageList.new
    canvas.new_image(32*len, 50, Magick::TextureFill.new(granite))
    gc = Magick::Draw.new
    gc.font_family = 'times'
    gc.pointsize = 40
    cur = 10

    text_array.each{|c|
      rand(10) > 5 ? rot=rand(Wobble):rot= -rand(Wobble)
      rand(10) > 5 ? weight = NormalWeight : weight = BoldWeight
      gc.annotate(canvas,0,0,cur,30+rand(Jiggle),c){
        self.rotation=rot
        self.font_weight = weight
        self.fill = 'green'
      }
      cur += 30
    }
    @text = text_array.to_s
    @image = canvas.to_blob{
      self.format="GIF"
    }
  end
end
