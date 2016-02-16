module ApplicationHelper
  def md(text)
    unless @markdown
      @markdown = Redcarpet::Markdown.new(
        Redcarpet::Render::HTML.new(
          filter_html: true,
          hard_wrap: true,
        ),
        tables: true,
        fenced_code_blocks: true
      )
    end

    @markdown.render(text).html_safe
  end
end
