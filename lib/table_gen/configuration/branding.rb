class TableGen::Configuration::Branding
  def initialize(colors: nil, placeholder: nil)
    @colors = colors || {}
    @placeholder = placeholder

    @default_colors = {
      background: "#F6F6F7",
      100 => "206 231 248",
      400 => "57 158 229",
      500 => "8 134 222",
      600 => "6 107 178"
    }
    @default_placeholder = "/table_gen-assets/placeholder.svg"
  end

  def css_colors
    rgb_colors.map do |color, value|
      if color == :background
        "--color-application-#{color}: #{value};"
      else
        "--color-primary-#{color}: #{value};"
      end
    end.join("\n")
  end

  def placeholder
    @placeholder || @default_placeholder
  end

  private

  def colors
    @default_colors.merge(@colors) || @default_colors
  end

  def rgb_colors
    colors.map do |key, value|
      rgb_value = is_hex?(value) ? hex_to_rgb(value) : value
      [key, rgb_value]
    end.to_h
  end

  def is_hex?(value)
    value.include? "#"
  end

  def hex_to_rgb(value)
    value.to_s.match(/^#(..)(..)(..)$/).captures.map(&:hex).join(" ")
  end
end
