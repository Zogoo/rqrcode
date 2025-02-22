require "spec_helper"
require "rqrcode/data"

describe "Export::SVG" do
  it "must respond_to svg" do
    expect(RQRCode::QRCode.new("qrcode")).to respond_to(:as_svg)
  end

  it "must export to svg" do
    expect(RQRCode::QRCode.new("qrcode").as_svg).to eq(AS_SVG)
  end

  describe "options" do
    it "has standalone option true by default" do
      doc = RQRCode::QRCode.new("qrcode").as_svg
      # For now we do very naive pattern matching. The alternative is to
      # include a librariry for parsing XML, like nokogiri. That is a big
      # change for such a small test, though.
      expect(doc).to match(%r{<\?xml.*standalone="yes"})
      expect(doc).to match(%r{<svg.*>})
      expect(doc).to match(%r{</svg>})
    end

    it "omits surrounding XML when `standalone` is `false`" do
      doc = RQRCode::QRCode.new("qrcode").as_svg(standalone: false)
      # For now we do very naive pattern matching. The alternative is to
      # include a librariry for parsing XML, like nokogiri. That is a big
      # change for such a small test, though.
      expect(doc).not_to match(%r{<\?xml.*standalone="yes"})
      expect(doc).not_to match(%r{<svg.*>})
      expect(doc).not_to match(%r{</svg>})
    end

    it 'renders viewBox and not height/width when `viewbox` is `true`' do
      doc = RQRCode::QRCode.new('qrcode').as_svg(viewbox: true)
      # For now we do very naive pattern matching. The alternative is to
      # include a librariry for parsing XML, like nokogiri. That is a big
      # change for such a small test, though.
      expect(doc).not_to match(%r{<\?xml.*height="\d+".*width=})
      expect(doc).to match(%r{<svg.*viewBox="(\d+\s?){4}"})
    end

    it 'renders id when `svg_attributes[:id]` is provided ' do
      doc = RQRCode::QRCode.new('qrcode').as_svg(svg_attributes: {id: '123'})
      # For now we do very naive pattern matching. The alternative is to
      # include a librariry for parsing XML, like nokogiri. That is a big
      # change for such a small test, though.
      expect(doc).to match(%r{<svg.*\sid="123".*>})
    end

    it 'renders class when `svg_attributes[:class]` is provided ' do
      doc = RQRCode::QRCode.new('qrcode').as_svg(svg_attributes: {class: 'foo'})
      # For now we do very naive pattern matching. The alternative is to
      # include a librariry for parsing XML, like nokogiri. That is a big
      # change for such a small test, though.
      expect(doc).to match(%r{<svg.*\sclass="foo".*>})
    end

  end
end
