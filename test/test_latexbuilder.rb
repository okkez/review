require 'test_helper'
require 'review/compiler'
require 'review/book'
require 'review/latexbuilder'

class LATEXBuidlerTest < Test::Unit::TestCase
  include ReVIEW

  def setup
    @builder = LATEXBuilder.new()
    @param = {
      "secnolevel" => 2,    # for IDGXMLBuilder, EPUBBuilder
      "inencoding" => "UTF-8",
      "outencoding" => "UTF-8",
      "subdirmode" => nil,
      "stylesheet" => nil,  # for EPUBBuilder
    }
    ReVIEW.book.param = @param
    compiler = ReVIEW::Compiler.new(@builder)
    chapter = Chapter.new(nil, 1, '-', nil, StringIO.new)
    location = Location.new(nil, nil)
    @builder.bind(compiler, chapter, location)
  end

  def test_headline_level1
    @builder.headline(1,"test","this is test.")
    assert_equal %Q|\\chapter{this is test.}\n|, @builder.result
  end

  def test_headline_level1_without_secno
    @param["secnolevel"] = 0
    @builder.headline(1,"test","this is test.")
    assert_equal %Q|\\chapter*{this is test.}\n|, @builder.result
  end

  def test_headline_level2
    @builder.headline(2,"test","this is test.")
    assert_equal %Q|\\section{this is test.}\n|, @builder.result
  end

  def test_headline_level3
    @builder.headline(3,"test","this is test.")
    assert_equal %Q|\\subsection*{this is test.}\n|, @builder.result
  end


  def test_headline_level3_with_secno
    @param["secnolevel"] = 3
    @builder.headline(3,"test","this is test.")
    assert_equal %Q|\\subsection{this is test.}\n|, @builder.result
  end

  def test_label
    @builder.label("label_test")
    assert_equal %Q|\\label{label_test}\n|, @builder.result
  end

  def test_href
    ret = @builder.compile_href("http://github.com", "GitHub")
    assert_equal %Q|\\href{http://github.com}{GitHub}|, ret
  end

  def test_href_without_label
    ret = @builder.compile_href("http://github.com",nil)
    assert_equal %Q|\\href{http://github.com}{http://github.com}|, ret
  end

  def test_href_with_underscore
    ret = @builder.compile_href("http://example.com/aaa/bbb", "AAA_BBB")
    assert_equal %Q|\\href{http://example.com/aaa/bbb}{AAA\\textunderscore{}BBB}|, ret
  end

  def test_inline_br
    ret = @builder.inline_br("")
    assert_equal %Q|\\\\\n|, ret
  end

  def test_inline_br_with_other_strings
    ret = @builder.compile_inline("abc@<br>{}def")
    assert_equal %Q|abc\\\\\ndef|, ret
  end

  def test_inline_u
    ret = @builder.compile_inline("abc@<u>{def}ghi")
    assert_equal %Q|abc\\Underline{def}ghi|, ret
  end

  def test_inline_i
    ret = @builder.compile_inline("abc@<i>{def}ghi")
    assert_equal %Q|abc\\textit{def}ghi|, ret
  end

  def test_inline_dtp
    ret = @builder.compile_inline("abc@<dtp>{def}ghi")
    assert_equal %Q|abcghi|, ret
  end

  def test_inline_code
    ret = @builder.compile_inline("abc@<code>{def}ghi")
    assert_equal %Q|abc\\texttt{def}ghi|, ret
  end

  def test_inline_raw
    ret = @builder.compile_inline("@<raw>{@<tt>{inline!$%\\}}")
    assert_equal %Q|@\\textless{}tt\\textgreater{}\\{inline!\\textdollar{}\\%\\}|, ret
  end

  def test_inline_sup
    ret = @builder.compile_inline("abc@<sup>{def}")
    assert_equal %Q|abc\\textsuperscript{def}|, ret
  end

  def test_inline_sub
    ret = @builder.compile_inline("abc@<sub>{def}")
    assert_equal %Q|abc\\textsubscript{def}|, ret
  end

  def test_inline_b
    ret = @builder.compile_inline("abc@<b>{def}")
    assert_equal %Q|abc\\textbf{def}|, ret
  end

  def test_inline_em
    ret = @builder.compile_inline("abc@<em>{def}")
    assert_equal %Q|abc\\textbf{def}|, ret
  end

  def test_inline_strong
    ret = @builder.compile_inline("abc@<strong>{def}")
    assert_equal %Q|abc\\textbf{def}|, ret
  end

  def test_inline_u
    ret = @builder.compile_inline("abc@<u>{def}ghi")
    assert_equal %Q|abc\\Underline{def}ghi|, ret
  end

end
