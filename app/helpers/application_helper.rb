module ApplicationHelper

  def new_or_edit_path(model)
    model.new_record? ? send("new_#{model.model_name.singular}_path", model) : send("edit_#{model.model_name.singular}_path", model)
  end

  def sanitize_string(string)
    string.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').upcase.to_s
  end

  def format_day_or_month(day_or_month)
    day_or_month.to_s.rjust(2, '0')
  end

  def format_date(date)
    date = date.to_datetime if date.is_a? String
    if date
      date.to_s(:human)
    else
    	"Não Informado"
    end
  end

  def format_datetime(datetime)
    if datetime
      datetime.to_s(:datehourminute)
    else
      "Não Informado"
    end
  end

  def format_time(time)
    time.to_s(:hourminute)
  end

  def format_boolean(boolean)
    boolean ? "Sim" : "Não"
  end

  def format_money(unit="R$", money)
    number_to_currency(money, unit: unit, separator: ',', delimiter: '.').to_s.strip
  end

  def format_percentage(percentage)
    number_to_currency(percentage, unit: '', precision: 2).strip + "%"
  end

  def format_weight(weight, unit="kg")
    number_to_currency(weight, unit: '', precision: 2).strip + " " + unit
  end

  def format_documento(documento)
    if documento.size == 11
      documento =~ /(\d{3})?(\d{3})?(\d{3})(\d{2})/
      documento = "#{$1}.#{$2}.#{$3}-#{$4}"
    elsif documento.size == 14
      documento =~ /(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/
      documento = "#{$1}.#{$2}.#{$3}/#{$4}-#{$5}"
    else
      documento
    end
  end

  def format_phone(phone)
    if phone.present?
      if phone.size == 10
        phone =~ /(\d{2})(\d{4})(\d{4})/
        phone = "(#{$1}) #{$2}-#{$3}"
      elsif phone.size == 11
        phone =~ /(\d{2})(\d{1})(\d{4})(\d{4})/
        phone = "(#{$1}) #{$2} #{$3}-#{$4}"
      else
        phone
      end
    end
  end

  def custom_bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      type = 'success' if type == 'notice'
      type = 'error'   if type == 'alert'
      text = "<script>toastr.#{type}('#{message}');</script>"
      flash_messages << text.html_safe if message
    end
    flash_messages.join("\n").html_safe
  end

  def select2_editable(f, symbol, value, list, multiple = false)
    script = []
    script << f.select(symbol, list, {include_blank: true} , {id: "#{symbol.to_s}-editable", :multiple => multiple, class: "form-control select2"})
    script << "<script>$('##{symbol.to_s}-editable').val(#{value});</script>"
    script.join("\n").html_safe
  end

  def last_saturday
    last_saturday = DateTime.now - DateTime.now.wday-1
  end

  def last_monday
    last_saturday = DateTime.now - DateTime.now.wday-1
    last_monday = last_saturday - 5
  end

  def avatar_url(user, size=64)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=identicon"
  end

  def label_status(status)
    if status
      "<span class='tag is-success'>Ativo</span>".html_safe
    else
      "<span class='tag is-danger'>Ativo</span>".html_safe
    end
  end

  def translate_lado(lado)
    if lado == "ct"
      "<span class='tag is-info'>Contra-Terroristas</span>".html_safe
    elsif lado == "t"
      "<span class='tag is-danger'>Terroristas</span>".html_safe
    else
      "<span class='tag'>Não Informado</span>".html_safe
    end
  end

  def imagem_mapa_url(map)
    if map.imagem_stored?
      map.imagem.url
    else
      "http://cszim.com.br/img/#{map.sigla}.jpg"
    end
  end

end
