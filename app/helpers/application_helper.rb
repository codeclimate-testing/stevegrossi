module ApplicationHelper

  def markdown(text)
    raw text.blank? ? '' : Maruku.new(text).to_html
  end

  def strip_markdown(text)
    strip_tags(markdown(text))
  end

  def body_classes
    controller_slug = controller_path.sub('/', ' ') # so 'meta/books' becomes 'meta books'
    [ controller_slug,
      "#{controller_slug}-#{action_name}",
      Date::DAYNAMES[Time.now.wday].downcase
    ].join ' '
  end

  def link_to_new(class_name)
    if current_user
      link_to "New #{class_name}", new_polymorphic_path([:meta, class_name]), class: 'link_to_new'
    end
  end

  def link_to_edit(thing)
    if current_user
      link_to 'e', polymorphic_path([:meta, thing], action: :edit), class: 'edit_link'
    end
  end

  def link_to_delete(thing)
    if current_user
      name = thing.class.name.titleize
      link_to "Delete this #{name}", polymorphic_path([:meta, thing]), confirm: "Are you sure you want to delete this #{name}? This cannot be undone.", method: :delete, class: 'delete_link'
    end
  end

  def link_to_previous(thing)
    if thing.previous
      str = content_tag :span, 'Previous: '
      str += link_to thing.previous.title, thing.previous
      return content_tag :p, str, class: :previous
    end
  end

  def link_to_next(thing)
    if thing.next
      str = content_tag :span, 'Next: '
      str += link_to thing.next.title, thing.next
      return content_tag :p, str, class: :next
    end
  end

  def nav_link_to(*args)
    options = args.extract_options!
    path = Rails.application.routes.recognize_path args[1]
    # make these links relative to root (not the current namespace)
    # so that they work on /meta pages
    path[:controller].insert 0, '/'
    if path[:controller] == 'static_pages'
      if current_page? path
        options[:class] = :current
      end
    elsif path[:controller] == params[:controller]
      options[:class] = :current
    end
    link_to args[0], path, options
  end

  def nice_url(url)
    url.gsub(/(^https?:\/\/(www.)?)|(\/$)/, '') if url
  end

  def link_from_url(url)
    link_to nice_url(url), url
  end

  def flash_errors(obj)
    if obj.errors.any?
      content_tag :div, class: 'flash error' do
        html = content_tag :h2, "#{pluralize(obj.errors.count, 'errors')}, n00b!"
        html += content_tag :ul do
          obj.errors.full_messages.each do |msg|
            concat content_tag :li, msg
          end
        end
      end
    end
  end

  def word_count(str)
    pluralize( str.gsub(/[^-a-zA-Z]/, ' ').split.size, 'word' )
  end

  def mark_string(string, term='')
    if term.blank?
      string
    else
      raw string.gsub(/#{Regexp.escape(term).gsub(/\\\s/, '|')}/i, '<mark>\0</mark>')
    end
  end

  def serp_excerpt(text, query)
    query = Regexp.escape(query).gsub(/[^\w\s]/, '')
    first_occurrence = query.split(' ').first
    mark_string(excerpt(strip_markdown(text), first_occurrence), query)
  end

  def comment_on_search_term(query)
    unless query.blank?
      case query.downcase
      when 'shit', 'fuck', 'cunt', 'cocksucker', 'motherfucker'
        content_tag(:p, content_tag(:em, 'You kiss your mother with that mouth?'))
      end
    end
  end

  def bubble_up(array, items)
    if items.blank?
      return array
    else
      (array - items).unshift(items).flatten
    end
  end
end
