require "hair_border/version"
require "compass"
require 'chunky_png'
require 'base64'

base_directory = File.join(File.dirname(__FILE__))
Compass::Frameworks.register('pixie_sass', :path => base_directory)

module HairBorder

end

module Sass::Script::Functions
  def hair_border(top, left, bottom, right, width=6)
        assert_type top, :Color
        assert_type left, :Color
        assert_type bottom, :Color
        assert_type right, :Color

        top = top
        left = left || top
        bottom = bottom || top
        right = right || left
        canvas = ChunkyPNG::Canvas.new(width, width)
        canvas.line(0,          0,          (width-1),  0,          ChunkyPNG::Color(top.red, top.green, top.blue))
        canvas.line((width-1),  0,          (width-1),  (width-1),  ChunkyPNG::Color(left.red, left.green, left.blue))
        canvas.line((width-1),  (width-1),  0,          (width-1),  ChunkyPNG::Color(bottom.red, bottom.green, bottom.blue))
        canvas.line(0,          (width-1),  0,          0,          ChunkyPNG::Color(right.red, right.green, right.blue))
        data = Base64.encode64(canvas.to_s).gsub("\n", '')
        Sass::Script::String.new "url('data:image/png;base64,#{data}')"
    end
    declare :hair_border, [:color, :color, :color, :color]
end