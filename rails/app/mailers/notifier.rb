class Notifier < ActionMailer::Base
  default from: ::ActionMailer::Base.smtp_settings[:user_name]
  #smtp_setting = ::YAML.load_file("#{::Rails.root}/config/mail.yml").to_options
  #::ActionMailer::Base.smtp_settings = smtp_setting

  # send ten days overdate primers notify
  def tendaysover_primers client
    @client = client
    #content_type = 'text/html'
    #render 'notifier/tendaysover_primers'
    mail to: client.email, subject: t('notifier.tendaysover_primers.title') do |format|
      format.html
    end
  end

  # send order mail
  def send_order_mail order_mail
    @order = order_mail.order
    client = @order.client
    report = @order.to_pdf(order_mail.type, creator_id: order_mail.creator_id)
    @type_text = t(order_mail.type, scope: [:notifier, :send_order_mail])
    subject = "SinoGene #{t('activerecord.models.order')}#{@order.sn}#{@type_text}#{t(:report, scope: [:orders, :pdf])}"
    attachments["#{@type_text}.pdf"] = report.render
    if order_mail.type == :quality
      zip = @order.to_zip include_r: false
      attachments["#{@order.sn}.zip"] = zip.read
      #attachments["#{order.sn}.zip"] = {
      #  mime_type: 'application/zip',
      #  content: zip.read,
      #  content_type: 'application/zip'
      #}
    end
    if !client.emails.blank?
      to = client.emails.split(',')
      to << client.email unless client.emails.include?(client.email)
    else
      to = client.email
    end
    mail to: to, subject: subject
  end

  # notify client that the samples are received
  def send_receive_sample order_mail
    @order = order_mail.order
    client = @order.client
    subject = "#{t('order_mails.type.receive_sample')} #{t('activerecord.attributes.order.sn')}: #{@order.sn}"
    mail to: to, subject: subject
  end
end
