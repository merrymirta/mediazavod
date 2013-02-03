module ApplicationHelper
  WEEK_DAYS = %w{Воскресенье Понедельник Вторник Среда Четверг Пятница Суббота}
  MONTHS = %w{января февраля марта апреля мая июня июля августа сентября октября ноября декабря}
  
  def header_date
    "%s,<br />%d %s %d" % [
      WEEK_DAYS[Time.now.wday],
      Time.now.day,
      MONTHS[Time.now.month - 1],
      Time.now.year
    ]
  end

  def modal_link_to(name, url, options = {})
    link_to(name, url, options.merge(
      :onclick => "jQuery.get(jQuery(this).attr('href'), function(data) { jQuery.facebox(data) }); return false;"
    )) 
  end

  def calendar_block(options = {})
    options.reverse_merge!(
      :container_id => :calendar,
      :container_class => :calendar,
      :start_date     => Time.at(0).to_date,
      :end_date       => Date.today,
      :selected_date  => Date.today,
      :active_days    => [],
      :binging_url    => ""
    )

    [:start_date, :end_date, :selected_date].each do |key|
      options[key] = Date.parse_or_default(options[key].to_s, Date.today) unless options[key].is_a?(Date)
    end
    
    metadata.merge(
      :stylesheets => "jquery.datePicker.css",
      :javascripts => ["jquery.date.js", "jquery.date.ru.js", "jquery.datePicker.js"]
    )

    content_tag(:div, "", :id => options[:container_id], :class => options[:container_class]) +
    javascript_tag("
      jQuery(document).ready(function(){
        var #{ options[:container_id] }_active_days = #{options[:active_days].to_json};

        jQuery('##{ options[:container_id] }').datePicker({
          inline:       true,
          startDate:    '#{ options[:start_date].strftime('%d/%m/%Y') }',
          endDate:      '#{ options[:end_date].strftime('%d/%m/%Y') }',
          selectedDate: Date.fromString('#{ options[:selected_date].strftime('%d/%m/%Y') }'),
          renderCallback: function($td, date, month, year){
            if(jQuery.inArray(date.asString('yyyy/mm/dd'), #{ options[:container_id] }_active_days) != -1){
              $td.addClass('active');
            }else{
              $td.addClass('disabled');
            }
          }
        }).bind('dateSelected', function(e, selectedDate, $td){
          var url = '#{ options[:binding_url] }'.replace(':date', selectedDate.asString('yyyy-mm-dd'));

          if( !window.location.toString().match(new RegExp(url, 'i')) ){
            window.location = url;
          }
        });

      });
    ")
  end

  def section_block(section_alias, options = {})
    if section = Section.find_by_alias(section_alias)
      render(
        :partial  => "layouts/section_block",
        :locals   => {:section => section, :options => options}
      )
    end
  end

  def blog_block(section_alias, options = {})
    if section = Section.find_by_alias(section_alias)
      render(
        :partial  => "layouts/blog_block",
        :locals   => {:section => section, :options => options}
      )
    end
  end
end