require 'wwmd/class_extensions/mixins_string_encoding'
class String
  include WWMD::Encoding

  @@he = HTMLEntities.new

  # base 64 decode
  def b64d
    self.unpack("m").first
  end

  # base 64 encode
  def b64e
    [self].pack("m").gsub("\n","")
  end

  # URI.escape using defaults or passed regexp
  def escape(reg=nil,unicodify=false)
    if reg.nil?
      ret = URI.escape(self)
    elsif reg.kind_of?(Symbol)
      case reg
        when :none; return self
        when :default; ret =  URI.escape(self)
        else; ret =  URI.escape(self,WWMD::ESCAPE[reg])
      end
    else
      ret = URI.escape(self,reg)
    end
    if unicodify
      ret.gsub!(/%/,"%u00")
    end
    return ret
  end

  # URI.escape
  def escape_url(reg=WWMD::ESCAPE[:url])#:nodoc:
    self.escape(reg)
  end

  def escape_xss(reg=WWMD::ESCAPE[:xss])#:nodoc:
    self.escape(reg)
  end

  def escape_default(reg=WWMD::ESCAPE[:default])
    self.escape(reg)
  end
  # URI.escape all characters in string
  def escape_all#:nodoc:
    self.escape(/.*/)
  end

  # URI.unescape
  def unescape
    URI.unescape(self)
  end

  # html entity encode string
  #  sym = :basic :named :decimal :hexadecimal
  def eencode(sym=nil)
    sym = :named if sym.nil?
    @@he.encode(self,sym)
  end

  # decode html entities in string
  def edecode
    return @@he.decode(self)
  end

  # quoted printable
  def to_qp
    [self].pack("M")
  end

  def from_qp
    self.unpack("M").first
  end

end
