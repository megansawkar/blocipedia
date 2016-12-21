require 'redcarpet'

module ApplicationHelper
  class CodeRayify < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language).div
    end
  end

  def markdown(text)
    coderayified = CodeRayify.new(filter_html: true,
                                  hard_wrap: true)
    options = {
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      disabled_indented_code_blocks: true,
      autolink: true,
      strikethrough: true,
      underline: true,
      highlight: true,
      quote: true,
    }
    markdown_to_html = Redcarpet::Markdown.new(coderayified, options)
    markdown_to_html.render(text).safe_join
  end
end
